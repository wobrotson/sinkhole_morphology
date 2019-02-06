%----------------------------------------------------+
% script to read in CSV  of sinkhole profiles made   |
% using qprof plugin in QGIS along with feature info |
% from the shapefile with 2D profile locations, then |
% pick the edges and base of the sinkhole from these |
% profiles using the fucntion 'SH_DeDiam_pick', and  |
% writing the data to a new file containing          |
% the diameter and depth of each profile along with  |
% the material and whether there is water present.   |
%                                                    |
% Rob Watson; 19/07/2018                             |
%----------------------------------------------------+

%% read in data
data = 0;

if data == 1
% define axis of profile data to be read in
axis_ID = 2;
%axis_ID = input('select profile axis ID:');

% define year of DSM file used to generate profiles
year = 2015;
%year = input('year of DSM file used to generate profiles:');

% profile 3D data
% select desired file
[filename1] = 'pr_ax2_2015_7918.csv';
%[filename1] = uigetfile('*.csv');

% read csv file skipping first row (header data) 
% column 1: prof_id (same as sinkhole id in shapefile);
% column 2: pixel order along profile
% column 3: lon; 
% column 4: lat;
% column 5: distance (in decimal degrees)
% column 6: elevation
% columns 7 and 8 relate to slope - unimportant
qprof_data = csvread(filename1,1,0); 
[m1,n1] = size(qprof_data);

% profile 2D line data
% select desired file
[filename2] = 'SH_axis_2_short_2015.shp';
%[filename2] = uigetfile('*.shp');

% read shp file 
% S = geometric info;
% A = feature attribute info
[shp_S, shp_A] = shaperead(filename2); 

% sort shapefile attributes by id field using nestedSortStruct
attributes = nestedSortStruct(shp_A, {'id'});
end

%% pick and calculate diameter/depth for each profile

% prompt user to input id of sinkhole for picking
SH_ID = input('select sinkhole profile ID:');

% generate depth and diameter data for chosen SH_ID
% using fucntion 'SH_DeDiam_pick'
[SDepth,SDiam] = SH_DeDiam_pick(SH_ID,qprof_data);

% generate numeric representation of feature 
% attributes from shapefile

water = strcmp({attributes(SH_ID).water}.','yes');

T1 = strcmp({attributes(SH_ID).material}.','alluvium');
T2 = strcmp({attributes(SH_ID).material}.','salt');    
    
if T1 == 1
   type = 1; % sinkholes in alluvium
end
    
if T1 == 0 && T2 == 1
   type = 2; % sinkholes in salt
end

if T1 == 0 && T2 == 0
   type = 0; % sinkholes in mud
end

%% write data to new matrix

% write all data to output matrix

% column 1: profile id
% column 2: axis id
% column 3: diameter
% column 4: depth
% column 5: material/type
% column 6: water

output = zeros(1,6);
output(1) = SH_ID;
output(2) = axis_ID;
output(3) = SDiam;
output(4) = SDepth;
output(5) = type;
output(6) = water;

% append data to excel spreadsheet using xlsappend
xlsappend('sinkhole_diam_depth',output, num2str(year));

