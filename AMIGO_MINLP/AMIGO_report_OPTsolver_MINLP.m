% $Header: svn://.../trunk/AMIGO2R2016/Postprocessor/Post_Report/AMIGO_report_OPTsolver.m 1813 2014-07-14 14:53:39Z attila $
% AMIGO_report_OPTsolver: reports options selected by the user for the OPT
% solver
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%
%*****************************************************************************%
%                                                                             %
% AMIGO_report_OPTsolver: reports options selected by the user for the OPT    %
%                         solver                                              %
%                                                                             %
%*****************************************************************************%
% global reports

fid=fopen(inputs.pathd.report,'a+');
fprintf(fid,'\n\n-------------------------------\n');
fprintf(fid,'Optimisation related active settings\n');
fprintf(fid,'-------------------------------\n');
   
switch minlpsolver

    case {'Nomad','nomad'}

        fprintf(fid,'\n\n------> Global MINLP Optimizer: Nonlinear Optimisarion by Mesh Adaptive Direct Search\n');
        fprintf(fid,'\n\t\t>Summary of selected nomad options: \n');
        fprintf(1,'\n\t\t>Summary of selected nomad options: \n');

%         fprintf(1,'\n\t\t  maxtime = %d; maxeval= %d;  local solver= %s; \n\n',...
%             inputs.nlpsol.eSS.maxtime, inputs.nlpsol.eSS.maxeval, inputs.nlpsol.eSS.local.solver);
% 
%         fprintf(fid,'\n\t\t  maxtime = %d; maxeval= %d;  local solver= %s; \n\n',...
%             inputs.nlpsol.eSS.maxtime, inputs.nlpsol.eSS.maxeval, inputs.nlpsol.eSS.local.solver);
        nomad_options = inputs.minlpsol.nomad;
        AMIGO_displayStruct(nomad_options,1,1)
        AMIGO_displayStruct(nomad_options,fid,1)
        
%         reports.optimisation.algorithm = 'ess';
%         reports.optimisation.type = 'hybrid';
%         reports.optimisation.algorithm_settings = inputs.nlpsol.eSS;
        
        
%         fprintf(fid,'\n\t\t\t%s options: \n',inputs.nlpsol.eSS.local.solver);
%         fprintf(1  ,'\n\t\t\t%s options: \n',inputs.nlpsol.eSS.local.solver);

end

fclose(fid);