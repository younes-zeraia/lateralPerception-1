% Concaténation de variable sur plusieurs workspaces différents
% condition: les wk dans le même fichiers
% Entré: direction fct et direction wk
% Sortie: wk total
% Younes ZERAIA / UTAC CERAM 2020 
%---------------------------------------------------------------------------------------------------------------------

function concatenation_acquis_2(directory_data,directory_fct)
% directory_data=path;
% directory_fct=directory_fct;
directory=directory_data;
cd(directory_fct);

F = fileSearch2(directory, '*.mat');
if isempty(F)
    fprintf('No mat file in directory\n');
return;
end
cd(directory);
matFile = fullfile(F(1).path, F(1).name);
load(matFile);
var = whos( '-file', matFile );
for n=1:length(var)
eval(['tot_' var(n).name '=' var(n).name ';'])
end

for n=2:length(F)
    matFile = fullfile(F(n).path, F(n).name);
    load(matFile);
    var = whos( '-file', matFile );
    for m=1: length(var)
        if exist(var(m).name,'var')
            eval(['tot_' var(m).name '=cat(1,tot_' var(m).name ',' var(m).name ');'])
        end
    end      
end
clearvars  -except -regexp ^tot_ var directory_data NomEssai F directory_fct
for n=1:length(var)
    eval(['' var(n).name '=tot_' var(n).name ';'])
end
clearvars -regexp ^tot_ 
[x1,NomEssai,x3]=fileparts(F(length(F)).name);
NomEssai_total=strcat(NomEssai,'_total');
cd(directory_data)
clearvars x1 x3
save(NomEssai_total)
cd(directory_fct)
end