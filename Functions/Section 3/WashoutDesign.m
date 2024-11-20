function WashoutDesign(CM0,Xac,mac,WS,printCMcg,AREA,MTOW,RHO,G,design_speed,XCG)

% Find the design CL
design_CL = 2*MTOW*G/(RHO*design_speed^2*AREA);

% CM from CG at the design lift
CMcg = CM0 - design_CL*(Xac-XCG)/(mac*WS);

if printCMcg
    fprintf('CMcg at design lift is %1.4f.\n',CMcg);
end

end