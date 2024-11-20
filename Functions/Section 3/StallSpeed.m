function [stall_speed,CLmax] = StallSpeed(Clmax,cl_local_a,cl_local_b,WS,printSpeed,AREA,MTOW,RHO,G)

% Define variables to plot
y = linspace(-WS/2,WS/2,size(cl_local_a,1));
Clmax_vec = ones(size(cl_local_a,1),1)*Clmax;

% Plot CL(y) distribution
CL_stall = (Clmax*ones(size(cl_local_a,1),1) - cl_local_b)./(cl_local_a);

figure
hold on
plot(y,cl_local_b,y,cl_local_a,y,CL_stall,y,Clmax_vec,'LineWidth',1);
title('Distributions of C_{lb}, C_{la}, C_{L}, C_{lmax} and stall position','FontSize',16)
xlabel('y position (m)','FontSize',12)
ylabel('C_{lb}, C_{la}, C_{L}, C_{lmax}','FontSize',12)
grid minor

% Find CLmax and stall speed
[CLmax,stallPos] = min(CL_stall);
stall_speed = sqrt(2*MTOW*G/(RHO*CLmax*AREA));

xline(y(stallPos),'--');
yline(CLmax,'--');
s1 = sprintf('y_s = %2.2fm',abs(y(stallPos)));
s2 = sprintf('C_{Lmax} = %2.2f',CLmax);
legend({'C_{lb}','C_{la}','C_{L}','C_{lmax}',s1,s2})

if printSpeed
    fprintf('Stall speed is %.2f.\n',stall_speed)
    fprintf('Stall position is at %.2f from root.\n',y(stallPos)/(WS/2))
    fprintf('Maximum CL is %.2f.\n',CLmax)

end