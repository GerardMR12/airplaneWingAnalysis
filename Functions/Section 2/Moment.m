function [XAC,CM0,dCMLE] = Moment(CMLE,CL,mac,WS,plotON,WING_XPOS)

% Find the polynomial
p1 = polyfit (CL, CMLE, 1);
x1 = polyval (p1, CL);
CM0 = p1(2);
dCMLE = p1(1);

if plotON
    figure
    plot(CL,CMLE,'o','LineWidth',1)
    xlabel('C_L (deg)','FontSize',12)
    ylabel('C_{MLE}','FontSize',12)
    title('Horseshoe C_{MLE} over C_L','FontSize',16)
    hold on
    plot(CL,x1,'LineWidth',1)
    grid minor
    s1 = sprintf('Linear regression: %1.6f + (%1.6f) x', CM0, dCMLE);
    legend('Horseshoe', s1)
end

% Aerodynamic center
Xac = -dCMLE*mac*WS;

% Aerodnamic center respect to entire plane
XAC = Xac + WING_XPOS;

end
