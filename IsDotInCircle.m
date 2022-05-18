function res = IsDotInCircle(dot, r, circle_origin = [0, 0])
  res = sqrt((dot(1) - circle_origin(1))^2 + (dot(2) - circle_origin(2))^2) <= r;
endfunction  