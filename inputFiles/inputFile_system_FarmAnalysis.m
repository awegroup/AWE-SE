% Inputs sheet: MW scale
inputs                = struct();
inputs.name           = 'inputSheet_for_farm_analysis';

inputs.numDeltaLelems  = 4; %[num]
inputs.vertWindProfile = 0; % 0 = Modelled, 1 = From dataset 
inputs.FgToggle        = 1; % 0 = No, 1 = Yes

inputs.vw_ref         = 3:1:25; %[m/s]
inputs.h_ref          = 100; %[m]
inputs.windShearExp   = 0; %[-] % 0.143 over land, 0.11 over sea

inputs.S              = 100; %[m^2]
inputs.AR             = 12; %[-]
inputs.b              = sqrt(inputs.AR*inputs.S);
inputs.P_ratedElec    = 1000*1000; %[W]
inputs.massOverride   = 0;
inputs.kiteMass       = 600; %[kg]
inputs.peakM2E_F      = 2.5; %[-]

inputs.Ft_max            = 3*inputs.S*1000; %[N]
inputs.Ft_max_SF         = 1; % 0.8 for gust margin
inputs.maxTeLen          = 3000; %[m]
inputs.maxHeight         = 1000; %[m]
inputs.minGroundClear    = 100; %[m] 
inputs.Te_matStrength    = 5e8; % Engineering guess considering tether replacement costs. SHould be between 0.6 to 0.8 GPa
inputs.Te_matDensity     = 970; %[kg/m^3] 

inputs.Cl_maxAirfoil  = 2.5; %[-] % 2.7
inputs.Cl_eff_F       = 1; %[-] % 0.8
inputs.Cl0_airfoil    = 0.65; %[-]
inputs.e              = 0.6; %[-] % 0.6
inputs.Cd0            = 0.056; %[-]
inputs.Cd_c           = 1; %[-] % 1.1?

inputs.v_d_max       = 20; %[m/s]
inputs.a_d_max       = 5; %[m/s]

inputs.etaGen.param   = [0.671, -1.4141, 0.9747, 0.7233]; %[-]
inputs.etaGen.v_max   = inputs.v_d_max; %[m/s] % Or can enter a value from supplier
inputs.etaGearbox     = 0.95; %[-]
inputs.etaSto         = 0.95; %[-]
inputs.etaPE          = 0.95; %[-] % Power electronics

inputs.gravity        = 9.81; %[m/s^2]
inputs.airDensity     = 1.225; %[kg/m^3]  

% Optimisation problem data
inputs.nx = ones(1,inputs.numDeltaLelems);
% Initial guess
%               [deltaL, avgPattEle,  coneAngle,     Rp_start,         v_i,                      CL_i,                                           v_o,           kinematicRatio, CL]
inputs.x0     = [200,    deg2rad(30), deg2rad(5),   5*inputs.b,       inputs.v_d_max*inputs.nx, inputs.Cl_maxAirfoil*inputs.Cl_eff_F*inputs.nx, 0.8*inputs.nx, 90*inputs.nx,   inputs.Cl_maxAirfoil*inputs.Cl_eff_F*inputs.nx];

% Bounds
inputs.lb     = [50,   deg2rad(1),  deg2rad(1),  5*inputs.b,  1*inputs.nx, 0.1*inputs.nx, 0.8*inputs.nx, 1*inputs.nx, 0.1*inputs.nx]; % 
inputs.ub     = [500,  deg2rad(90), deg2rad(60), 500, inputs.v_d_max*inputs.nx, inputs.Cl_maxAirfoil*inputs.Cl_eff_F*inputs.nx,...
  inputs.v_d_max*inputs.nx,  200*inputs.nx, inputs.Cl_maxAirfoil*inputs.Cl_eff_F*inputs.nx]; %


