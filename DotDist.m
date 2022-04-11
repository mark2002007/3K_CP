function res = DotDist(dot, dots)
  res = sqrt(sum((dots - dot).^2, 2));
endfunction