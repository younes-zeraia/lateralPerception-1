% Concaténation de variable sur plusieurs workspaces différents
% condition: les wk dans le même fichiers
% Entré: direction fct et direction wk
% Sortie: wk total
% Younes ZERAIA / UTAC CERAM 2020 
%---------------------------------------------------------------------------------------------------------------------

function concatenation_acquis_3(directory_data)
    % directory_data=path;
    % directory_fct=directory_fct;
    directory=directory_data;

    F = filesearch(directory, 'mat');
    if isempty(F)
        fprintf('No mat file in directory\n');
    return;
    end

    log_total = struct();

    cd(directory);
    log = load(fullfile(F(1).path, F(1).name));
    vars = fieldnames(log);
    log_total = log;

    for n=2:length(F)
        if ~contains(F(n).name,'total.mat')
            log = load(fullfile(F(n).path, F(n).name));
            vars = fieldnames(log);
            
            for m=1:length(vars)
                if ~isequal(vars{m},'t')
                    log_total = setfield(log_total,vars{m},[getfield(log_total,vars{m});getfield(log,vars{m})]);
                else
                    log_total.t = [log_total.t;log.t+log_total.t(end)-floor(log.t(1))];
                end
            end      
        end
    end

    logNamesCommon = F(1).name(1:end-4);

    cd(directory);
    save([logNamesCommon '_total.mat'],'-struct','log_total');
end