%----------------------------------------------------+
% script to plot sinkhole morphometric parameters    |
% (diameter-number and depth-diameter) and interpret |
% any observable trends from these.                  |
%                                                    |
% Rob Watson; 26/7/18                                |
%----------------------------------------------------+
close all;

%% read data from spreadsheet and compile
read = 0;
% each sheet corresponds to year of 3D data used
% in calculation and measurement
if read == 1
SHdata14 = xlsread('sinkhole_diam_depth.xls', '2014');
SHdata15 = xlsread('sinkhole_diam_depth.xls', '2015');
SHdata16 = xlsread('sinkhole_diam_depth.xls', '2016');
end

% column 1: hole id
% column 2: axis id
% column 3: diameter
% column 4: depth
% column 5: material/type
%   - 1 = alluvium
%   - 2 = salt
%   - 0 = mud
% column 6: presence of water
%   - 0 = no water present
%   - 1 = water present (depth calculated is minimum,
% not true depth

% write data to 3D matrix with all data;
% sort data so that rows appear according to profile id
leng = [length(SHdata14),length(SHdata15),length(SHdata16)];
AllData = NaN(max(leng), 6, 3);
AllData(1:leng(1),:,1) = SHdata14; % 2014 data
AllData(1:leng(2),:,2) = sortrows(SHdata15, 1); % 2015 data
AllData(1:leng(3),:,3) = sortrows(SHdata16,1); % 2016 data

%% calculate average diameters and depths and sort by material

for a = 1:1:3
    min_SH_No(a) = min(AllData(:,1,a));
    max_SH_No(a) = max(AllData(:,1,a));
end

FinalData = zeros(max(max_SH_No), 5, 3);
% column 1: hole id
% column 2: average diameter
% column 3: maximum depth
% column 4: material/type
%   - 1 = alluvium
%   - 2 = salt
%   - 0 = mud
% column 5: presence of water
%   - 0 = no water present
%   - 1 = water present (depth calculated is minimum,
% not true depth
% row of constant zeros means no data

for b =1:1:3
for c=min_SH_No(b):1:max_SH_No(b);
    
    row_No = find(AllData(:,1,b) == c);
    
    if isempty(row_No);
        continue
        
    elseif length(row_No) == 1;
        subTable = AllData(row_No,:,b);
        SDiam = subTable(:,3);
        SDepth = subTable(:,4);
        SType = subTable(:,5);
        SWater = subTable(:,6);
        FinalData(c,:,b) = [c, SDiam, SDepth, SType, SWater];
       
    else
        subTable = AllData(row_No(1):row_No(end),:,b);
        % sort subtable by depth so as to obtain max depth
        subTable_sorted = sortrows(subTable, 4, 'descend');
        SDiam = mean(subTable_sorted(:,3));
        SDepth = subTable_sorted(1,4);
        SType = subTable(1,5);
        SWater = subTable(1,6);
        FinalData(c,:,b) = [c, SDiam, SDepth, SType, SWater];
        
    end    
end
end

% re-sort data into separate matrices by year with NaN 
% values removed for plotting

FD2014 = removeconstantrows(FinalData(:,:,1));
FD2015 = removeconstantrows(FinalData(:,:,2));
FD2016 = removeconstantrows(FinalData(:,:,3));

% sort again by material
 
% column 1: hole id
% column 2: average diameter
% column 3: maximum depth
% column 4: presence of water
%   - 0 = no water present
%   - 1 = water present (depth calculated is minimum,
% not true depth
% column 5: year
% row of constant zeros means no data (NaN)

for d = 1:1:length(FD2014)
    if FD2014(d,4) == 1 % alluvium
       AD14(d,1:3) = FD2014(d,1:3);
       AD14(d,4) = FD2014(d,5);
       AD14(d,5) = 2014;
    elseif FD2014(d,4) == 0 % mud
       MD14(d,1:3) = FD2014(d,1:3);
       MD14(d,4) = FD2014(d,5);
       MD14(d,5) = 2014;
    end
end

for d = 1:1:length(FD2015)
     if FD2015(d,4) == 1 % alluvium
       AD15(d,1:3) = FD2015(d,1:3);
       AD15(d,4) = FD2015(d,5);
       AD15(d,5) = 2015;
    elseif FD2015(d,4) == 0 % mud
       MD15(d,1:3) = FD2015(d,1:3);
       MD15(d,4) = FD2015(d,5);
       MD15(d,5) = 2015;
     else
       SD15(d,1:3) = FD2015(d,1:3); % salt
       SD15(d,4) = FD2015(d,5);
       SD15(d,5) = 2015;
    end

end

for d = 1:1:length(FD2016)
     if FD2016(d,4) == 1 % alluvium
       AD16(d,1:3) = FD2016(d,1:3);
       AD16(d,4) = FD2016(d,5);
       AD16(d,5) = 2016;
    elseif FD2016(d,4) == 0 % mud
       MD16(d,1:3) = FD2016(d,1:3);
       MD16(d,4) = FD2016(d,5);
       MD16(d,5) = 2016;
     else
       SD16(d,1:3) = FD2016(d,1:3); % salt
       SD16(d,4) = FD2016(d,5);
       SD16(d,5) = 2016;
    end

end

AData14 = removeconstantrows(AD14);
MData14 = removeconstantrows(MD14);

SData15 = removeconstantrows(SD15);
AData15 = removeconstantrows(AD15);
MData15 = removeconstantrows(MD15);

AData16 = removeconstantrows(AD16);
MData16 = removeconstantrows(MD16);
SData16 = removeconstantrows(SD16);

AlluviumData = vertcat(AData14,AData15,AData16);
SaltData = vertcat(SData15,SData16);
MudData = vertcat(MData14,MData15, MData16);

%% read in filin et al data and sort
% perimeter-depth data

% column 1 = depth (x-axis)
% column 2 = perimeter (y-axis)
Pe_De_alluvium = csvread('Pe-De_Alluvium.csv');
Pe_De_mud = csvread('Pe-De_Mudflats.csv');

% convert perimeter to diameter by dividing by pi
Pe_De_alluvium(:,2) = Pe_De_alluvium(:,2)/pi;
Pe_De_mud(:,2) = Pe_De_mud(:,2)/pi;

% depth-frequency data
% column 1 = bin size for depth (intervals of 0.5m)
% column 2 = frequency

Fi_De_Fr_All = xlsread('filin_De-Freq.xlsx', 'alluvium');
Fi_De_Fr_Mud = xlsread('filin_De-Freq.xlsx', 'mud');

%% plot Diameter and number as histogram

set(0, 'DefaultAxesFontName', 'Calibri');
set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultAxesFontWeight', 'bold');

DiamNoPlot = 0;

if DiamNoPlot == 1

DiamNo = figure(1);

edgesS = [0:4:round(max(SaltData(:,2)))];
HS = histogram(SaltData(:,2), edgesS);
HS.FaceColor = 'green';
hold on;

edgesM = [0:4:round(max(MudData(:,2)))];
HM = histogram(MudData(:,2), edgesM);
HM.FaceColor = 'none';
HM.EdgeColor = 'red';
HM.LineWidth = 1.8;

edgesA = [0:4:round(max(AlluviumData(:,2)))];
HA = histogram(AlluviumData(:,2), edgesA);
HA.FaceColor = 'none';
HA.EdgeColor = 'blue';
HA.LineStyle = '--';
HA.LineWidth = 1.4;
legend('Salt','Mud','Alluvium');
xlabel('Diameter [m]');
ylabel('Number');

end

%% Plot depth-diameter and calculate trends

twok15 =1;
twok16 =1;

% matrices for storing non water-filled sinkhole properties

a14 = zeros(length(FD2014), 3);
m14 = zeros(length(FD2014), 3);

a15 = zeros(length(FD2015), 3);
m15 = zeros(length(FD2015), 3);
s15 = zeros(length(FD2015), 3);

a16 = zeros(length(FD2016), 3);
m16 = zeros(length(FD2016), 3);
s16 = zeros(length(FD2016), 3);

% plot depth and diameter, discarding water-filled holes
DeDiamP = figure(2);
plot(Pe_De_alluvium(:,2), Pe_De_alluvium(:,1), 'ks');
hold on;
fil_all = plot(Pe_De_alluvium(:,2), Pe_De_alluvium(:,1), 'ks');
fil_all.MarkerFaceColor = 'black';
fil_all.MarkerSize = 2;

plot(Pe_De_mud(:,2), Pe_De_mud(:,1), 'k^');
fil_mud = plot(Pe_De_mud(:,2), Pe_De_mud(:,1), 'k^');
fil_mud.MarkerFaceColor = 'black';
fil_mud.MarkerSize = 2;

% plot filin data beneath using black squares and triangles
plot(Pe_De_alluvium(:,2), Pe_De_alluvium(:,1), 'ksq');
hold on;
plot(Pe_De_mud(:,2), Pe_De_mud(:,1), 'd');

% 2014 (circles): no salt deposits

for d = 1:1:length(FD2014)
    if FD2014(d,4) == 1 && FD2014(d,5)==0 % alluvium, blue
       a14(d,:) = FD2014(d,1:3);
       A14 = plot(FD2014(d,2), FD2014(d,3), 'bo');
       hold on;
    elseif FD2014(d,4) == 0 && FD2014(d,5)==0 % mud, red
       m14(d,:) = FD2014(d,1:3);
       M14 = plot(FD2014(d,2), FD2014(d,3), 'ro');
    end
end

% 2015 (stars)
DeDiamP;
if twok15 ==1
for d = 1:1:length(FD2015)
    if FD2015(d,4) == 1 && FD2015(d,5)==0 % alluvium, blue
       a15(d,:) = FD2015(d,1:3);
       A15 = plot(FD2015(d,2), FD2015(d,3), 'b*');
       hold on;
    elseif FD2015(d,4) == 0 && FD2015(d,5)==0 % mud, red
       m15(d,:) = FD2015(d,1:3);
       M15 = plot(FD2015(d,2), FD2015(d,3), 'r*');
    end
    
    if FD2015(d,4) == 2 && FD2015(d,5)==0 % salt, green
       s15(d,:) = FD2015(d,1:3);
       S15 = plot(FD2015(d,2), FD2015(d,3), 'g*');
    end
end
end

% 2016 (diamonds)
DeDiamP;
if twok16 ==1
for d = 1:1:length(FD2016)
    if FD2016(d,4) == 1 && FD2016(d,5)==0 % alluvium, blue
       a16(d,:) = FD2016(d,1:3);
       A16 = plot(FD2016(d,2), FD2016(d,3), 'bd');
       hold on;
    elseif FD2016(d,4) == 0 && FD2016(d,5)==0 % mud, red
       m16(d,:) = FD2016(d,1:3);
       M16 = plot(FD2016(d,2), FD2016(d,3), 'rd');
    end
    
    if FD2016(d,4) == 2 && FD2016(d,5)==0 % salt, green
       s16(d,:) = FD2016(d,1:3);
       S16 = plot(FD2016(d,2), FD2016(d,3), 'gd');
    end
end
end

a14No = removeconstantrows(a14);
m14No = removeconstantrows(m14);

a15No = removeconstantrows(a15);
m15No = removeconstantrows(m15);
s15No = removeconstantrows(s15);

a16No = removeconstantrows(a16);
m16No = removeconstantrows(m16);
s16No = removeconstantrows(s16);

AllDeDi = vertcat(a14No,a15No,a16No);
MudDeDi = vertcat(m14No,m15No,m16No);
SaltDeDi = vertcat(s15No,s16No);

xlabel('Diameter [m]');
ylabel('Depth [m]');
axis([0 60 0 20]);

% plot trends for depth and diameter based on material

% alluvium
x = linspace(0,60,10);
pA = polyfit(AllDeDi(:,2), AllDeDi(:,3),1);
ATrend = polyval(pA, x);

DeDiamP;
plot(x, ATrend, 'b--', 'LineWidth', 1.5);

% mud
pM = polyfit(MudDeDi(:,2),MudDeDi(:,3),1);
MTrend = polyval(pM, x);

DeDiamP;
plot(x, MTrend, 'r--', 'LineWidth', 1.5);

% salt
pS = polyfit(SaltDeDi(:,2), SaltDeDi(:,3),1);
STrend = polyval(pS, x);

DeDiamP;
plot(x, STrend, 'g--', 'LineWidth', 1.5);

Atxt = annotation('textbox', [0.15 0.58 0.3 0.3], 'String',...
    {'Alluvium: De = 0.40*Di - 0.12','Rsq = 0.76; N = 226'}, ...
    'FitBoxToText', 'on');
Atxt.Color = 'blue';
Atxt.EdgeColor = 'blue';
Atxt.FontSize = 11;

Stxt = annotation('textbox', [0.62 0.47 0.3 0.3], 'String',...
    {'Salt:', 'De = 0.11*Di + 0.35','Rsq = 0.53; N = 273'}, ...
    'FitBoxToText', 'on');
Stxt.Color = 'green';%[0.466,0.674,0.188];
Stxt.EdgeColor = 'green';
Stxt.FontSize = 11;

Mtxt = annotation('textbox', [0.62 0.30 0.3 0.3], 'String',...
    {'Mud:', 'De = 0.09*Di + 0.76','Rsq = 0.40; N = 168'}, ...
    'FitBoxToText', 'on');
Mtxt.Color = 'red';
Mtxt.EdgeColor = 'red';
Mtxt.FontSize = 11;

% lgd = legend([A14 M14 A15 M15 S15 A16 M16 S16], 'alluvium, 2014',...
%    'mud, 2014', 'alluvium, 2015','mud, 2015', 'salt, 2015',...
 %   'alluvium, 2016', 'mud, 2016', 'salt, 2016','Location','northeast');

 %LGD = legend([A14 M14 A15 M15 S15 A16 M16 S16], 'alluvium, 2014',...
 %   'mud, 2014', 'alluvium, 2015', 'mud, 2015', 'salt, 2015',...
  %  'alluvium, 2016', 'mud, 2016', 'salt, 2016','Location','northeast');
%legend('boxoff')

% calculate statistics using fitlm

% alluvium:
fitAll = fitlm(AllDeDi(:,2), AllDeDi(:,3));
% mud:
fitMud = fitlm(MudDeDi(:,2), MudDeDi(:,3));
% salt:
fitSalt = fitlm(SaltDeDi(:,2), SaltDeDi(:,3));
