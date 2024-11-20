function [alpha_SCLn,alpha_SCL1,alpha_SCL2] = SCL(AREA,SCL_needed,CLalpha,alphaL0,CLmax,SF1,SF2)

% Compute the SCL
alpha = linspace(-10,20,200);
CL_curve = CLalpha.*(alpha-alphaL0);
SCL = AREA*CLalpha.*(alpha-alphaL0);
SCLmax = AREA*CLmax;

% x_fill = [alpha(1) alpha(1) alpha(size(alpha,2)) alpha(size(alpha,2))];
% y_fill = [SCLmax max(SCL) max(SCL) SCLmax];

A = SCL <= SCL_needed;
A1 = find(A,1,'last');

B = SCL <= SF1*SCL_needed;
B1 = find(B,1,'last');

C = SCL <= SF2*SCL_needed;
C1 = find(C,1,'last');

D = CL_curve <= CLmax;
D1 = find(D,1,'last');

stall_angle = alpha(D1);

% Plot curve
figure
plot(alpha,SCL,'LineWidth',1)
hold on

% Lines for safety factors (horizontal)
line([alpha(1) alpha(A1)],[SCL_needed SCL_needed],'Color','red','LineStyle','--')
line([alpha(1) alpha(B1)],SF1*[SCL_needed SCL_needed],'Color',"#EDB120",'LineStyle','--')
line([alpha(1) alpha(C1)],SF2*[SCL_needed SCL_needed],'Color',"#77AC30",'LineStyle','--')

% Maximum achieveable SCL
yline(SCLmax,'--','Color','k','LineWidth',3)
% fill(x_fill,y_fill,'k','FaceAlpha',0.1,'EdgeColor','none')

% Lines for safety factors (vertical)
line([alpha(A1) alpha(A1)],[SCL(1) SCL_needed],'Color','red','LineStyle','--')
line([alpha(B1) alpha(B1)],[SCL(1) SF1*SCL_needed],'Color',"#EDB120",'LineStyle','--')
line([alpha(C1) alpha(C1)],[SCL(1) SF2*SCL_needed],'Color',"#77AC30",'LineStyle','--')

% Other plot features
xlabel('\alpha (deg)','FontSize',12)
xlim([alpha(1) alpha(size(alpha,2))])
ylabel('SC_L','FontSize',12)
ylim([SCL(1) SCL(size(SCL,2))])
title('Surface C_L over \alpha','FontSize',16)
grid minor
s = sprintf('SC_L (Needed SC_L is %.2f m^2)',SCL_needed);
s1 = sprintf('AOA must be %.2fº for SF=%.1f',alpha(A1),1);
s2 = sprintf('AOA must be %.2fº for SF=%.1f',alpha(B1),SF1);
s3 = sprintf('AOA must be %.2fº for SF=%.1f',alpha(C1),SF2);
s4 = sprintf('SC_{L,max} is %.2f at AOA=%.2fº',SCLmax,stall_angle);
s5 = sprintf('SC_{L,max} is %.2f at AOA>%.2fº',SCLmax,stall_angle);
if stall_angle == 20
    legend(s,s1,s2,s3,s5)
else
    legend(s,s1,s2,s3,s4)
end

% Print incidence angle required
fprintf('SCL margin at SF=1 is %.2f.\n',SCLmax-SCL_needed)
fprintf('Safety factors are: %.1f, %.1f, %.1f.\n',1,SF1,SF2)
fprintf('  AOAs are %.2fº, %.2fº, %.2fº.\n',alpha(A1),alpha(B1),alpha(C1))

% Set values for CD analysis
alpha_SCLn = alpha(A1);
alpha_SCL1 = alpha(B1);
alpha_SCL2 = alpha(C1);

end