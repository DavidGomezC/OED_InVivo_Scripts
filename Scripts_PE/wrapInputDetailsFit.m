function [fit_res] = wrapInputDetailsFit(fit_res, k)

            
    IPTG = fit_res.exps{k}.IPTGfull;
    tim = fit_res.exps{k}.time;
    inp = IPTG(1);
    evnT = tim(1);

    for i = 2:length(IPTG)
        if IPTG(i) ~= IPTG(i-1)
            inp = [inp, IPTG(i)];
            evnT = [evnT, tim(i)];
        end
    end
    evnT = [evnT, tim(end)];

    fit_res.exps{k}.inp = inp;
    fit_res.exps{k}.evnT = evnT;
            
            

end