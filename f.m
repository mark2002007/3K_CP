function res = f(u, f_1, f_2, x_1, x_2)
  n = 10;
  x_1xs = x_1(linspace(0, 2*pi, n)');
  x_2xs = x_2(linspace(0, 2*pi, n)');
  res = sqrt(norm(u(x_1xs) - f_1(x_1xs))^2 + norm(u(x_2xs) - f_2(x_2xs))^2);
endfunction