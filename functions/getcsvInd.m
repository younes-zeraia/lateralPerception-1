% This function is intended to return the 
function csvInd = getcsvInd(hh,mm,ss,fCsv)
    csvInd = ((hh*60 + mm)*60 + ss)*fCsv;
end