function u_n = MFR(x_1, x_2, y_, f_1, f_2, n = 3)
  #Fundamental Solution
  F = @(x,y) 1 ./(2 .*pi).*log(1 ./vecnorm(x-y, 2, 2));
  #COMPUTE
  A = zeros(n, n);
  #A and b 
  for ii = 1:n/2
    for jj = 1:n
      A(ii, jj)     = F(x_1(4*pi*ii/n),y_(jj,:));
      A(ii + n/2, jj) = F(x_2(4*pi*ii/n),y_(jj,:));
      b(ii,1)       = f_1(x_1(4*pi*ii/n));
      b(ii + n/2,1)   = f_2(x_2(4*pi*ii/n));
    endfor
  endfor
  #Solve A*l = b
  l_ = A\b;
  #Find u_n
  u_n = @(xx)0;
  for j = 1:n
    u_n = @(xx) u_n(xx) + l_(j).*F(xx,y_(j,:));
  endfor
##  ts = linspace(0, 2*pi, 5)
##  x_1(ts')
##  u_n(x_1(ts'))
endfunction