function inp = eco_system_inputs_awePower(inputs, processedOutputs)

  global eco_settings
  
  eco_settings.name             = 'example';
  eco_settings.input_cost_file  = 'eco_cost_inputs_GG_fixed.xlsx'; % set the input file
  eco_settings.input_model_file = 'code'; % code || set the input file
  eco_settings.power            = 'GG';  % FG || GG 
  eco_settings.wing             = 'fixed';  % fixed || soft
  
  % Wind conditions
  atm.k = 2;
  atm.A = 8/(gamma(1+1/atm.k));
  
  % Business related quantities
  inp.business.N_y     = 25; % project years
  inp.business.r_d     = 0.08; % cost of debt
  inp.business.r_e     = 0.12; % cost of equity
  inp.business.TaxRate = 0.25; % Tax rate (25%)
  inp.business.DtoE    = 70/30; % Debt-Equity-ratio      
                          
  % Wind resources
  inp.atm.wind_range = inputs.vw_ref(1):processedOutputs.vw_100m_operRange(end); % m/s
  inp.atm.gw         = atm.k/atm.A *(inp.atm.wind_range/atm.A).^(atm.k-1).*exp(-(inp.atm.wind_range/atm.A).^atm.k); % Wind distribution
  
  % Kite
  inp.kite.structure.m            = processedOutputs.m_k; % kg
  inp.kite.structure.A            = inputs.S; % m^2
  inp.kite.structure.f_repl       = 0; % /year
  inp.kite.obGen.P                = 1e3; % W
  inp.kite.obBatt.E               = inp.kite.obGen.P/1e3; % kWh
  
  % Tether
  inp.tether.d      = processedOutputs.Dia_te; % m
  inp.tether.L      = max(processedOutputs.l_t_max); %m
  inp.tether.rho    = inputs.Te_matDensity; % kg/m^3
  inp.tether.f_repl = -1; % /year
  
  % System
  inp.system.F_t       = mean(processedOutputs.Ft,2)'; % N
%   inp.system.P_m_peak  = inputs.peakM2E_F * inputs.P_ratedElec; % W
  inp.system.P_m_peak  = max(processedOutputs.P_m_o); % W
  inp.system.P_e_avg   = processedOutputs.P_e_avg; % W
%   inp.system.P_e_rated = inputs.P_ratedElec; % W
  inp.system.P_e_rated = max(processedOutputs.P_e_avg); % W
  inp.system.Dt_cycle  = processedOutputs.tCycle; % s
  
  % Ground station
  inp.gStation.ultracap.E_rated = 1.1*max(processedOutputs.storageExchange)/1e3; % kWh % 10% oversizing safety factor
  inp.gStation.ultracap.E_ex    = processedOutputs.storageExchange./1e3; % kWh
  inp.gStation.ultracap.f_repl  = -1; % /year
  inp.gStation.batt.E_rated     = max((processedOutputs.P_m_avg+processedOutputs.P_m_i))/1e3; % kWh
  inp.gStation.batt.E_ex        = processedOutputs.storageExchange./1e3; % kWh
  inp.gStation.batt.f_repl      = -1; % /year
  inp.gStation.hydAccum.E_rated = inp.gStation.ultracap.E_rated ;  % kWh
  inp.gStation.hydAccum.E_ex    = inp.gStation.ultracap.E_ex; % kWh
  inp.gStation.hydAccum.f_repl  = -1; % /year
  inp.gStation.hydMotor.f_repl  = 0; % /year
  inp.gStation.pumpMotor.f_repl = 0; % /year

end