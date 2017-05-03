function[data_mean,gradient_mean,gradient_meanneg,gradient2_mean,...
    grad,deltah,deltat,ind_ygrad,ind_xgrad,max_mlh,ind_gesamt,mlh_height,cld_height] = ...
    func_calcall(angle_tilt,height_meter,datahex,id,h,data_complete,a,b,a1,b1,sdate)

%--------------------------------------------------------------------------
%-----------Daten werden ueber Zeit und Hoehe gemittelt--------------------
%--------------------------------------------------------------------------

data_meanh=NaN(a1,b1);

%Normale Mittelung
hoehe00=140/h;   %Schichteneinteilung, 1. Höhe 140 m
hoehe1=500/h;    %2. Höhe 500 m
hoehe2=2000/h;   %3. Höhe 2000 m
deltah00=120/h;  %Mittelung über 120 m (+/- 60 m)
deltah1=160/h;   %über 160 m
deltah=200/h;    %über 200 m
deltat=100;      %Zeitliche Mittelung über 100 Profile (100*12=1200 sek)

%Spezielle, feinere Mittelung (Bsp Vulkanasche)
% hoehe00=140/h;
% hoehe1=500/h;
% hoehe2=2000/h;
% deltah00=40/h;
% deltah1=40/h;
% deltah=40/h;
% deltat=10;



for i=2:a1-deltah/2
    for j=1:b1
        if i>= deltah00/2+2 && i<hoehe00+2
            data_meanh(i,j) = sum(data_complete(i-deltah00/2:i+deltah00/2,j))/(deltah00+1);
        elseif i>=hoehe00+2 && i<=hoehe1+2
            data_meanh(i,j) = sum(data_complete(i-deltah00/2:i+deltah00/2,j))/(deltah00+1);
        elseif i> hoehe1+2 && i <= hoehe2+2
            data_meanh(i,j) = sum(data_complete(i-deltah1/2:i+deltah1/2,j))/(deltah1+1);
        elseif i> hoehe2+2
            data_meanh(i,j) = sum(data_complete(i-deltah/2:i+deltah/2,j))/(deltah+1);
        end
    end
end

% % % % % % % % % % % %DER UNTERE RAND WIRD GEMITTELT
% % % % % % % % % % % %Die Höhenwerte 2 bis deltah00/2+1 werden schrittweise gemittelt. von unten nach
% % % % % % % % % % % %oben: mittelwert aus 2, mittelwert aus (2:4), mittelwert aus (2:6),
% % % % % % % % % % % %mittelwert aus (2:8) .... mittelwert aus (2:deltah00+4-2i)
for i=2:deltah00/2+1
    for j=1:b1
        data_meanh(deltah00/2-i+3,j) = sum(data_complete(2:(deltah00-2*i+4),j))/((deltah00-2*i+4)-1);
    end
end


% % % % % % %DER OBERE RAND WIRD GEMITTELT
% % % % % % %Die Höhenwerte (a1-deltah/2+1) bis a1 werden schrittweise gemittelt. von unten nach
% % % % % % %oben: mittelwert aus (a1-deltah/2+1), mittelwert aus (a1-deltah/2+1,a1-deltah/2+3),
% % % % % % %.... mittelwert aus (a1-deltah/2+1, a1-deltah/2+2... a1)
index=1;
for i=a1-deltah/2+1:a1
    for j = 1:b1
        data_meanh(i,j)= sum(data_complete(i-deltah/2+index:end,j))/((a1-i)*2+1);
    end
    index=index+1;
end


data_meanh(1,:) = data_complete(1,:);
[a2 b2] = size(data_meanh);
data_meant=NaN(a2,b2);

size(data_meanh)
size(data_meant)


% LINKER RAND WIRD GEMITTELT
for i=1:a2
    for j = 2:deltat/2+1
        data_meant(i,j) = sum(data_meanh(i,2:2*(j-1)))/(2*(j-1)-1);
    end
end

% RECHTER RAND WIRD GEMITTELT
for i=1:a2
    for j = b2-deltat/2+1:b2
        data_meant(i,j) = sum(data_meanh(i,2*j-b2:b2))/((b2-j)*2+1);
    end
end

% GESAMTE ZEITMITTELUNG OHNE RÄNDER
for i=1:a2
    for j = 2+deltat/2:b2-deltat/2
        data_meant(i,j) = sum(data_meanh(i,j-deltat/2:j+deltat/2))/(deltat+1);
    end
end

% 1. Spalte wird wieder Hoehe
data_meant(:,1) = data_meanh(:,1);
data_mean=data_meant;
%--------------------------------------------------------------------------
%-----------Daten werden ueber Zeit und Hoehe gemittelt--------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%-----------------------Gradient nach Emeis--------------------------------
%--------------------------------------------------------------------------

%---------------------
%  1. Ableitung-------
%---------------------
gradient_mean=NaN(size(data_mean,1),size(data_mean,2));
for i=2:size(data_mean,1)-deltah/2-1
    for j=2:size(data_mean,2)
        if i>= deltah00/2+2 && i<hoehe00+2
            gradient_mean(i,j) = (data_mean(i+deltah00/2,j)-data_mean(i-deltah00/2,j))/...
                (data_mean(i+deltah00/2,1)-data_mean(i-deltah00/2,1));
        elseif i >= hoehe00+2 && i<= hoehe1+2
            gradient_mean(i,j) = (data_mean(i+deltah00/2,j)-data_mean(i-deltah00/2,j))/...
                (data_mean(i+deltah00/2,1)-data_mean(i-deltah00/2,1));
        elseif i> hoehe1+2 && i<=hoehe2+2
            gradient_mean(i,j) = (data_mean(i+deltah1/2,j)-data_mean(i-deltah1/2,j))/...
                (data_mean(i+deltah1/2,1)-data_mean(i-deltah1/2,1));
        elseif i>hoehe2+2
            gradient_mean(i,j) = (data_mean(i+deltah/2,j)-data_mean(i-deltah/2,j))/...
                (data_mean(i+deltah/2,1)-data_mean(i-deltah/2,1));
        end
    end
end

%Gradient des unteren Rand wird gebildet
for i=2:deltah00/2+1
    for j=2:size(data_mean,2)
        gradient_mean(deltah00/2-i+3,j) = (data_mean(deltah00-2*i+4,j) - data_mean(2,j))/(((deltah00-2*i+4)-1)*h*cos(deg2rad(angle_tilt)));
    end
end

gradient_mean(2,:) = (data_mean(3,:)-data_mean(2,:))/(h*cos(deg2rad(angle_tilt)));

%Zeit & Hoehe wird eingefuegt
gradient_mean(1,:) = data_mean(1,:);
gradient_mean(:,1) = data_mean(:,1);

%Alle positiven Gradienten werden NaN gesetzt!
gradient_meanneg=NaN(size(data_mean,1),size(data_mean,2));
for i=2:size(gradient_meanneg,2)
    for j=2:size(gradient_meanneg,1)
        if gradient_mean(j,i) <0
            gradient_meanneg(j,i) = gradient_mean(j,i);
        else
            gradient_meanneg(j,i) = NaN;
        end
    end
end

%Zeit & Hoehe wird eingefuegt
gradient_meanneg(1,2:end) = data_mean(1,2:end);
gradient_meanneg(2:end,1) = data_mean(2:end,1);

%------------------
%  2. Ableitung----
%------------------
gradient2_mean=NaN(size(data_mean,1),size(data_mean,2));
for i= 2:size(data_mean,1)-deltah/2-1
    for j =2:size(data_mean,2)
        if i>= deltah00/2+2 && i<hoehe00+2
            gradient2_mean(i,j) = (gradient_mean(i+deltah00/2,j)-gradient_mean(i-deltah00/2,j))/...
                (height_meter(i+deltah00/2)-height_meter(i-deltah00/2));
        elseif i>= hoehe00+2 && i<=hoehe1+2
            gradient2_mean(i,j) = (gradient_mean(i+deltah00/2,j)-gradient_mean(i-deltah00/2,j))/...
                (height_meter(i+deltah00/2)-height_meter(i-deltah00/2));
        elseif i> hoehe1+2 && i<= hoehe2+2
            gradient2_mean(i,j) = (gradient_mean(i+deltah1/2,j)-gradient_mean(i-deltah1/2,j))/...
                (height_meter(i+deltah1/2)-height_meter(i-deltah1/2));
        elseif i> hoehe2+2
            gradient2_mean(i,j) = (gradient_mean(i+deltah/2,j)-gradient_mean(i-deltah/2,j))/...
                (height_meter(i+deltah/2)-height_meter(i-deltah/2));
        end
    end
end

%2. Ableitung des unteren randes!
for i=2:deltah00/2+1
    for j = 2:size(gradient_mean,2)
        gradient2_mean(deltah00/2-i+3,j) = (gradient_mean(deltah00-2*i+4,j) - gradient_mean(2,j))/(((deltah00-2*i+4)-1)*h*cos(deg2rad(angle_tilt)));
    end
end

gradient2_mean(2,:) = (gradient_mean(3,:)-gradient_mean(2,:))/(h*cos(deg2rad(angle_tilt)));

%Zeit & Hoehe wird eingefuegt
gradient2_mean(1,:) = data_mean(1,:);
gradient2_mean(:,1) = data_mean(:,1);



%--------------------------------------------------------------------------
%-----------------------Schwellwerte---------------------------------------
%--------------------------------------------------------------------------
%Anm.: Einteilung in verschiedene IDs nicht nötig!
if  id == 16224                    %id>0 & id<5
    bmin00 = 10;
    bmin0= 20;
    bmin2= 20;
    bmin3= 50;
    gr_min00 =-0.03;
    gr_min0 = -0.1;
    gr_min2 = -0.1;
    gr_min3= -0.35;
elseif id>10 & id<14
    bmin00 = 10;
    bmin0= 20;
    bmin2= 20;
    bmin3= 50;
    gr_min00 =-0.03;
    gr_min0 = -0.10;
    gr_min2 = -0.10;
    gr_min3= -0.35;
end
%--------------------------------------------------------------------------
%-----------------------Schwellwerte---------------------------------------
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%--------------Mischungsschichthoehe wird berechnet------------------------
%--------------------------------------------------------------------------
[b a] = size(gradient_mean)
grad=NaN(b-1,a-1);
maximum_grad=NaN(b-1,a-1);
minimum_grad=NaN(b-1,a-1);
backsc=NaN(b-1,a-1);
for i= 2:size(gradient2_mean,1)
    for j=2:size(gradient2_mean,2)
        if i>2 && i<(deltah00/2+2)
            if gradient2_mean(i-1,j) <= 0 && gradient2_mean(i,j)>0 && ...
                    data_mean(i-1,j)>=bmin00 && gradient_mean(i,j)<=gr_min00
                grad(i-1,j-1) = 1;
            else
                grad(i-1,j-1) = 0;
            end
        elseif i>=deltah00/2+2 && i<hoehe00+2
            if gradient2_mean(i-1,j) <= 0 && gradient2_mean(i,j)>0 && ...
                    data_mean(i-deltah00/2,j)>=bmin00 && gradient_mean(i,j)<=gr_min00
                grad(i-1,j-1) = 1;
            else
                grad(i-1,j-1) = 0;
            end
        elseif i>= hoehe00+2 && i<= hoehe1+2
            if gradient2_mean(i-1,j)<= 0 && gradient2_mean(i,j)>0 && ...
                    data_mean(i-deltah00/2,j)>=bmin0 && gradient_mean(i,j)<=gr_min0
                grad(i-1,j-1) = 1;
            else
                grad(i-1,j-1) = 0;
            end

        elseif i>hoehe1+2 && i<= hoehe2+2
            if gradient2_mean(i-1,j)<= 0 && gradient2_mean(i,j)>0 && ...
                    data_mean(i-deltah1/2,j)>=bmin2 && gradient_mean(i,j)<=gr_min2
                grad(i-1,j-1) = 1;
            else
                grad(i-1,j-1) = 0;
            end
        elseif i> hoehe2+2
            if gradient2_mean(i-1,j)<= 0 && gradient2_mean(i,j)>0 && ...
                    data_mean(i-deltah/2,j)>=bmin3 && gradient_mean(i,j)<=gr_min3
                grad(i-1,j-1) = 1;
            else
                grad(i-1,j-1) = 0;
            end
        end
    end
end

%Mischungsschicht wird berechnet und Index zugeteilt

[ind_xgrad ind_ygrad]=find(grad(:,:) == 1);

ind_gesamt = [ind_xgrad ind_ygrad];
s_indg = size(ind_gesamt);
if s_indg(1) == 1
    ind_gesamt = [ind_gesamt;ind_gesamt];
end

max_mlh = 4; %maximale Mischungsschichthöhen
for i=1:max(ind_gesamt(:,2))
    ind_m = find(i == ind_gesamt(:,2));
    if length(ind_m>max_mlh)
        ind_gesamt(ind_m(max_mlh+1:length(ind_m)),:) =NaN;
    else
    end
    clear ind_m
end

%NaNs werden gesucht
[deletea deleteb] = find(isnan(ind_gesamt(:,:)));
%NaNs werden gelöscht
ind_gesamt(deletea,:) = [];
%Einträge über 3000m und unter 40m werden gesucht
grad_maxheight = 3000/h;
grad_minheight = 60/h;
ind_xgrad = ind_gesamt(:,1);
gradtoohigh=find(ind_xgrad>grad_maxheight | ind_xgrad<grad_minheight);
%Einträge über 3000m oder unter 40m werden gelöscht
ind_gesamt(gradtoohigh,:) = [];

ind_xgrad = ind_gesamt(:,1);
ind_ygrad = ind_gesamt(:,2);


for i=2:length(data_mean)
    for j=1:length(ind_ygrad)
        if ind_ygrad(j,1) == i-1
            ind_ygrad(j,1) = data_mean(1,i);
        end
    end
end
mlh=NaN(max_mlh,length(grad));

[ig1,ig2] = size(ind_gesamt);
index=1;
for i=1:length(grad)
    for j=1:ig1 %length(ind_gesamt)
        if ind_gesamt(j,2) == i
            mlh(index,i) = ind_gesamt(j,1);
            index=index+1;
        end
    end
    index=1;
end
datestr(sdate(1))
datestr(sdate(end))
[~,sd2] = size(sdate)
mlh*h*cos(deg2rad(angle_tilt));
%size(mlh*h*cos(deg2rad(angle_tilt)))
size(mlh)

mlh = mlh(1:4,1:sd2);
size(mlh)
sdate = sdate(1:sd2);
mlh_height = [sdate; mlh*h*cos(deg2rad(angle_tilt))]; %-h weil index von mlh früher beginnt

%--------------------------------------------------------------------------
%-----------------------Wolken werden berechnet----------------------------
%--------------------------------------------------------------------------

varianz=NaN(length(datahex),1);
size(varianz)
size(datahex)
for i=1:sd2   %length(datahex)
    varianz(i) = var(((datahex(10:end,i)))); %dml
end

beta_sigma=NaN(size(datahex,1),size(datahex,2));
for i=1:sd2     %length(datahex)
    for j=10:size(datahex,1)
        beta_sigma(j,i) = datahex(j,i).*varianz(i);
    end
end

mu = 1/(length(datahex)*(size(datahex,1)-10))*sum(sum(beta_sigma(10:end,:)));
ausdruck = 0;
for i=1:sd2     %length(datahex)
    for j=10:size(datahex,1)
        ausdruck = ausdruck + ((beta_sigma(j,i)-mu).^2);
    end
end

sigma = 1/(length(datahex)*(size(datahex,1)-10)-1)*ausdruck;
ec = mu + 1/20*sqrt(sigma);

[a_right b_right] = find(beta_sigma>ec);

toosmall=find(a_right<5); %kleiner 5 bedeutet kleiner 5*20m = 100 m
ind_cloud = [a_right b_right];
ind_cloud(toosmall,:)=[];

%Nur Rückstreuungen über 1500 werden akzeptiert
dummy = NaN(size(ind_cloud,1),size(ind_cloud,2));
index=1;
for i=1:length(ind_cloud)
    if datahex(ind_cloud(i,1),ind_cloud(i,2)) > 1500
        dummy(index,1)=ind_cloud(i,1);
        dummy(index,2)=ind_cloud(i,2);
        index=index+1;
    end
end
[deletea1 deleteb1] = find(isnan(dummy(:,:)));
%NaNs werden gelöscht
dummy(deletea1,:) = [];

ind_cloud=dummy;
clear dummy;

max_cld = 1; %maximale Wolkenschichten
for i=1:max(ind_cloud(:,2))
    ind_m = find(i == ind_cloud(:,2));
    if length(ind_m>max_cld)
        ind_cloud(ind_m(max_cld+1:length(ind_m)),:) =NaN;
    else
    end
    clear ind_m
end
[deletea deleteb] = find(isnan(ind_cloud(:,:)));
%NaNs werden gelöscht
ind_cloud(deletea,:) = [];

cld=NaN(max_cld,length(datahex));

index=1;
for i=1:length(datahex)
    for j=1:size(ind_cloud)
        if ind_cloud(j,2) == i
            cld(index,i) = ind_cloud(j,1);
            index=index+1;
        end
    end
    index=1;
end
cld = cld(:,1:sd2);
cld_height = [sdate; cld*h*cos(deg2rad(angle_tilt))]; %-h weil index von mlh früher beginnt


