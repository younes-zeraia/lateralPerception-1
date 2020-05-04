% This function is intended to merge 2 struct that have exactly the same
% fields
function s3 = mergeStructs(s1,s2)
    s3 = struct();
    fields = fieldnames(s1);
    for f = 1:length(fields)
        name = fields{f};
        val1 = getfield(s1,name);
        val2 = getfield(s2,name);
        
        if isstruct(val1)
            val3 = mergeStructs(val1,val2);
        elseif size(val1,1)>1
            val3 = [val1;val2];
        else
            val3 = nanmean([val1 val2]);
        end
        s3   = setfield(s3,name,val3);
    end
end
