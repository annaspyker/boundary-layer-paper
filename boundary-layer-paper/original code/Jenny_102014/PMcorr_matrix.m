%function PMcorr_matrix

clear all;

daymean = zeros(366,12);
day = zeros(366,1);

daymean25 = zeros(366,5);
day25 = zeros(366,1);

pmdir = 'd:\Neuseeland\uni\data\';

pmfile = fullfile(pmdir, 'PM1hr_2012_nan.txt')
    fid=fopen(pmfile,'r');
    pmfield = textscan(fid,'%10c %5c %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'headerlines', 3);
    fclose(fid);

    date = pmfield{1,1};
    datezahl = datenum(date,'dd.mm.yyyy');
    time = pmfield{1,2};
    plottime = datenum([date,time],'dd.mm.yyyyHH:MM');
    
    pm10_Henderson = pmfield{1,3};
    pm10_Penrose = pmfield{1,4};
    pm25_Penrose = pmfield{1,5};
    pm10_Takapuna = pmfield{1,6};
    pm25_Takapuna = pmfield{1,7};
    pm10_Patumahoe = pmfield{1,8};
    pm10_Pakuranga = pmfield{1,9};
    pm10_Botany = pmfield{1,10};
    pm10_GlenEden = pmfield{1,11};
    pm10_Orewa = pmfield{1,12};
    pm25_Patumahoe = pmfield{1,13};
    pm10_Whangaparaoa = pmfield{1,14};
    pm25_Whangaparaoa = pmfield{1,15};
    pm10_MobilePOAL = pmfield{1,16};
    pm25_MobilePOAL = pmfield{1,17};
    pm10_KhyberPass = pmfield{1,18};
    pm10_Kumeu = pmfield{1,19};
    
    pm10matrix = [pm10_Henderson,pm10_Penrose,pm10_Takapuna,pm10_Patumahoe,pm10_Pakuranga,pm10_Botany,pm10_GlenEden,pm10_Orewa,...
        pm10_Whangaparaoa,pm10_MobilePOAL,pm10_KhyberPass,pm10_Kumeu];
    
    %calculate daily means
    [udatezahl, indf,n1] = unique(datezahl, 'first');
    [~,indl,n2] = unique(datezahl, 'last');
    length(indf);
    length(indl);
    jan1 = datenum('20120101','yyyymmdd');
    k = 1;
    for j = 1:366  %length(indf)
        sametime = find(udatezahl==(jan1-1+j));
        if ~isempty(sametime)
            pm10d = pm10matrix(indf(k):indl(k),:);
            for i = 1:12
                nonan = find(isnan(pm10d(:,i)) == 0);
                if length(nonan) >= 20
                    daymean(j,i) = mean(pm10d(nonan,i));
                    day(j) = udatezahl(k);
                else
                    daymean(j,i) = nan;
                    day(j) = jan1-1+j;
                end
            end
            k = k+1;
        else
            daymean(j,:) = nan;
            day(j) = jan1-1+j;
        end
    end
    
    %pm10m = num2str(pm10matrix);
    %pm10ma = str2num(pm10m);
    corrmatrix10 = corrcoef(pm10matrix,'rows','pairwise');
    corrmatrix10d = corrcoef(daymean,'rows','pairwise');
    pm10names = {'Henderson','Penrose','Takapuna','Patumahoe','Pakuranga','Botany','GlenEden','Orewa',...
        'Whangaparaoa','MobilePOAL','KhyberPass','Kumeu'};
    fid = fopen('d:\Neuseeland\uni\matfiles\corrfiles\PM10corr_2012.txt','w+');
    fprintf(fid, '%13s\n', ['            ','Henderson   ','Penrose   ','Takapuna   ','Patumahoe   ','Pakuranga   ','Botany   ','GlenEden   ','Orewa   ',...
        'Whangaparaoa   ','MobilePOAL   ','KhyberPass   ','Kumeu']);
    for i = 1:12
        fprintf(fid,'%s \t %5.2f  %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f %5.2f\n',char(pm10names{1,i}), corrmatrix10(i,:));
    end
    fclose(fid);
    
    pm25matrix = [pm25_Penrose,pm25_Takapuna,pm25_Patumahoe,pm25_Whangaparaoa,pm25_MobilePOAL];
    
    %calculate daily means
    [udatezahl25, indf25,n1_25] = unique(datezahl, 'first');
    [~,indl25,n2_25] = unique(datezahl, 'last');
    length(indf25);
    length(indl25);
    
    k = 1;
    for j = 1:366  %length(indf)
        sametime25 = find(udatezahl25==(jan1-1+j));
        if ~isempty(sametime25)
            pm25d = pm25matrix(indf25(k):indl25(k),:);
            for i = 1:5
                nonan25 = find(isnan(pm25d(:,i)) == 0);
                if length(nonan25) >= 20
                    daymean25(j,i) = mean(pm25d(nonan25,i));
                    day25(j) = udatezahl25(k);
                else
                    daymean25(j,i) = nan;
                    day25(j) = jan1-1+j;
                end
            end
            k = k+1;
        else
            daymean25(j,:) = nan;
            day25(j) = jan1-1+j;
        end
    end
    %pm25m = num2str(pm25matrix);
    %pm25ma = str2num(pm25m);
    corrmatrix25 = corrcoef(pm25matrix,'rows','pairwise');
    corrmatrix25d = corrcoef(daymean25,'rows','pairwise');
    pm25names = {'Penrose','Takapuna','Patumahoe','Whangaparaoa','MobilePOAL'};
    fid = fopen('d:\Neuseeland\uni\matfiles\corrfiles\PM25corr_2012.txt','w+');
    fprintf(fid, '%6s\n', ['            ','Penrose  ','Takapuna  ','Patumahoe  ','Whangaparaoa  ','MobilePOAL  ']);
    for i = 1:5
        fprintf(fid,'%s \t %5.2f  %5.2f %5.2f %5.2f %5.2f\n',char(pm25names{1,i}), corrmatrix25(i,:));
    end
    fclose(fid);
    
    clf;
    figure1 = figure(1);
    axes1 = axes('Parent',figure1,'YDir','reverse');
    bar3(corrmatrix10d)
    set(axes1, 'YTickLabel',{'Henderson','Penrose','Takapuna','Patumahoe','Pakuranga','Botany','GlenEden','Orewa',...
        'Whangaparaoa','MobilePOAL','KhyberPass','Kumeu'})
    set(axes1, 'YTick',[1 2 3 4 5 6 7 8 9 10 11 12])
    set(axes1, 'XTickLabel',{'Henderson','Penrose','Takapuna','Patumahoe','Pakuranga','Botany','GlenEden','Orewa',...
        'Whangaparaoa','MobilePOAL','KhyberPass','Kumeu'})
    set(axes1, 'XTick',[1 2 3 4 5 6 7 8 9 10 11 12])
    title('Correlation between PM10 measuring stations (2012)')
    
    figure2 = figure(2);
    axes2 = axes('Parent',figure2,'YDir','reverse');
    bar3(corrmatrix25d)
    set(axes2, 'YTickLabel',pm25names)
    set(axes2, 'YTick',[1 2 3 4 5])
    set(axes2, 'XTickLabel',pm25names)
    set(axes2, 'XTick',[1 2 3 4 5])
    title('Correlation between PM2.5 measuring stations (2012)')
    
