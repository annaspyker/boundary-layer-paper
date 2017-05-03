function x = compareHour(hour, kidsonHour, j)

    % if month is between 01-09
    if (length(kidsonHour{j}) == 1)
        if (strcmp(hour(1:1), kidsonHour{j}))
            x = 1;
        else 
            x = 0;
        end
    % if month is between 10-24
    elseif (length(kidsonHour{j}) == 2)
        if (strcmp(hour(1:2), kidsonHour{j}))
            x = 1;
        else 
            x = 0;
        end
    end
    
end
