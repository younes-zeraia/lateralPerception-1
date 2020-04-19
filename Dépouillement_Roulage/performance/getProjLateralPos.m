% Function intended to compute projected lateral position given C0 C1 C2 C3
function projLateralPos = getProjLateralPos(C0,C1,C2,C3,distProj)
    projLateralPos = C0 + C1*distProj + C2*distProj^2 + C3*distProj^3;
end