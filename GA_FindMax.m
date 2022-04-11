function GA_FindMax()
  # population = {1, 2, 3} -> population -> {{1,1,...},{2,2,...},{3,3,...}} 
  #
  f = @(x) sin(x) + cos(x).^8;
  a = 0;
  b = 3.1;
  n = 20;
  m = 50;
  xs = linspace(a,b,n);

  accuracy = 3;
  expected = 1.064;
  mutation = 0.01;

  draw_plot_period = 3;
  max_iterations = 1000;
  
  xms = linspace(a, b, m);
  plot(xms, f(xms)); hold on; scatter(xs, f(xs)); hold off;#PREPLOT
  iteration = 1;
  while(true)
    #OUTPUT
    mn = mean(xs);
    clc
    printf("Iter : %d; Mean : (%d, %d);", iteration, mn, f(mn))
    xs
    
    if mod(iteration, draw_plot_period) == 0
      plot(xms, f(xms)); hold on; scatter(xs, f(xs)); hold off;
    endif
    pause(1);
    #MUTATION
    for ii = 1:n
      if round(rand) == 0
        xs(ii) += mutation;
      else 
        xs(ii) -= mutation;
      endif
    endfor
    #SELECTION
    xs = sortrows([f(xs); xs]')(:,2)';
    xs(1:n/2) = xs(n/2+1:end);
    #CONDITION
    if (round(f(mn)*(10^accuracy))/(10^accuracy) == expected || iteration > max_iterations)
      break;
    endif
    iteration += 1;
  endwhile
  printf("DONE!\n")
endfunction