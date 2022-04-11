clear; clc; close;
pkg load symbolic;
warning('off','all');
#axis equal
#SETUP
n = 6;
f_1 = @(xy)(@(x, y) x + y)(xy(:,1),xy(:,2));
f_2 = @(xy)(@(x, y) (x + y).^2 )(xy(:,1),xy(:,2));
x_1 = @(t)2*[cos(t) sin(t)];
x_2 = @(t)[cos(t) sin(t)];
#y_ = (@(t)3*[sin(t) cos(t)])(linspace(0,2*pi,n)');
#MAIN
y_ = GA_FindYs(x_1, x_2, f_1, f_2, n);
u_n = MFR(x_1, x_2, y_, f_1, f_2, n);
PLOT
xms1 = x_1(linspace(0, 2*pi, 100)');
xms2 = x_2(linspace(0, 2*pi, 100)');
plot3(xms1(:,1), xms1(:,2), u_n(xms1));
hold on;
plot3(xms2(:,1), xms2(:,2), u_n(xms2));