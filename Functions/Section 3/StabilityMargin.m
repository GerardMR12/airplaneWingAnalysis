function [sMargin] = StabilityMargin(XCG,XAC,mac,WS,WING_XPOS,PLANE_LENGTH)

% Stability margin
sMargin = (XAC-XCG)./(mac*WS);

% Print margin
fprintf('The stability margin is %.4f.\n',sMargin)

% Create vectors
Xac = XAC-WING_XPOS;
WING_XPOS_vec = linspace(0,PLANE_LENGTH);
sMargin_vec = (Xac+WING_XPOS_vec-XCG)./(mac*WS);

% Plot results
figure
plot(WING_XPOS_vec,sMargin_vec,'LineWidth',1)
line([0 WING_XPOS],[sMargin sMargin],'Color','black','LineStyle','--')
line([WING_XPOS WING_XPOS],[min(sMargin_vec) sMargin],'Color','black','LineStyle','--')
title('Stability margin over wing x position','FontSize',16)
xlabel('x position of the wing','FontSize',12)
ylabel('sm','FontSize',12)
ylim([min(sMargin_vec) max(sMargin_vec)])
s = sprintf('Stability margin');
s1 = sprintf('sm = %.4f at X_{CG} = %.2f',sMargin,XCG);
legend(s,s1)
grid minor

end