% column 1 = depth (x-axis)
% column 2 = perimeter (y-axis)
Pe_De_alluvium = csvread('Pe-De_Alluvium.csv');
Pe_De_mud = csvread('Pe-De_Mudflats.csv');

% convert perimeter to diameter by dividing by pi
Pe_De_alluvium(:,2) = Pe_De_alluvium(:,2)/pi;
Pe_De_mud(:,2) = Pe_De_mud(:,2)/pi;

% plot data

figure(5);
fil_all = plot(Pe_De_alluvium(:,2), Pe_De_alluvium(:,1), 'ks');
fil_all.MarkerFaceColor = 'black';
fil_all.MarkerSize = 2;
hold on;
fil_mud = plot(Pe_De_mud(:,2), Pe_De_mud(:,1), 'k^');
fil_mud.MarkerFaceColor = 'black';
fil_mud.MarkerSize = 2;