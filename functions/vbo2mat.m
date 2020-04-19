% Conversion des fichiers *.vbo issus d'acquisitions
% faites à l'aide de Racelogic Video Vbox et/ou VBOX3i
% en fichiers *.mat au format Matlab
% Convertit les fichiers vbo présents dans un dossier et dans ses sous-dossiers
% Dans chaque dossier :
% - crée un dossier 'mat' avec les fichiers mat lisibles dans Matlab (matrices)
% - crée un dossier 'plotsim' avec les fichiers mat lisibles avec plotsim (structures)

clear all;
close all;
clc;

% Sélectionner le dossier contenant les fichiers vbo d'acquis à traiter
directoryname = uigetdir('C:\Users\a029799\Desktop\Perception_Laterale\2_Essais','Dossiers où se trouvent les fichiers vbo à convertir');
if ~directoryname
    error('Pas de dossier d''acquisition sélectionné');
end

% Liste des fichiers de mesures au format VBOX (vbo)
List_file = filesearch(directoryname, 'vbo');

for fic = 1:length(List_file)
    fprintf('%u/%u %s\n', fic, length(List_file), fullfile(List_file(fic).path, List_file(fic).name) );
    if ~exist(fullfile(List_file(fic).path, 'mat', [List_file(fic).name(1:end-3) 'mat']), 'file') && List_file(fic).bytes % si le fichier mat n'existe pas
        fid = fopen(fullfile(List_file(fic).path, List_file(fic).name), 'r'); % ouverture en lecture des fichiers
        if fid ~= -1
            
            while ~feof(fid)
                
                tline = fgetl(fid);  % lit ligne à ligne le fichier .vbo
                if ~isempty(tline)
%                     fprintf('%s\n', tline);
                    chaines_caract = textscan(tline, '%s');
                    if strcmp(chaines_caract{1}(1) , '[column') % on recherche les noms de variable
                        
                        tline = fgetl(fid); % lecture de la ligne contenant les noms de variable
                        
                        chaines_var = textscan(tline, '%s'); % extraction des noms de variable dans la ligne lue
                        
                        for v = 1:length(chaines_var{1})
                            chaines_var{1}{v} = strrep(chaines_var{1}{v}, '-', '_'); % suppression des '-' dans les noms de variable
                            if strcmp(chaines_var{1}{v}(1),'_')
                                chaines_var{1}{v}(1) = 'a'; % remplacement des '_' en début des noms de variable
                            end
                        end
                        % pour renommer différemment les noms de variables identiques
                        for v = 1:length(chaines_var{1})
                            for w = v+1:length(chaines_var{1})
                                if strcmp(chaines_var{1}{v}, chaines_var{1}{w})
                                    chaines_var{1}{w} = [chaines_var{1}{v} '_2']; % ajout de '_2' en fin du nom de variable
                                end
                            end
                        end
                    end
                    
                    if strcmp(chaines_caract{1}(1) , '[data]') % on recherche le début des datas
                        for v = 1:length(chaines_var{1})
                            eval([chaines_var{1}{v} '=[];' ]) % initialisation des variables
                        end
                        lgn = 0; % numéro d'échantillon
                        while ~feof(fid)
                            tline = fgetl(fid); % lecture de la ligne contenant les valeurs numériques
                            if ~isempty(tline)
                                chaines_data = textscan(tline, '%s'); % extraction des valeurs numériques de la ligne lue
                                lgn = lgn + 1;
                                for v = 1:length(chaines_data{1})
                                    if ~strcmp(chaines_data{1}{v}, '+NAN') && ~strcmp(chaines_data{1}{v}, '-NAN')
                                        eval([chaines_var{1}{v} ' = [' chaines_var{1}{v} ' ; ' chaines_data{1}{v} '];']) % affectation des valeurs aux variables
                                    else
                                        eval([chaines_var{1}{v} ' = [' chaines_var{1}{v} ' ; 0 ];']) % affectation des valeurs aux variables
                                    end
                                end
                            else
                                fprintf('L''échantillon %u du fichier %s est vide\n', lgn, List_file(fic).name);
                            end
                        end
                    end
                end
            end
            
            fclose(fid); % fermeture du fichier vbo
            
            % sauvegarde du fichier au format Matlab (*.mat)
            if ~isdir(fullfile(List_file(fic).path, 'mat'))
                mkdir(fullfile(List_file(fic).path, 'mat'));
            end
            save(fullfile(List_file(fic).path, 'mat', [List_file(fic).name(1:end-3) 'mat']), chaines_var{1}{1});
            if length(chaines_var{1}) >= 2
                for v = 2:length(chaines_var{1})
                    save(fullfile(List_file(fic).path, 'mat', [List_file(fic).name(1:end-3) 'mat']), chaines_var{1}{v}, '-append');
                end
            end
            
            % sauvegarde du fichier au format plotsim (*.mat)
            per_ech = time(2)-time(1);
            for v = 1:length(chaines_data{1})
                eval(['pl_' chaines_var{1}{v} '=[(0:' num2str(per_ech) ':' num2str(per_ech) '*(length(time)-1))'' ' chaines_var{1}{v} '];']) % affectation des valeurs aux variables
                %         ['ps_' chaines_var{1}{v} '=[(0:' num2str(per_ech) ':' num2str(per_ech) '*(length(time)-1))'' ' chaines_var{1}{v} '];']
            end
            if ~isdir(fullfile(List_file(fic).path, 'plotsim'))
                mkdir(fullfile(List_file(fic).path, 'plotsim'));
            end
            save(fullfile(List_file(fic).path, 'plotsim', ['pl_' List_file(fic).name(1:end-3) 'mat']), ['pl_' chaines_var{1}{1}]);
            if length(chaines_var{1}) >= 2
                for v = 2:length(chaines_var{1})
                    save(fullfile(List_file(fic).path, 'plotsim', ['pl_' List_file(fic).name(1:end-3) 'mat']), ['pl_' chaines_var{1}{v}], '-append');
                end
            end
            
        else
            error('Erreur d''ouverture du fichier %s\n', char(List_file(fic).name));
        end
    else
        fprintf('Pas de conversion car le fichier %smat existe ou le fichier est vide\n', List_file(fic).name(1:end-3) );
    end
end

msgbox('Conversion vbo/mat des fichiers terminée', 'Fini !!!');
