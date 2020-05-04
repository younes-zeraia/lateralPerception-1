function results = testRecursive(n)
    if n>0
        results = n*testRecursive(n-1);
    else
        results = 1;
    end
end