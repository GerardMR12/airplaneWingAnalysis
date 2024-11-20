function [stall_angle,Cl_alpha_root,alpha_l0_root,Cl_alpha_tip,alpha_l0_tip,Cd0_tip,Cd0_root,k1_tip,k2_tip,k1_root,k2_root,Clmax] = ExperimentalAnalysis(AIRFOIL,Re_root,Re_tip)

path = AIRFOIL + " Re=" + Re_root + "M.txt";
t1 = readtable(path,'ReadRowNames',false); % Root
t1 = table2array(t1(:,1:5));

path = AIRFOIL + " Re=" + Re_tip + "M.txt";
t2 = readtable(path,'ReadRowNames',false); % Tip
t2 = table2array(t2(:,1:5));

% Cut the vectors at low angles
min_angle = -6.0;
K1 = t1(:,1) == min_angle;
i1 = find(K1);
K2 = t2(:,1) == min_angle;
i2 = find(K2);

for i = 1:i1
    t1(i1-i+1,:) = [];
end

for i = 1:i2
    t2(i2-i+1,:) = [];
end

alpha_root = t1(:,1); 
Cl_root = t1(:,2);
Cd_root = t1(:,3);
Cdp_root = t1(:,4);
Cm_root = t1(:,5);

[Clmax,Clmax_pos] = max(Cl_root);
stall_angle = alpha_root(Clmax_pos,1);

alpha_tip = t2(:,1); 
Cl_tip = t2(:,2);
Cd_tip = t2(:,3);
Cdp_tip = t2(:,4);
Cm_tip = t2(:,5);

% Plot E(alpha) based on root's alpha
figure
E = Cl_root./Cd_root;
[maxE, imax] = max(E);
plot(alpha_root,E,'LineWidth',1);
xlabel('\alpha (deg)','FontSize',12);
ylabel('Efficiency','FontSize',12);
title('Efficiency of the airfoil','FontSize',16);
grid minor
yline(maxE,'--','Color','k')
s = sprintf('e_{max} = e(%2.2fº) = %2.2f',alpha_root(imax),maxE);
legend('Experimental ' + AIRFOIL,s)

% Cut the Cl vectors near loss
further_index = -5;
[K1, i1] = max(Cl_root);
[K2, i2] = max(Cl_root);

for i = (i1+further_index):size(Cl_root)
    Cl_root(i1+further_index) = [];
    Cd_root(i1+further_index) = [];
    alpha_root(i1+further_index) = [];
end

for i = (i2+further_index):size(Cl_tip)
    Cl_tip(i2+further_index) = [];
    Cd_tip(i2+further_index) = [];
    alpha_tip(i2+further_index) = [];
end

% Plot Cl(alpha) at root
figure
plot(alpha_root,Cl_root,'LineWidth',1);
xlabel('\alpha (deg)','FontSize',12);
ylabel('C_l','FontSize',12);
title(AIRFOIL + ' data C_l over \alpha at root','FontSize',16);
p1 = polyfit(alpha_root,Cl_root,1);
x1 = polyval(p1,alpha_root);
hold on
plot(alpha_root,x1,'LineWidth',1);
grid minor; 
s1 = sprintf('Linear regression: %.6f + %.6f x',p1(2),p1(1));
legend('Experimental ' + AIRFOIL,s1);

Cl_alpha_root = p1(2);
alpha_l0_root = - p1(1)/p1(2);

% Plot Cl(alpha) at tip
figure
plot(alpha_tip,Cl_tip,'LineWidth',1);
xlabel('\alpha (deg)','FontSize',12);
ylabel('C_l','FontSize',12);
title(AIRFOIL + ' data C_l over \alpha at tip','FontSize',16);
p3 = polyfit(alpha_tip,Cl_tip,1);
x3 = polyval(p3,alpha_tip);
hold on
plot(alpha_tip,x3,'LineWidth',1);
grid minor; 
s3 = sprintf('Linear regression: %.6f + %.6f x',p3(2),p3(1));
legend('Experimental ' + AIRFOIL,s3);

Cl_alpha_tip = p3(2); % con el Re 2
alpha_l0_tip = - p3(1)/p3(2);

% Plot Cd(Cl) at root
figure
plot(Cl_root,Cd_root,'LineWidth',1);
xlabel('C_l','FontSize',12);
ylabel('C_d','FontSize',12);
maxD = max(Cd_root);
ylim([0 maxD])
title(AIRFOIL + ' data C_d over C_l at root','FontSize',16);
p2 = polyfit(Cl_root,Cd_root,2);
x2 = polyval(p2,Cl_root);
hold on
plot(Cl_root,x2,'LineWidth',1);
grid minor; 
s2 = sprintf('Quadratic regression: %.6f + %.6f x + %.6f x^2',p2(3),p2(2),p2(1));
legend('Experimental ' + AIRFOIL,s2);

Cd0_root = p2(3);
k1_root = p2(2);
k2_root = p2(1);

% Plot Cd(Cl) at tip
figure
plot(Cl_tip,Cd_tip,'LineWidth',1);
xlabel('C_l','FontSize',12);
ylabel('C_d','FontSize',12);
maxD = max(Cd_tip);
ylim([0 maxD])
title(AIRFOIL + ' data C_d over C_l at tip','FontSize',16);
p4 = polyfit(Cl_tip,Cd_tip,2);
x4 = polyval(p4,Cl_tip);
hold on
plot(Cl_tip,x4,'LineWidth',1);
grid minor; 
s4 = sprintf('Quadratic regression: %.6f + %.6f x + %.6f x^2',p4(3),p4(2),p4(1));
legend('Experimental ' + AIRFOIL,s4);

Cd0_tip = p4(3);
k1_tip = p4(2);
k2_tip = p4(1);

end

