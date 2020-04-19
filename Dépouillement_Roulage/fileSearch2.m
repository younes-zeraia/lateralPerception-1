function Fichiers = fileSearch2(top_folder, extension)
folders = regexp(genpath(top_folder),('[^;]*'),'match');
f = 0;
Fichiers = '';
for folder = folders
    matfiles = dir(fullfile(folder{1}, extension));
    for file = matfiles'
        f = f + 1;
        matfilepath = fullfile(folder{1}, file(1).name);
        Fichiers(f).name = file(1).name;
        Fichiers(f).path = folder{1};
        Fichiers(f).date = file(1).date;
        Fichiers(f).bytes = file(1).bytes;
    end
end
