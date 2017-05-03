function x = compareDay(day, kidsonDay, j)

    % if month is between 01-09
    if (length(kidsonDay{j}) == 1)
        if (strcmp(day(2:2), kidsonDay{j}))
            x = 1;
        else 
            x = 0;
        end
    % if month is between 10-31
    elseif (length(kidsonDay{j}) == 2)
        if (strcmp(day(1:2), kidsonDay{j}))
            x = 1;
        else 
            x = 0;
        end
    end
    
end
