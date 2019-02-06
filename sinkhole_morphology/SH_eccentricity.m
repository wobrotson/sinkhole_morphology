%------------------------------------------------+
% Script to plot eccentricity of sinkholes for   |
% different materials and compare trends.        |
%                                                |
% Rob Watson; 1/8/18                             |
%------------------------------------------------+

%% read data from spreadsheet and compile
read = 1;
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

FinalData = zeros(max(max_SH_No), 4, 3);
% column 1: hole id
% column 2: minimum diameter
% column 3: maximum diameter
% column 4: material/type
%   - 1 = alluvium
%   - 2 = salt
%   - 0 = mud
% row of constant zeros means no data

for b =1:1:3
for c=min_SH_No(b):1:max_SH_No(b);
    
    row_No = find(AllData(:,1,b) == c);
    
    if isempty(row_No);
        continue
        
    elseif length(row_No) == 1;
        subTable = AllData(row_No,:,b);
        SDiammin = subTable(:,3);
        SDiammax = subTable(:,3);
        SType = subTable(:,5);
        FinalData(c,:,b) = [c, SDiammin, SDiammax, SType];
        
        else
        subTable = AllData(row_No(1):row_No(end),:,b);
        % sort subtable by depth so as to obtain max depth
        subTable_sorted = sortrows(subTable, 4, 'descend');
        SDiammin = min(subTable_sorted(:,3));
        SDiammax = max(subTable_sorted(:,3));
        SType = subTable(1,5);
        FinalData(c,:,b) = [c, SDiammin, SDiammax, SType];
        
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
% column 2: minimum diameter
% column 3: maximum diameter
% column 4: year
% row of constant zeros means no data (NaN)

for d = 1:1:length(FD2014)
    if FD2014(d,4) == 1 % alluvium
       AD14(d,1:3) = FD2014(d,1:3);
       AD14(d,4) = 2014;
    elseif FD2014(d,4) == 0 % mud
       MD14(d,1:3) = FD2014(d,1:3);
       MD14(d,4) = 2014;
    end
end

for d = 1:1:length(FD2015)
     if FD2015(d,4) == 1 % alluvium
       AD15(d,1:3) = FD2015(d,1:3);
       AD15(d,4) = 2015;
    elseif FD2015(d,4) == 0 % mud
       MD15(d,1:3) = FD2015(d,1:3);
       MD15(d,4) = 2015;
     else
       SD15(d,1:3) = FD2015(d,1:3); % salt
       SD15(d,4) = 2015;
    end

end

for d = 1:1:length(FD2016)
     if FD2016(d,4) == 1 % alluvium
       AD16(d,1:3) = FD2016(d,1:3);
       AD16(d,4) = 2016;
    elseif FD2016(d,4) == 0 % mud
       MD16(d,1:3) = FD2016(d,1:3);
       MD16(d,4) = 2016;
     else
       SD16(d,1:3) = FD2016(d,1:3); % salt
       SD16(d,4) = 2016;
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

%% plot eccentricity

set(0, 'DefaultAxesFontName', 'Calibri');
set(0, 'DefaultAxesFontSize', 14);
set(0, 'DefaultAxesFontWeight', 'bold');

twok15 =1;
twok16 =1;

a14 = zeros(length(FD2014), 1);
m14 = zeros(length(FD2014), 1);

a15 = zeros(length(FD2015), 1);
m15 = zeros(length(FD2015), 1);
s15 = zeros(length(FD2015), 1);

a16 = zeros(length(FD2016), 1);
m16 = zeros(length(FD2016), 1);
s16 = zeros(length(FD2016), 1);

longshort = figure(1);

for d = 1:1:length(FD2014)
    if FD2014(d,4) == 1 % alluvium, blue
       a14(d) = FD2014(d,1);
       A14 = plot(FD2014(d,2), FD2014(d,3), 'bo');
       hold on;
    elseif FD2014(d,4) == 0 % mud, red
       m14(d) = FD2014(d,1);
        M14 = plot(FD2014(d,2), FD2014(d,3), 'ro');
    end
end

% 2015 (stars)
longshort;
if twok15 ==1
for d = 1:1:length(FD2015)
    if FD2015(d,4) == 1 % alluvium, blue
       a15(d) = FD2015(d,1);
       A15 = plot(FD2015(d,2), FD2015(d,3), 'b*');
       hold on;
    elseif FD2015(d,4) == 0 % mud, red
       m15(d) = FD2015(d,1);
       M15 = plot(FD2015(d,2), FD2015(d,3), 'r*');
    end
    
    if FD2015(d,4) == 2 % salt, green
       s15(d) = FD2015(d,1);
       S15 = plot(FD2015(d,2), FD2015(d,3), 'g*');
    end
end
end

% 2016 (diamonds)
longshort;
if twok16 ==1
for d = 1:1:length(FD2016)
    if FD2016(d,4) == 1 % alluvium, blue
       a16(d) = FD2016(d,1);
       A16 = plot(FD2016(d,2), FD2016(d,3), 'bd');
       hold on;
    elseif FD2016(d,4) == 0 % mud, red
       m16(d) = FD2016(d,1);
       M16 = plot(FD2016(d,2), FD2016(d,3), 'rd');
    end
    
    if FD2016(d,4) == 2 % salt, green
       s16(d) = FD2016(d,1);
       S16 = plot(FD2016(d,2), FD2016(d,3), 'gd');
    end
end
end

xlabel('Short Axis [m]');
ylabel('Long Axis [m]');
axis([0 60 0 90]);

% plot trends for comparison
short = [0,70];
long1 = [0,70];
long2 = [0,2*70];
long3 = [0,3*70];
long4 = [0,4*70];

longshort;
plot(short, long1, 'k--', 'LineWidth', 1.2');
hold on;
plot(short, long2, 'k--', 'LineWidth', 1.2');
plot(short, long3, 'k--', 'LineWidth', 1.2');
plot(short, long4, 'k--', 'LineWidth', 1.2');
txt = {'E = 1','E = 2','E = 3','E = 4'};
Ex = [50 45 37 24];
Ey = [40 80 80 80];
E = text(Ex, Ey, txt);
set(E,'FontSize',14);
set(E,'FontWeight','bold');

annotation('rectangle',[0.6 0.2 0.15 0.15], 'color', 'black');

text(45, 20, 'N = 226', 'color', 'blue', 'FontSize', 14, 'FontWeight', 'bold');
text(45, 15, 'N = 236', 'color', 'red', 'FontSize', 14, 'FontWeight', 'bold');
text(45, 10, 'N = 369', 'color', 'green', 'FontSize', 14, 'FontWeight', 'bold');

%lgd = legend([A14 M14 A15 M15 S15 A16 M16 S16], 'alluvium, 2014',...
%    'mud, 2014','alluvium, 2015', 'mud, 2015', 'salt, 2015',...
%   'alluvium, 2016', 'mud, 2016', 'salt, 2016','Location','northwest');
%LGD = legend([A14 M14 A15 M15 S15 A16 M16 S16], 'alluvium, 2014',...
 %   'mud, 2014', 'alluvium, 2015', 'mud, 2015', 'salt, 2015',...
  %  'alluvium, 2016', 'mud, 2016', 'salt, 2016','Location','northeast');
%legend('boxoff')



