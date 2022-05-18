function [y1_, f_res] = GA_FindYs(x_1, x_2, f_1, f_2, n = 6)

  #
  #CONSTANTS
  #
  DOTSHIFT = 0.25;
  PRECISION = 0.05;
  OUTER_MARGIN = 0.5;
  INNER_MARGIN = 0.25;
  MAXITER = 1000;
  GRAPHING_T = floor(MAXITER / 1);
  DOT_DISTANCE = 0.01;
  IDLE_ITERATION_GAP = 50;
  IDLE_SHIFT_REDUCE = 0.5;

  #
  #SETUP
  #
  f_res = [];
  x_1xs = x_1(linspace(0, 2*pi, n)');
  x_2xs = x_2(linspace(0, 2*pi, n)');
  #Set half of dots outside x_1 and other inside x_2
  y1_ = ...
  [...
  (@(t) (1 + OUTER_MARGIN) * x_1(t))(linspace(0, 2*pi, ceil(n/2)+1)')(1:end-1,:);... #OUTSIDE
  (@(t) (1 - INNER_MARGIN) * x_2(t))(linspace(0, 2*pi, floor(n/2)+1)')(1:end-1,:)... #INSIDE
  ]; #Derogate 1.01 times x_1 (Ideally, deviate by 1 from x_1)
  #Some pre-graphing
  close;
  boundariesPlot = PlotBoundaries(x_1, x_2); hold on;
  set(boundariesPlot,{'LineWidth'},{1;1})
  dotsPlot = PlotDots(y1_);
  #Setup for MAIN
  u1_n = MFR(x_1, x_2, y1_, f_1, f_2, n);

  #
  #MAIN
  #
  last_change_iteration = 1;
  for iter = 1:MAXITER
    if(mod(iter - last_change_iteration, IDLE_ITERATION_GAP) == 0)
      DOTSHIFT = DOTSHIFT * IDLE_SHIFT_REDUCE
    endif
    u2_n = u1_n;
    y2_ = y1_;
    for ii = 1:size(y1_,1) #For each dot in y1_
      tic();
      while true #Do this
        y1_(ii,1) = y2_(ii,1) + rand()*DOTSHIFT*2 - DOTSHIFT;
        y1_(ii,2) = y2_(ii,2) + rand()*DOTSHIFT*2 - DOTSHIFT;
        tic();
        isdotInArea1 = IsDotInCircle(y1_(ii,:), 2); #IsDotInArea(y1_(ii,:), x_1);
        #disp(sprintf("toc : %d dot in Area1 : %d",ii, toc()));
        tic();
        isdotInArea2 = IsDotInCircle(y1_(ii,:), 1 - INNER_MARGIN/2); ; #IsDotInArea(y1_(ii,:), x_2);
        #disp(sprintf("toc : %d dot in Area2 : %d",ii, toc()));
        tic();
        otherDots = [y1_(1:ii-1,:); y1_(ii+1:end,:)];
        isDistancesOk = all(DotDist(y1_(ii,:), otherDots) > DOT_DISTANCE);
        #disp(sprintf("toc : %d dot Distances : %d",ii, toc()));
        if((!isdotInArea1 || isdotInArea2) && isDistancesOk)
            break;
        endif
      endwhile
      #disp(sprintf("%d -th dot toc : %d",ii, toc()));
    endfor
    u1_n = MFR(x_1, x_2, y1_, f_1, f_2, n);
    #Plot boundaries and dots(every GRAPHING_T iterations)
    if(mod(iter, GRAPHING_T) == 0)
      dotsPlot = PlotDots(y1_, dotsPlot);
    endif
    #Exit condition
    if((norm(u1_n(x_1xs) - f_1(x_1xs)) < PRECISION &&... #Ok for f_1 on x_1
        norm(u1_n(x_2xs) - f_2(x_2xs)) < PRECISION))#Also ok for f_2 on x_2  #Consider iterations limit
      disp('Go to exit...');
      break;
    endif
    #Fitting (Average between solutions of k-th iteration > Average -||- of k+1-th iteration )
    if(f(u1_n, f_1, f_2, x_1, x_2) > f(u2_n, f_1, f_2, x_1, x_2))
      u1_n = u2_n;
      y1_ = y2_;
    else
      last_change_iteration = iter;
      f_res = [f_res ;[iter, f(u1_n, f_1, f_2, x_1, x_2)]];
      disp(sprintf("f_res = %d; iter = %d", f_res(end, 2), f_res(end, 1)))
    endif
  endfor
endfunction
