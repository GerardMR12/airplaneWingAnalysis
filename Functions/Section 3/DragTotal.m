function [CD0_total,total_area] = DragTotal(CD0,k1,k2,CLalpha,alphaL0,CD_FL,CD_HS,CD_VS,alpha_SCLn,alpha_SCL1,alpha_SCL2,AREA,AREA_FL,AREA_HS,AREA_VS)

% Compute the CD curve over aoa
alpha = linspace(-10,20,200);
total_area = AREA + AREA_FL + AREA_HS + AREA_VS;
CL = CLalpha.*(alpha-alphaL0);
CD0_total = (AREA_FL*CD_FL + AREA_HS*CD_HS + AREA_VS*CD_VS + AREA*CD0)/total_area;
CD = CD0_total + k1.*CL + k2.*CL.^2;

% Find key values
CL_n = CLalpha*(alpha_SCLn-alphaL0);
CD_n = CD0_total + k1*CL_n + k2*CL_n^2;
CL_1 = CLalpha*(alpha_SCL1-alphaL0);
CD_1 = CD0_total + k1*CL_1 + k2*CL_1^2;
CL_2 = CLalpha*(alpha_SCL2-alphaL0);
CD_2 = CD0_total + k1*CL_2 + k2*CL_2^2;

% Plot curve
figure
plot(alpha,CD,'LineWidth',1)
hold on

% Lines for safety factors (horizontal)
line([alpha(1) alpha_SCLn],[CD_n CD_n],'Color','red','LineStyle','--')
line([alpha(1) alpha_SCL1],[CD_1 CD_1],'Color',"#EDB120",'LineStyle','--')
line([alpha(1) alpha_SCL2],[CD_2 CD_2],'Color',"#77AC30",'LineStyle','--')

% Lines for safety factors (vertical)
line([alpha_SCLn alpha_SCLn],[0 CD_n],'Color','red','LineStyle','--')
line([alpha_SCL1 alpha_SCL1],[0 CD_1],'Color',"#EDB120",'LineStyle','--')
line([alpha_SCL2 alpha_SCL2],[0 CD_2],'Color',"#77AC30",'LineStyle','--')

% Other plot features
xlabel('\alpha (deg)','FontSize',12)
ylabel('C_D','FontSize',12)
ylim([0,max(CD)])
title('C_D over \alpha','FontSize',16)
grid minor
s = sprintf('C_D (Minimum C_D is %.2f)',CD0);
s1 = sprintf('C_D is %.3f at AOA=%.2fº',CD_n,alpha_SCLn);
s2 = sprintf('C_D is %.3f at AOA=%.2fº',CD_1,alpha_SCL1);
s3 = sprintf('C_D is %.3f at AOA=%.2fº',CD_2,alpha_SCL2);
legend(s,s1,s2,s3)

% Print incidence angle required
fprintf('  CDs are %.5f, %.5f, %.5f.\n',CD_n,CD_1,CD_2)

end