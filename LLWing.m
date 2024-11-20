% -------------------------------------------------------------------------     
% PROGRAM LLWING: Weissinger lifting-line method for trapezoidal wings
% Lifting line solution section developed by Enrique Ortega (e.ortega@upc.edu)
% Aerospace Projects
% -------------------------------------------------------------------------     

clc; clear; close all;
format long;

addpath(genpath("./Functions"));
addpath("./Workspaces");

% -------------------------------------------------------------------------
% INPUT DATA
% -------------------------------------------------------------------------

% Wing planform (assumes planar wing)
AIRFOIL = "naca4412"; % specific airfoil
SITUATION = "cruise"; % cruise, takeoff of takeoff4000
MTOW = 28300; % maximum take-off weight (kg)
G = 9.81; % gravity on Earth's surface assuming invariable (m/s^2)
WS = 32 - 2.8; % wingspan (m) (total wingspan allowed minus fuselage)
AREA = 69.41; % wing area (m^2)
SLATS = 18; % slats area (m^2)
TR = 0.8; % taper ratio
DE25 = 3.0; % sweep angle at c/4 (deg)
ETIP = 2.0; % tip twist (deg, negative for washout)
PLANE_LENGTH = 27; % total length of the plane (m)
WING_XPOS = 0.472*PLANE_LENGTH; % position of root's leading edge (m)
XCG = 0.478*PLANE_LENGTH; % center of gravity position from root's LE (m)

% Plane parameters
CD_FL = 0.00830; % drag coefficient of the fuselage
CD_HS = 0.00160; % drag coefficient of the horizontal stabilizer
CD_VS = 0.00160; % drag coefficient of the vertical stabilizer
AREA_FL = (PLANE_LENGTH-2)*2.8; % area of the fuselage
AREA_HS = 13.64; % area of the horizontal stabilizer
AREA_VS = 16.19; % area of the vertical stabilizer

% Air parameters
RHO0 = 1.225; % air density at H = 0 km (kg/m^3)
RHO4000 = 0.8190; % air density at H = 4 km (kg/m^3)
RHO5460 = 0.7000; % air density at H = 5.46 km (kg/m^3)
RHO7600 = 0.5500; % air density at H = 7.6 km (kg/m^3)

% Engineering parameters
SF1 = 1.1; % first safety factor
SF2 = 1.2; % second safety factor

% Flap/aileron (symmetrical deflection)
YF_pos = [0.02 0.72]; % 2y/WS initial and final position of flap in half-wing
CF_ratio = 0.15; % flap/chord ratio
DE_flap = 9; % flap deflection (deg, positive: down)
FlapCorr = 0.85; % flap effectiviness (<=1)

% The Reynolds number and density depend on the flight conditions
if(SITUATION=="cruise")
    Re_root = "1"; % in millions
    Re_tip = "1"; % in millions
    RHO = RHO7600; % air density (kg/m^3)
    design_speed = 110; % speed to achieve (m/s)
    SCL_needed = 2*MTOW*G/(RHO*design_speed^2);
    DE_flap = 0.0; % no flap deflection during cruise
elseif(SITUATION=="takeoff")
    Re_root = "1"; % in millions
    Re_tip = "1"; % in millions
    RHO = RHO0; % air density (kg/m^3)
    design_speed = 60; % speed to achieve (m/s)
    SCL_needed = 2*MTOW*G/(RHO*design_speed^2);
    AREA = AREA + SLATS; % additional area due to slats (m^2)
    WING_XPOS = WING_XPOS - SLATS*cos(deg2rad(DE25))/WS; % position (m)
elseif(SITUATION=="takeoff4000")
    Re_root = "1"; % in millions
    Re_tip = "1"; % in millions
    RHO = RHO4000; % air density (kg/m^3)
    design_speed = 75; % speed to achieve (m/s)
    SCL_needed = 2*MTOW*G/(RHO*design_speed^2);
    AREA = AREA + SLATS; % additional area due to slats (m^2)
    WING_XPOS = WING_XPOS - SLATS*cos(deg2rad(DE25))/WS; % position (m)
else
    fprintf('Wrong situation!\n')
    return
end

AR = WS^2/AREA; % aspect ratio

% Perform an experimental analysis of the given airfoil
[stall_angle,Cl_alpha_root,alpha_l0_root,Cl_alpha_tip,alpha_l0_tip,...
    Cd0_tip,Cd0_root,k1_tip,k2_tip,k1_root,k2_root,Clmax] = ...
    ExperimentalAnalysis(AIRFOIL,Re_root,Re_tip);

% Assign values to different parameters, once computed the analysis
A0p = [alpha_l0_root alpha_l0_tip]; % root and tip zero-lift angles (deg)

if(AIRFOIL=="naca4412")
    CM0p = [-0.110 -0.110]; % root and tip free moments
elseif(AIRFOIL=="naca63215")
    CM0p = [-0.075 -0.075]; % root and tip free moments
elseif(AIRFOIL=="naca63415")
    CM0p = [-0.080 -0.080]; % root and tip free moments
elseif(AIRFOIL=="naca63615")
    CM0p = [-0.085 -0.085]; % root and tip free moments
else
    fprintf('Wrong airfoil!\n')
    return
end

CDP = [Cd0_root k1_root k2_root; % root CD0, k1 and k2 (airfoil CD curve)
        Cd0_tip k1_tip k2_tip]; % tip CD0, k1 and k2

% Simulation data (by the time being only longitudinal analysis)
N = 100; % number of panels along the span

% Angles of attack for analysis
ALPHA = -10:2:16; % angles of attack (deg)

% -------------------------------------------------------------------------
% LIFTING LINE SOLUTION
% -------------------------------------------------------------------------

% Wing discretization (lenghts are dimensionless with the wing span)
[c4nods,c75nods,chord,s_pan,h,Cm0_y,normals,mac,S] = geo(AR,TR,N,DE25,...
    ETIP,A0p,CM0p,CDP,YF_pos,CF_ratio,DE_flap,FlapCorr,WS);

% Assembly of the influence coefficients matrix (needed once)
[inv_A,wake_len] = infcoeff(N,c4nods,c75nods,normals,h);

% Solve circulations for different angles of attack
[GAMMA,Ui,ncases] = getcirc(N,ALPHA,inv_A,normals);

% Loads calculation using the Kutta-Joukowsky theorem
[cl_local,force_coeff] = KuttaJoukowsky(N,c4nods,h,GAMMA,Ui,s_pan,Cm0_y,...
    chord,CDP,ncases,wake_len,S,mac,ALPHA);

% -------------------------------------------------------------------------
% POST-PROCESS
% -------------------------------------------------------------------------
% SECTION 2: Forces and moments computation
%--------------------------------------------------------------------------

% Set the coefficients
CL = force_coeff(7,:);
CD = force_coeff(11,:);
CMY = force_coeff(5,:);

% Find Lift curve
[CLalpha,alphaL0] = Lift(CL,ALPHA);

% Find the Heading Moment
[XAC,CM0,CMLE] = Moment(CMY,CL,mac,WS,1,WING_XPOS);

% Find the Lift Distributions
[cl_local_a,cl_local_b] = LiftDistributions(cl_local,ALPHA,CL,WS);

% Find the Drag curve
[CD0,k1,k2] = Drag(CD,CL);

% Get the moment from the CG
MomentFromCG(XCG,XAC,mac,CM0,CL,WS);

% -------------------------------------------------------------------------
% SECTION 3: Final calculations and flap analysis
%--------------------------------------------------------------------------

% Stability margin given a CG
[sMargin] = StabilityMargin(XCG,XAC,mac,WS,WING_XPOS,PLANE_LENGTH);

% Adjust parameters if necessary
WashoutDesign(CM0,XAC,mac,WS,true,AREA,MTOW,RHO,G,design_speed,XCG);

% Stall speed calculation
[stall_speed,CLmax] = StallSpeed(Clmax,cl_local_a,cl_local_b,WS,true,...
    AREA,MTOW,RHO,G);

% Get the SCL curve
[alpha_SCLn,alpha_SCL1,alpha_SCL2] = SCL(AREA,SCL_needed,CLalpha,...
    alphaL0,CLmax,SF1,SF2);

% Get the Drag curve versus the aoa
[CD0_total,total_area] = DragTotal(CD0,k1,k2,CLalpha,alphaL0,CD_FL,CD_HS,...
    CD_VS,alpha_SCLn,alpha_SCL1,alpha_SCL2,AREA,AREA_FL,AREA_HS,AREA_VS);

% Efficiency computation
[maxE,SpeedMaxE] = Efficiency(CD0,CD0_total,k1,k2,AREA,MTOW,RHO,G,...
    design_speed,total_area);

% -------------------------------------------------------------------------