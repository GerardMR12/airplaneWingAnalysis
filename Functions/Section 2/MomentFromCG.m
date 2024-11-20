function MomentFromCG(XCG,Xac,mac,CM0,CL,WS)

% Find the CMcg
CMcg = CM0*ones(1,size(CL,2)) - CL.*(Xac-XCG)/(mac*WS);

% Plot the result
figure
hold on
plot(CL,CMcg,'o','LineWidth',1)
title('C_{M,cg} over C_L curve','FontSize',16)
xlabel('C_L','FontSize',12)
ylabel('C_{M,cg}','FontSize',12)
grid minor

p = polyfit(CL,CMcg,1);
x = polyval(p,CL);
plot(CL,x,'LineWidth',1)
s = sprintf('Linear regression: %1.6f + (%1.6f) x',p(1),p(2));
legend('Results',s)
hold off

end