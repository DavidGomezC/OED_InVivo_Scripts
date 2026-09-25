function [Results] = MEIGO(problem,opts,algorithm,varargin)

algorithm = upper(algorithm);

if strcmpi(algorithm,'VNS')
    Results = rvnds_hamming(problem,opts,varargin{:});
elseif strcmpi(algorithm,'ESS')
    Results = ess_kernel_MINLP(problem,opts,varargin{:});
elseif strcmpi(algorithm,'MULTISTART')
    Results = ssm_multistart_MINLP(problem,opts,varargin{:});
elseif strcmpi(algorithm,'CESS')    
    Results = CeSS_MINLP(problem,opts);    
else
    fprintf('The method defined in "algorithm" is not valid \n');
    fprintf('Define a valid method (VNS, eSS, or CeSS) and rerun \n');
    Results=[];
end
