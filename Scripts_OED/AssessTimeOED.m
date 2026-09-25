

figure
hold on
for i = 1:100
    
    tmp = load(['Run_',num2str(i), '.mat']);
    stairs(tmp.oedRes.minlpsol.neval, tmp.oedRes.minlpsol.f)
    
end

set(gca, 'YScale', 'log')


lt = zeros(2,100);
le = zeros(2,100);
for i = 1:100
    
    tmp = load(['Run_',num2str(i), '.mat']);
    lt(:,i) = tmp.oedRes.minlpsol.time(end-1:end)/60/60;
    le(:,i) = tmp.oedRes.minlpsol.neval(end-1:end);
    
end



tmp.oedRes.minlpsol.time(end)/60/60