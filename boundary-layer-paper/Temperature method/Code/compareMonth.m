function x = compareMonth(month, kidsonMonth, j)

    % if month is between 01-09
    if (length(kidsonMonth{j}) == 1)
        if (strcmp(month(2:2), kidsonMonth{j}))
            x = 1;
        else 
            x = 0;
        end
    % if month is between 10-12
    elseif (length(kidsonMonth{j}) == 2)
        if (strcmp(month(1:2), kidsonMonth{j}))
            x = 1;
        else
            x = 0;
        end
    end
    
end
