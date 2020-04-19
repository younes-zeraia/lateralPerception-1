% this function is intended to create an .xls synthesis of each logs of a
% selected folder
function add2Synthesis(synthesisPath,synthesisName,commonSynthesis,processSynthesis)

    commonHeaders       = commonSynthesis(1,:);
    perfoHeaders        = processSynthesis(1,:);
    % Load synthesis .xlsx file and keep only the core synthesis
    [synthesis,rawSynthesis,headersLine] = readSynthesis(synthesisPath,synthesisName,commonHeaders);

    % Find out if a log already exists in the synthesis
    [logFound logLine] = findLogInSynthesis(synthesis,commonSynthesis);

    % If the log hasn't already been recorded, we add it at the end
    if logFound == false
        logLine     = size(synthesis,1)+1;
    end

    % Add Common synthesis to the original one
    synthesiswCommon    = addSynthesis(synthesis,commonSynthesis,logLine);

    % Add Performance synthesis
    synthesiswPerfo     = addSynthesis(synthesiswCommon,processSynthesis,logLine);
    
    synthesisNew        = synthesiswPerfo(logLine:logLine+size(commonSynthesis,1)-2,:);
    
    writeSynthesis(synthesisPath,synthesisName,synthesisNew,rawSynthesis,logLine);
end

%% Function
% Read Synthesis
function [synthesis,rawSynthesis,headersLine] = readSynthesis(synthesisPath,synthesisName,commonHeaders)
    [~,rawText,rawSynthesis] = xlsread(fullfile(synthesisPath,synthesisName));
    
    headersLine = getStartLine(rawText,commonHeaders);
    
    synthesis   = rawSynthesis(headersLine:end,:);
    for row = 2:size(synthesis,1)
        if isnan(synthesis{row,1})
                    row = row-1;
                    break;
        end
    end
    synthesis = synthesis(1:row,:);
end

function startLine = getStartLine(synthesis,headers)
    headerFound = false;
    
    h = 0;
    
    while headerFound==false && h<=size(headers,2)
        h = h+1;
        col = 0;
        while headerFound==false && col<=size(synthesis,2)
            col = col+1;
            headerFound = any(contains(synthesis(:,col),headers{h}));
        end
        
    end
    
    if headerFound
        startLine = find(contains(synthesis(:,col),headers{h}),1,'last');
    else
        error('No common headers found in the specified synthesis, can"t find the start line of the .xlsx');
    end
    
end
        
% This function is intended to find out if a log has already been recorded
% in a synthesis
% If it has been recorded, returns the corresponding line
% Inputs : Synthesis, commonHeaders
% Outputs:  logFound (boolean : true if the log already existed)
%           logLine (line of the recorded log if it already existed, if not, returns 0).

function [logFound logLine] = findLogInSynthesis(synthesis,commonSynthesis)
    commonHeaders       = commonSynthesis(1,:);
    synthesisHeaders    = synthesis(1,:);
    colLogName         = find(contains(commonHeaders,'canape file','IgnoreCase',true));
    fileName            = commonSynthesis{2,colLogName};
    colAnalysisType     = find(contains(commonHeaders,'analysis type','IgnoreCase',true));
    analysisType        = commonSynthesis{2,colAnalysisType};
    
    nLines = size(synthesis,1);
    colLogNames         = find(contains(synthesisHeaders,'canape file','IgnoreCase',true));
    colanalysisTypes        = find(contains(synthesisHeaders,'analysis type','IgnoreCase',true));
    
    if length(colLogNames)<1 || length(colanalysisTypes)<1
        error('No file name or analysis type headers found');
    end
    
    logFound    = false;
    logLine     = 0;
    indSameLogName  = find(contains(synthesis(2:end,colLogNames),fileName,'IgnoreCase',true));
    if length(indSameLogName)>0
        logLine = indSameLogName(find(contains(synthesis(indSameLogName,colanalysisTypes),analysisType,'IgnoreCase',true),1,'first'))+1;
        
        if length(logLine)==1
            logFound = true;
        end
    end
end

% Add synthesis

function synthesisNew    = addSynthesis(synthesis,localSynthesis,logLine)
    
    localSynthesisHeaders   = localSynthesis(1,:);
    synthesisHeaders        = synthesis(1,:);
    
    localSynthesisData      = localSynthesis(2:end,:);
    if size(synthesis,1)>=logLine+size(localSynthesisData,1)-1
        synthesisData       = synthesis(2:end,:);
    else
        synthesisData       = [synthesis(2:end,:);cell(size(localSynthesisData,1),size(synthesisHeaders,2))];
    end
    
    hSynthPrev = 1;
    addedHeaders = [];
    for h=1:size(localSynthesisHeaders,2)
        hSynth = find(contains(synthesisHeaders,localSynthesisHeaders{1,h},'IgnoreCase',true),1,'first');
        if length(hSynth)==0
            hSynth = hSynthPrev+1;
            synthesisData(:,hSynth+1:end+1) = synthesisData(:,hSynth:end);
            synthesisData(:,hSynth)         = cell(size(synthesisData,1),1);
            synthesisHeaders(:,hSynth+1:end+1) = synthesisHeaders(:,hSynth:end);
            synthesisHeaders{:,hSynth }        = localSynthesisHeaders{:,h}
            
            addedHeaders = [addedHeaders hSynth];
        end
        synthesisData(logLine-1:logLine+size(localSynthesisData,1)-2,hSynth)   = localSynthesisData(:,h);
        hSynthPrev = hSynth;
    end
    synthesisNew = [synthesisHeaders;synthesisData]
end

function writeSynthesis(synthesisPath,synthesisName,synthesisNew,rawSynthesis,logLine)
    sheet = 1;
    range = ['A',num2str(logLine),':AK',num2str(logLine+size(synthesisNew,1)-1)];
    xlswrite(fullfile(synthesisPath,synthesisName),synthesisNew,sheet,range);
end
    