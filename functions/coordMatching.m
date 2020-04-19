% This function returns the row indices of the Xline and Yline vectors of
% the closest configuration to Xveh and Yveh vectors (according to
% euclidean distances).

% Creation : Mathieu Delannoy / RENAULT - 2020

function indMatch = coordMatching(Xveh,Yveh,Xline,Yline)
    indMatch = [];
    for i=1:length(Xveh)
        distances = sqrt(sum(([Xveh(i) Yveh(i)] -[Xline Yline]).^2,2));
        [dist indMin] = min(distances);
        indMatch = [indMatch
                    indMin];
    end
end