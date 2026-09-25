

function [] = GenerateInputFileMicroscope_WithLocalSolver(oed_res, inputDesign)
    
    inps = oed_res.bestRun.oed.u{end}.*5;
        
    txtf = strcat(['   10800   ',num2str(inps(1)),'   ',num2str(inps(2)),'   ',num2str(inps(3)),'   ',num2str(inps(4)),...
        '   ',num2str(inps(5)),'   ',num2str(inps(6)),'   ',num2str(inps(7)),'   ',num2str(inps(8)),'']);
    
    if ~isfolder(".\ResultsOED\InputFiles")
        mkdir(".\ResultsOED\InputFiles")
    end
    
    fid = fopen( strjoin(['.\ResultsOED\InputFiles\OEDlocalInput_PLac_Iter',num2str(inputDesign),".txt"], ""), 'wt' );
    fprintf( fid, txtf);
    fclose(fid);        


end













