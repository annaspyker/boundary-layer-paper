function mlh = findtime(mlhtime, hour)

for k = 1:length(mlhtime)
    curr = datestr(timemlhnew(k));
    if (strcmp(curr(13:17),hour))
        mlh = curr;
        break;
    end
end