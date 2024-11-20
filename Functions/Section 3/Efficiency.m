function [maxE, maxSpeed] = Efficiency(CD0,CD0_total,k1,k2,AREA,MTOW,RHO,G,design_speed,total_area)

% Define a space of speeds and coefficients
speeds = linspace(0,design_speed+120,design_speed+121);

% Find CL, CD and E
CL = 2*MTOW*G./(AREA*RHO.*speeds.^2);
CD = CD0 + k1.*CL + k2.*CL.^2;
CD_total = CD0_total + k1.*CL + k2.*CL.^2;
E = CL./CD;
E_total = (AREA.*CL)./(total_area.*CD_total);

[maxE, imax] = max(E);
maxSpeed = speeds(imax);

[maxE_total, imax_total] = max(E_total);
maxSpeed_total = speeds(imax_total);

% Plot results of the wings
figure
hold on
plot(speeds,E,'LineWidth',1)
yline(maxE,'--','Color','k')
title('Efficiency of the wing over speed','FontSize',16)
xlabel('Speed (m/s)','FontSize',12)
ylabel('Efficiency','FontSize',12)
grid minor
s1 = sprintf('E_{max} = E(%.0f m/s) = %.2f',maxSpeed,maxE);
legend('Efficiency',s1)

% Plot results of the plane
figure
hold on
plot(speeds,E_total,'LineWidth',1)
yline(maxE_total,'--','Color','k')
title('Efficiency of the plane over speed','FontSize',16)
xlabel('Speed (m/s)','FontSize',12)
ylabel('Efficiency','FontSize',12)
grid minor
s1 = sprintf('E_{max} = E(%.0f m/s) = %.2f',maxSpeed_total,maxE_total);
legend('Efficiency',s1)

% Plot results at certain range
min_range = design_speed-30;
max_range = design_speed+30;

% Plot a specific range of the efficiency of the wings
figure
hold on
plot(speeds,E,'LineWidth',1)
yline(maxE,'--','Color','k')
line([0 design_speed],[E(design_speed+1) E(design_speed+1)],'Color','r','LineStyle','--')
line([design_speed design_speed],[0 E(design_speed+1)],'Color','r','LineStyle','--')
title('Efficiency of the wing over speed','FontSize',16)
xlabel('Speed (m/s)','FontSize',12)
xlim([min_range max_range])
ylabel('Efficiency','FontSize',12)
ylim([E(design_speed+1)-2 maxE+0.4])
grid minor
s1 = sprintf('E_{max} = E(%.0f m/s) = %.2f',maxSpeed,maxE);
s2 = sprintf('E_{%.0f m/s} = E(%.0f m/s) = %.2f',design_speed,speeds(design_speed+1),E(design_speed+1));
legend('Efficiency',s1,s2)

% Plot a specific range of the efficiency of the plane
figure
hold on
plot(speeds,E_total,'LineWidth',1)
yline(maxE_total,'--','Color','k')
line([0 design_speed],[E_total(design_speed+1) E_total(design_speed+1)],'Color','r','LineStyle','--')
line([design_speed design_speed],[0 E_total(design_speed+1)],'Color','r','LineStyle','--')
title('Efficiency of the plane over speed','FontSize',16)
xlabel('Speed (m/s)','FontSize',12)
xlim([min_range max_range])
ylabel('Efficiency','FontSize',12)
ylim([E_total(design_speed+1)-2 maxE_total+0.4])
grid minor
s1 = sprintf('E_{max} = E(%.0f m/s) = %.2f',maxSpeed_total,maxE_total);
s2 = sprintf('E_{%.0f m/s} = E(%.0f m/s) = %.2f',design_speed,speeds(design_speed+1),E_total(design_speed+1));
legend('Efficiency',s1,s2)

end