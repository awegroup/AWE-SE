function [] = tetherDetailsPlots(paramName, paramUnit, designSpace)

  for i = 1:length(designSpace)
    opex(i)       = designSpace(i).ecoOutputs.tether.OPEX;
    capex(i)      = designSpace(i).ecoOutputs.tether.CAPEX;
    f_repl(i)     = designSpace(i).ecoOutputs.tether.f_repl;
    len_t(i)      = designSpace(i).ecoInputs.tether.L;
    dia_t(i)      = designSpace(i).ecoInputs.tether.d;
    paramValue(i) = designSpace(i).paramValue;
  end

  figure('Position', [50, 50, 1200, 400])
 
  subplot(1,2,1)
  hold on
  box on
  grid on
  yyaxis left
  plot(paramValue, opex,'--o');
  plot(paramValue,capex,'-s');
  ylabel('(€)');
  yyaxis right
  plot(paramValue,f_repl,'-x')
  ylabel('f_{repl} (/year)');
  legend('OPEX','CAPEX','f_{repl}','location','best');
  xlabel([paramName ' [' paramUnit ' ]']);
  hold off

  subplot(1,2,2)
  hold on
  box on
  grid on
  yyaxis left
  plot(paramValue,len_t,'-x');
  ylabel('Tether length (m)');
  yyaxis right
  plot(paramValue,dia_t,'-o')
  ylabel('Tether diameter (m)');
  xlabel([paramName ' [' paramUnit ' ]']);
  hold off

end