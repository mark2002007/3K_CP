function p = PlotBoundaries(x_1, x_2)
  x_1xms = x_1(linspace(0, 2*pi, 25)');
  x_2xms = x_2(linspace(0, 2*pi, 25)');
  p = plot(x_1xms(:,1), x_1xms(:,2), x_2xms(:,1), x_2xms(:,2));
endfunction