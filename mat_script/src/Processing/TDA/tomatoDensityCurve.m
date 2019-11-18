x = 0:0.05:12;
y1 = 2*sin(1/3*x-pi/2);
y2 = 2*sin(x-pi/2);

y = y1 + y2;
figure,
plot(y,'r-')


x2 = -pi/2:pi/10:pi/2;
y3 = cos(x2)

Y = y;
Y(150:160) = y(150:160) +y3;
figure,
plot(Y,'r-')



n = 0.2*randn(1,length(x));
Y_n = Y + n;

figure
plot(x,Y_n,'-s','MarkerFaceColor','b');
hold on;
plot(x,y,'r-','LineWidth',2);

figure
plot(x,Y_n,'-s','MarkerFaceColor','b');
hold on;
plot(x,Y,'r-','LineWidth',2);

