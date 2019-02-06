function [SDepth,SDiam] = SH_DeDiam_pick(SH_ID,qprof_data)
%function to pick the depth and diameter of a chosen
% sinkhole ID.

% find all rows that correspond to chosen profile 
index = find(qprof_data(:,1) == SH_ID);

% plot profile of chosen sinkhole   
plot(qprof_data(index,5), qprof_data(index,6), 'b-');

% pick edges of sinkhole for diameter
[xgi,ygi] = ginput(1); % edge1
[xgj,ygj] = ginput(1); % edge2

% pick highest edge (top) and base of sinkhole to calculate
% maximum depth of sinkhole
[xgk,ygk] = ginput(1); % top
[xgm,ygm] = ginput(1); % base

% calculate diameter
SDiam_dd = abs(xgi-xgj);

% convert to metres
deg_2_m = 8.983157*10^-6; % no. degrees in 1m
SDiam = SDiam_dd/deg_2_m;

% calculate depth
SDepth = abs(ygk-ygm);

end

