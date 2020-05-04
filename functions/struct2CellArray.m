% this function is intended to create cell array from structures (for
% synthesis)

function [headers values] = struct2CellArray(struct)
    fields = fieldnames(struct);
    headers = {};
    values  = {};
    for f=1:length(fields)
        name = fields{f};
        val  = getfield(struct,name);
        
        if isstruct(val)
            [subHeaders subValues] = struct2CellArray(val);
            
            for s = 1:length(subHeaders)
                if size(subValues{s}) == [1,1]
                    headers = [headers  {strcat(name,'_',subHeaders{s})}];
                    values  = [values   {subValues{s}}];
                elseif size(subValues{s}) == [1,0] | size(subValues{s}) == [0,1]
                    headers = [headers  {strcat(name,'_',subHeaders{s})}];
                    values  = [values   {NaN}];
                end
            end
            
        else
            if size(val) == [1,1]
                headers = [headers  {name}];
                values  = [values   {val}];
            elseif size(val) == [1,0] | size(val) == [0,1]
                headers = [headers  {name}];
                values  = [values   {NaN}];
            end
        end
    end
end
                