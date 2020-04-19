%% Function intended to read csv files
function csvFileTable = getcsvFileTable(fileName,startRow,endRow)
    %% Init CSV read opts
    opts = detectImportOptions(fileName);
    nVar = length(opts.VariableNames);
    delimiter = ';';
    
    %Specify formatSpec
    formatSpec = [];
    for v = 1:length(opts.VariableNames)
        formatSpec = [formatSpec '%s'];
    end
    formatSpec = [formatSpec '%[^\n\r]'];
    
    %% Open the text file.
    fileID = fopen(fileName,'r','n','UTF-8');
    % Skip the BOM (Byte Order Mark).
    fseek(fileID, 3, 'bof');
    dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', delimiter, 'HeaderLines', startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

    %% Convert the contents of columns containing numeric text to numbers.
%     % Replace non-numeric text with NaN.
%     raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
%     for col=1:length(dataArray)-1
%         raw(1:length(dataArray{col}),col) = dataArray{col};
%     end
%     numericData = NaN(size(dataArray{1},1),size(dataArray,2));
% 
%     for col=[2:nVar-4]
%         % Converts text in the input cell array to numbers. Replaced non-numeric
%         % text with NaN.
%         rawData = dataArray{col};
%         for row=1:size(rawData, 1);
%             % Create a regular expression to detect and remove non-numeric prefixes and
%             % suffixes.
%             regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\.]*)+[\,]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\.]*)*[\,]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
%             try
%                 result = regexp(rawData{row}, regexstr, 'names');
%                 numbers = result.numbers;
% 
%                 % Detected commas in non-thousand locations.
%                 invalidThousandsSeparator = false;
%                 if any(numbers=='.');
%                     thousandsRegExp = '^\d+?(\.\d{3})*\,{0,1}\d*$';
%                     if isempty(regexp(numbers, thousandsRegExp, 'once'));
%                         numbers = NaN;
%                         invalidThousandsSeparator = true;
%                     end
%                 end
%                 % Convert numeric text to numbers.
%                 if ~invalidThousandsSeparator;
%                     numbers = strrep(numbers, '.', '');
%                     numbers = strrep(numbers, ',', '.');
%                     numbers = textscan(numbers, '%f');
%                     numericData(row, col) = numbers{1};
%                     raw{row, col} = numbers{1};
%                 end
%             catch me
%             end
%         end
%     end
    
%     %% Split data into numeric and cell columns.
%     rawNumericColumns = raw(:, [2:nVar-4]);
%     rawCellColumns = raw(:, [1 nVar-3:nVar]);
    %% variable names format correction
    % retrieve underscores from variable names and low all characters (no
    % capitals)
    for v = 1:nVar
        noUnderScoreInd = find(opts.VariableNames{v} ~= '_');
        opts.VariableNames{v}       = [upper(opts.VariableNames{v}(noUnderScoreInd(1))) lower(opts.VariableNames{v}(noUnderScoreInd(2:end)))];
    end
    
    %% Allocate imported array to column variable names
    csvFileTable = struct();
    zerosToBeAdded = '00000000000000000000000000000000000000';
    for v = 1:nVar
        fieldName = opts.VariableNames{v};
        lengthVal = cellfun(@length, dataArray{1,v});
        maxLength = max(lengthVal);
        indSmallStr = find(lengthVal < maxLength);
        if length(indSmallStr)>0
            for d = indSmallStr'
                dataArray{1,v}{d,1} = [dataArray{1,v}{d,1} zerosToBeAdded(1:maxLength-lengthVal(d))];
            end
        end
            if v~=1
            value     = str2num(cell2mat(strrep(dataArray{1,v},',','.')));
        else
            value     = dataArray{v};
        end
        csvFileTable = setfield(csvFileTable,fieldName,value);
    end
end