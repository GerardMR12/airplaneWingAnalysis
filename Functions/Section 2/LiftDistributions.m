function [cl_local_a,cl_local_b] = LiftDistributions(cl_local,ALPHA,CL,WS)

cl_local_a_av = zeros(size(cl_local,1),1);
cl_local_b_av = zeros(size(cl_local,1),1);

% Plot the Cl(y)
y = linspace(-WS/2,WS/2,size(cl_local,1));

figure
hold on
for i = 1:size(ALPHA,2)
    plot(y,cl_local(:,i),'LineWidth',1)
    legendLocals{i} = append('\alpha = ',num2str(ALPHA(i)));
end

title('C_l(y) for different \alpha','FontSize',16)
xlabel('y position (m)','FontSize',12)
ylabel('C_l(y)','FontSize',12)
grid minor
legend(legendLocals{:})

% Cla for many combinations
figure
hold on
for i = 2:size(ALPHA,2)
    cl_local_a = (cl_local(:,i)-cl_local(:,i-1))/(CL(i)-CL(i-1));
    cl_local_a_av = cl_local_a_av + cl_local_a;
    plot(y,cl_local_a)
    legendCla{i} = append('Using \alpha = ',num2str(ALPHA(i)),' & ',num2str(ALPHA(i-1)));
end

% Final and averaged combination
cl_local_a_av = cl_local_a_av./(size(ALPHA,2)-1);
plot(y,cl_local_a_av,'LineWidth',1)

title('C_{la}(y) for several \alpha combinations','FontSize',16)
xlabel('y position (m)','FontSize',12)
ylabel('C_{la}(y)','FontSize',12)
grid minor
legend(legendCla{:},'Average distribution')

cl_local_a = cl_local_a_av;

% Clb with the average distribution of Cla
figure
hold on
for i = 1:size(ALPHA,2)
    cl_local_b = cl_local(:,i) - cl_local_a.*CL(i);
    cl_local_b_av = cl_local_b_av + cl_local_b;
    plot(y,cl_local_b)
    legendClb{i} = append('Using \alpha = ',num2str(ALPHA(i)));
end

cl_local_b_av = cl_local_b_av./size(ALPHA,2);
plot(y,cl_local_b_av,'LineWidth',1)
title('C_{lb}(y) for several \alpha combinations','FontSize',16)
xlabel('y position (m)','FontSize',12)
ylabel('C_{lb}(y)','FontSize',12)
grid minor
legend(legendClb{:},'Average distribution')

cl_local_b = cl_local_b_av;

% Both Cla and Clb
figure
plot(y,cl_local_b,y,cl_local_a,'LineWidth',1)
title('C_{lb}(y) and C_{la}(y)','FontSize',16)
xlabel('y position (m)','FontSize',12)
ylabel('C_{lb}, C_{la}','FontSize',12)
grid minor
legend('C_{lb}','C_{la}')

end