

function [] = GenerateInputFileMicroscopeOnLine_WithLocalSolver(oed_res, identifier)
    
    inps = oed_res.bestRun.oed.u{end}.*5;
        
    txtf = strcat(['   10800   ',num2str(inps(1)),'   ',num2str(inps(2)),'   ',num2str(inps(3)),'   ',num2str(inps(4)),...
        '   ',num2str(0),'   ',num2str(0),'   ',num2str(0),'   ',num2str(0),'']);
    
    if ~isfolder(".\ResultsOnLineOED\InputFiles")
        mkdir(".\ResultsOnLineOED\InputFiles")
    end
    
    fid = fopen( strjoin(['.\ResultsOnLineOED\InputFiles\OLOEDlocalInput_PLac_',identifier,".txt"], ""), 'wt' );
    fprintf( fid, txtf);
    fclose(fid);        


end













