function [CLalpha,alphaL0] = Lift(CL, ALPHA)

figure
plot(ALPHA,CL,'o','Linewidth',1);
xlabel('\alpha (deg)','FontSize',12);
ylabel('C_L','FontSize',12);
title('Horseshoe C_L over \alpha','FontSize',16);
p1 = polyfit (ALPHA, CL, 1);
x1 = polyval (p1, ALPHA);
hold on
plot(ALPHA, x1,'Linewidth',1);
grid minor

CLalpha = p1(1);
alphaL0 = -p1(2)/p1(1);
s1 = sprintf('Linear regression: %.6f + %.6f x', p1(2), p1(1));
legend('Horseshoe', s1);

end