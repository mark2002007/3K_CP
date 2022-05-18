#clear; clc; close;
pkg load symbolic;
warning('off','all');
hfig = figure;

n = 12;
f_1 = @(xy)(@(x, y) x + y)(xy(:,1),xy(:,2));
f_2 = @(xy)(@(x, y) (x + y).^2 )(xy(:,1),xy(:,2));
x_1 = @(t)2*[cos(t) sin(t)];
x_2 = @(t)[cos(t) sin(t)];

y_ = (@(t)3*[sin(t) cos(t)])(linspace(0,2*pi,n)');
[y_, f_res] = GA_FindYs(x_1, x_2, f_1, f_2, n);
u_n = MFR(x_1, x_2, y_, f_1, f_2, n);


#PLOT
xms1 = x_1(linspace(0, 2*pi, 100)');
xms2 = x_2(linspace(0, 2*pi, 100)');
[X, Y] = meshgrid(-6:0.1:6, -6:0.1:6);
Z = []
for ii = 1:size(X, 1)
  for jj = 1:size(X, 2)
    Z(ii, jj) = u_n([X(ii, jj), Y(ii, jj)]);
  endfor
endfor
surf(X, Y, Z);
hold on;
plot3(xms1(:,1), xms1(:,2), u_n(xms1), 'LineWidth', 2);
hold on;
plot3(xms2(:,1), xms2(:,2), u_n(xms2), 'LineWidth', 2);
#xlim([-4 4])
#ylim([-4 4])
#zlim([-6 6])
#  plot(f_res(:,1), f_res(:,2), '--o')
  #ToPDF
  xlabel('x');
  ylabel('y');
  zlabel('z');
  picturewidth = 20;
  hw_ratio = 0.65;
  set(findall(hfig, '-property', 'FontSize'), 'FontSize', 17);
  set(findall(hfig, '-property', 'Box'), 'Box', 'off');
  set(findall(hfig, '-property', 'Interpreter'), 'Interpreter', 'latex');
  set(findall(hfig, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex');
  set(hfig, 'Units', 'centimeters', 'Position', [3 3 picturewidth hw_ratio*picturewidth]);
  pos = get(hfig, 'Position');
  set(hfig, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)]);
  print(hfig, 'M100S', '-dpdf', '-painters', '-fillpage');
  movefile('M1000.pdf', 'docs');
  print(hfig, 'M1000', '-dpng', '-painters');
  movefile('M1000.png', 'docs')
