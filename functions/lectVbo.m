% Extraction de paramètres des fichiers *.vbo issus d'acquisitions
% faites à l'aide de la VIDEO VBOX et/ou VBOX3i
%
% Arnaud Serander / SEGULA Technologies

function Fichier = lectVbo(pathname, filename)

dtVbox = 2; % décalage horaire entre heure GPS et heure PC (heure)

fid = fopen(fullfile(pathname, filename), 'r'); % ouverture en lecture des fichiers
% fprintf('%s\n',fullfile(pathname, filename));
Fichier.path = pathname;
Fichier.name = filename;
listing = dir(fullfile(pathname, filename));
Fichier.bytes = listing.bytes;
Fichier.date = datestr(listing.date); % date d'enregistrement du fichier VBOX

if fid ~= -1
    line = 0 ;
    list_time_acquis = {0};
    line1 = fgetl(fid);
    
    chaines_caract = textscan(line1, '%s');
    Fichier.time_creat = chaines_caract{1}{6};  % extraction de l'heure de création du fichier vbo
    Fichier.date_creat = chaines_caract{1}{4};  % extraction de la date de création du fichier vbo
    
    
    while ~feof(fid)
        line = line+1;
        tline = fgetl(fid);  % lit ligne à ligne le fichier .m
        if ~isempty(tline)
            chaines_caract = textscan(tline, '%s');
            if strcmp(chaines_caract{1}(1) , '[comments]') % on recherche le type de matériel employé pour l'acquisition
                
                for k = 1:8
                    tline = fgetl(fid);
                    
                    if strfind(tline , 'Video VBox Version') % on regarde si le matériel employé pour l'acquisition est une Vbox video
                        chaines_caract = textscan(tline, '%s');
                        Fichier.type_materiel = char(chaines_caract{1}(1:2));
                        Fichier.version_materiel = chaines_caract{1}(5);
                    end
                    if strfind(tline , 'VB3i') % on regarde si le matériel employé pour l'acquisition est une Vbox 3i
                        chaines_caract = textscan(tline, '%s');
                        Fichier.type_materiel = chaines_caract{1}{1};
                        Fichier.version_materiel = [char(chaines_caract{1}(3)) ' ' char(chaines_caract{1}(4)) ' ' char(chaines_caract{1}(5))];
                    end
                    if strfind(lower(tline) , 'serial number :') % on regarde le numéro de série du matériel employé pour l'acquisition
                        chaines_caract = textscan(tline, '%s');
                        Fichier.serial_number = chaines_caract{1}{4};
                    end
                    if strfind(tline , 'Rate:') % on regarde le numéro de série du matériel employé pour l'acquisition
                        chaines_caract = textscan(tline, '%s');
                        Fichier.frequence_d_acquis = chaines_caract{1}{2};
                    end
                    
                    if strfind(tline , 'Log Rate (Hz) :') % on regarde le numéro de série du matériel employé pour l'acquisition
                        chaines_caract = textscan(tline, '%s');
                        Fichier.frequence_d_acquis = chaines_caract{1}{end};
                    end
                    
                end
                
            end
            
            if strcmp(chaines_caract{1}(1) , '[data]') % on recherche l'heure de début de l'acquisition
                lign = 1;
                
                while ~feof(fid)
                    tline = fgetl(fid);
                    chaines_caract = textscan(tline, '%s');
                    time_acquis = chaines_caract{1}(2);
                    time_acquis = [time_acquis{1}(1:2) ':' time_acquis{1}(3:4) ':' time_acquis{1}(5:6) '.' time_acquis{1}(8:9)];
                    Fichier.list_time_acquis{lign}= time_acquis;
                    lign = lign+1;
                end
                
                Fichier.time_start = datestr(addtodate(datenum(Fichier.list_time_acquis{1}), dtVbox, 'hour'));
                Fichier.time_start = Fichier.time_start(end-7:end);
                %                 Fichier.time_start = Fichier.list_time_acquis{1};
                
                Fichier.time_stop = datestr(addtodate(datenum(Fichier.list_time_acquis{end}), dtVbox, 'hour'));
                Fichier.time_stop = Fichier.time_stop(end-7:end);

%                 Fichier.time_end = Fichier.list_time_acquis{end};
                
            end
            
        end
        
    end
    
    fclose(fid);
else
    error('Erreur d''ouverture du fichier %s\n', fullfile(pathname, filename));
end
