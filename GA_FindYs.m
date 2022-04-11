function y1_ = GA_FindYs(x_1, x_2, f_1, f_2, n = 3)
  #CONSTANTS
  DOTSHIFT = 0.01;
  PRECISION = 0.05;
  OUTER_MARGIN = 0.5;
  INNER_MARGIN = 0.25;
  MAXITER = 10;
  GRAPHING_T = floor(MAXITER / 5);
  DOT_DISTANCE = 0.01
  #SETUP
  #Set half of dots outside x_1 and other inside x_2 
  y1_ = ...
  [...
  (@(t) (1 + OUTER_MARGIN) * x_1(t))(linspace(0, 2*pi, ceil(n/2)+1)')(1:end-1,:);... #OUTSIDE
  (@(t) (1 - INNER_MARGIN) * x_2(t))(linspace(0, 2*pi, floor(n/2)+1)')(1:end-1,:)... #INSIDE
  ] #Derogate 1.01 times x_1 (Ideally, deviate by 1 from x_1)
  #Some graphing
  close
  #Plot x_1
  x_1xms = x_1(linspace(0, 2*pi, 100)');
  plot(x_1xms(:,1), x_1xms(:,2));
  hold on;
  #Plot x_2
  x_2xms = x_2(linspace(0, 2*pi, 100)');
  plot(x_2xms(:,1), x_2xms(:,2));
  hold on;
  #Plot dots
  scatter(y1_(:,1), y1_(:,2));
  axis equal;
  #Setup for MAIN
  u1_n = MFR(x_1, x_2, y1_, f_1, f_2, n);
  counter = 1; #Counter of iterations
  #MAIN
  while true
    u2_n = u1_n;
    y2_ = y1_;
    for ii = 1:size(y1_,1) #For each dot in y1_
      while true #Do this
        for jj = 1:size(y1_,2) #For each coordinate of some dot
          y1_(ii,jj) = y2_(ii,jj) + rand()*DOTSHIFT*2 - DOTSHIFT; 
        endfor
        !IsDotInArea(y1_(ii,:), x_1)
        IsDotInArea(y1_(ii,:), x_2)
        if(!IsDotInArea(y1_(ii,:), x_1) &&... #Dot mush be outside x_1
            IsDotInArea(y1_(ii,:), x_2) &&... #And inside x_2
            all(DotDist(y1_(ii,:),...#Also keep distance with every other dot
              [y1_(1:ii-1,:); y1_(ii+1:end,:)]) > DOT_DISTANCE)... #
            ) #Check if everything OK
            break;
        endif
      endwhile
    endfor
    u1_n = MFR(x_1, x_2, y1_, f_1, f_2, n);
    x_1xs = x_1(linspace(0, 2*pi, n)');
    x_2xs = x_2(linspace(0, 2*pi, n)');
    #Some output
    norm(u1_n(x_1xs) - f_1(x_1xs))
    norm(u1_n(x_2xs) - f_2(x_2xs))
    counter
    #Plot boundaries and dots(every GRAPHING_T iterations)
    if(mod(counter, GRAPHING_T) == 0)
      close;
      x_1xms = x_1(linspace(0, 2*pi, 100)'); #Plot x_1
      plot(x_1xms(:,1), x_1xms(:,2));
      hold on;
      x_2xms = x_2(linspace(0, 2*pi, 100)'); #Plot x_2
      plot(x_2xms(:,1), x_2xms(:,2));
      scatter(y1_(:,1), y1_(:,2)); #Plot dots
      axis equal;
    endif
    #Exit condition
    if((norm(u1_n(x_1xs) - f_1(x_1xs)) < PRECISION &&... #Ok for f_1 on x_1
        norm(u1_n(x_2xs) - f_2(x_2xs)) < PRECISION) ||...#Also ok for f_2 on x_2
        counter > MAXITER)  #Consider iterations limit
      disp('Go to exit...');
      break;
    endif
    #Fitting (Average between solutions of k-th iteration > Average -||- of k+1-th iteration )
    if(norm(u1_n(x_1xs) - f_1(x_1xs)) + norm(u1_n(x_2xs) - f_2(x_2xs)) >...
       norm(u2_n(x_1xs) - f_1(x_1xs)) + norm(u2_n(x_2xs) - f_2(x_2xs)))
      disp('NOPE. Reverting...');
      u1_n = u2_n;
      y1_ = y2_;
      clc;
      norm(u1_n(x_1xs) - f_1(x_1xs));
      norm(u1_n(x_2xs) - f_2(x_2xs));
      counter;
    endif
    counter = counter + 1;
  endwhile
endfunction