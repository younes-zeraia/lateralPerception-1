% Fonction qui crée une liste des fichiers avec une extension donnée contenus dans un répertoire 
% les sous-répertoires sont également séléctionnés si la variable
% avecSousDossiers = 1 (ou si elle n'est pas modifiée).
%
% Création :        Arnaud Serander  / SEGULA Technologies 2013
% Modification :    Mathieu Delannoy / RENAULT 2020

function Fichiers = filesearch(chemin, extension, avecSousDossiers)
if nargin < 2
    error('Pas assez d''arguments');
elseif nargin < 3
    avecSousDossiers = 1; % On séléctionne aussi tous les sous-dossiers
else
    if avecSousDossiers~=0 && avecSousDossiers~=1
        error('La variable ''avecSousDossiers'' doit être égale à 0 ou 1 !');
    end
end
FichiersDossierNiveau0 = dir(fullfile(chemin,'*'));
if ~numel(FichiersDossierNiveau0)
    error(['Le dossier' chemin 'est vide.']);
end

if avecSousDossiers == 0
    dirFlags    = [FichiersDossierNiveau0.isdir] &...
                   ~strcmp({FichiersDossierNiveau0.name},'.') & ~strcmp({FichiersDossierNiveau0.name},'..');
    FichiersDossierNiveau0 = FichiersDossierNiveau0(~dirFlags);
end

NbFichiers = 0;
Fichiers = struct('path', {}, 'name', {}, 'date', {}, 'bytes', {});
for f0 = 3:numel(FichiersDossierNiveau0)
    switch FichiersDossierNiveau0(f0).isdir
        case 1
            FichiersDossierNiveau1 = dir(fullfile(chemin, FichiersDossierNiveau0(f0).name));
            for f1 = 3:numel(FichiersDossierNiveau1)
                switch FichiersDossierNiveau1(f1).isdir
                    case 1
                        FichiersDossierNiveau2 = dir(fullfile(chemin, FichiersDossierNiveau0(f0).name, FichiersDossierNiveau1(f1).name));
                        for f2 = 3:numel(FichiersDossierNiveau2)
                            switch FichiersDossierNiveau2(f2).isdir
                                case 1
                                case 0
                                    [~, ~, ext] = fileparts(FichiersDossierNiveau2(f2).name);
                                    if strcmpi(ext,['.' extension])
                                        NbFichiers = NbFichiers + 1;
                                        Fichiers(NbFichiers).name = FichiersDossierNiveau2(f2).name ;
                                        Fichiers(NbFichiers).path = fullfile(chemin , FichiersDossierNiveau0(f0).name , FichiersDossierNiveau1(f1).name);
                                        Fichiers(NbFichiers).date = FichiersDossierNiveau2(f2).date;
                                        Fichiers(NbFichiers).bytes = FichiersDossierNiveau2(f2).bytes;
                                    end
                            end
                        end
                    case 0
                        [~, ~, ext] = fileparts(FichiersDossierNiveau1(f1).name);
                        if strcmpi(ext,['.' extension])
                            NbFichiers = NbFichiers + 1;
                            Fichiers(NbFichiers).name = FichiersDossierNiveau1(f1).name ;
                            Fichiers(NbFichiers).path = fullfile( chemin , FichiersDossierNiveau0(f0).name );
                            Fichiers(NbFichiers).date = FichiersDossierNiveau1(f1).date;
                            Fichiers(NbFichiers).bytes = FichiersDossierNiveau1(f1).bytes;
                        end
                    end
                end
            case 0
                [~, ~, ext] = fileparts(FichiersDossierNiveau0(f0).name);
                if strcmpi(ext,['.' extension])
                    NbFichiers = NbFichiers + 1;
                    Fichiers(NbFichiers).name = FichiersDossierNiveau0(f0).name;
                    Fichiers(NbFichiers).path = chemin;
                    Fichiers(NbFichiers).date = FichiersDossierNiveau0(f0).date;
                    Fichiers(NbFichiers).bytes = FichiersDossierNiveau0(f0).bytes;
                end
        end
    end
    if ~numel(NbFichiers)
        error(['Les dossiers ne contiennent aucun fichier *.' extension]);
    end

end
