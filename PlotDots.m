function p = PlotDots(y_, previousPlot = '')
  if previousPlot != ''
    delete(previousPlot)
  endif
  p = scatter(y_(:,1), y_(:,2));
endfunction