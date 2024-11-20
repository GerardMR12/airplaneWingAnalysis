function [CD0,k1,k2] = Drag(CD,CL)

% Create a linearspace of angles
alphaSpace = linspace(CL(1),CL(end),100);

% Plot CD over CL
figure
hold on
plot(CL,CD,'o','LineWidth',1)

% Adjust curve
p = polyfit(CL,CD,2);
dragCurve = polyval(p,alphaSpace);
CD0 = p(3);
k1 = p(2);
k2 = p(1);
s = sprintf('Quadratic regression: %.6f + %.6f x + %.6f x^2',CD0,k1,k2);

% Plot the regression
plot(alphaSpace,dragCurve,'LineWidth',1)
title('C_D curve regression','FontSize',16)
xlabel('C_L','FontSize',12)
ylabel('C_D','FontSize',12)
grid minor
legend('Horseshoe',s)

end