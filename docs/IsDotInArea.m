function res = IsDotInArea(dot, x, T = 2*pi)
  sym_x = sym(x);
  #Check horizontaly
  dots = double(solve(sym_x(2) == dot(2)));
  on_the_left = sum(x(dots)(:,1) < dot(1));
  on_the_right = sum(x(dots)(:,1) > dot(1)) ;
  
  if(!(mod(on_the_left, 2) == 1 && on_the_left > 0))
    res = false;
    return 
  endif
  if(!(mod(on_the_right, 2) == 1 && on_the_right > 0))
    res = false;
    return
  endif
  #Check verticaly
  dots = double(solve(sym_x(1) == dot(1)));
  on_the_bottom = sum(x(dots)(:,2) < dot(2));
  on_the_top = sum(x(dots)(:,2) > dot(2));
  if(!(mod(on_the_bottom, 2) == 1 && on_the_bottom > 0))
    res = false;
    return 
  endif
  if(!(mod(on_the_top, 2) == 1 && on_the_top > 0))
    res = false;
    return
  endif
  res = true;
endfunction