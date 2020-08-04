%Please run startup_mtex.m and then run the following script
clc;
clear all;

%% Import Script for PoleFigure Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = crystalSymmetry('m-3m', [1 1 1]); %Mention the crystal symmetry.

% specimen symmetry
SS = specimenSymmetry('mmm'); %Mention sample symmetry. For unidirectional rolling 'mmm'. For cross rolling '1'. 

% plotting convention
setMTEXpref('xAxisDirection','north');
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% path to files
pname = 'F:\AA2198\Bulk Texture AA2024\AA2024 CR 1'; %provide the correct path here. Otherwise the code would not run

% which files to be imported
fname = {...
  [pname '\100.txt'],...
  [pname '\110.txt'],...
  [pname '\111.txt'],...
  [pname '\113.txt'],...
  };

%% Specify Miller Indice

h = { ...
  Miller(1,0,0,CS),...
  Miller(1,1,0,CS),...
  Miller(1,1,1,CS),...
  Miller(1,1,3,CS),...
  };

%% Import the Data

% create a Pole Figure variable containing the data
pf = PoleFigure.load(fname,h,CS,SS,'interface','generic'); 
rot = rotation('axis', zvector, 'angle',0*degree); %rotate the pole figure data if required. Sometimes the sample is wrongly aligined in Goniometer
                                                   % RD and TD are interchanged or RD is marginally tilted from the correct position
pf = rotate(pf, rot);
plot(pf)                                           %Plot the experimental incomplete pole figure 
odf = calcODF(pf,'resolution',5*degree);           %Calculate ODF
ori1 = calcOrientations(odf,2000);                 % Discretize the ODF to get single orientations. Useful if simualtions are to be performed. 
                                                   %Discrete orientations can be obatined by wrtiting ori1.Euler in MATLAB command window
%plot ODF												   
plot(odf,'phi2',[0 45 65]* degree,'contour','antipodal','linewidth',3,'colorrange',[1 10]); %Plot the ODF sections. Change to 45 for BCC material. Change to [0 30 60] for HCP 
setColorRange('equal');  
mtexColorbar ('FontSize',25,'Fontweight','bold');
set(gcf, 'units','normalized','outerposition',[0 0 1 1]); %Maximize figure.
print(gcf,'odf.svg','-dsvg','-r600'); % save the ODF sections
figure ()

%Plot PF
pf=normalize(pf,odf);
plotPDF(odf,[Miller(1,1,1,CS)],'contour','antipodal','complete','linewidth',3,'colorrange',[1 3],'complete','upper'); %Plot the recalculated pole figures
mtexColorbar ('FontSize',25,'Fontweight','bold');                                                                     %Change to 110 for BCC
setColorRange('equal') % set equal color range for all subplots                                                       % Change to (0,0,0,2),(1,0,-1,0) for HCP
annotate([xvector, yvector], 'label', {'RD','TD'}, 'BackgroundColor', 'w',...
    'FitBoxToText','on','FontSize',15,'LineStyle','none','Fontname','Times New Roman','Fontweight','bold');
set(gcf, 'units','normalized','outerposition',[0 0 1 1]); %Maximize figure.
print(gcf,'pole figure.svg','-dsvg','-r600'); % save the pole figures 
figure()

%Plot IPF (Choose whichever IPF direction you want by changing the xvector
%e.g. 'yvector', 'zvector'
plotIPDF(odf,[xvector],'contour','antipodal','linewidth',3,'colorrange',[1 3]);
mtexColorbar ('FontSize',25,'Fontweight','bold');                                                                     %Change to 110 for BCC
setColorRange('equal') % set equal color range for all subplots 
set(gca,'FontSize',30,'fontweight','bold')
title('IPF-X');
set(gcf, 'units','normalized','outerposition',[0 0 1 1]); %Maximize figure.
print(gcf,'inverse pole figure.svg','-dsvg','-r600'); % save the inverse pole figure

figure()

% % volume fraction calculation
 cu = orientation.byMiller([1 1 2],[1 1 -1],CS,SS).symmetrise;  %These texture components are for fcc. Change accordingly for BCC and HCP  
 s = orientation.byMiller([1 2 3],[6 3 -4],CS,SS).symmetrise;
 b = orientation.byMiller([1 1 0],[1 -1 2],CS,SS).symmetrise;
 c = orientation.byMiller([0 0 1],[1 0 0],CS,SS).symmetrise;
 goss=orientation.byMiller([1 1 0],[1 0 0],CS,SS).symmetrise;
 rot_brass=orientation.byMiller([1 1 0],[1 -1 1],CS,SS).symmetrise;

vcu = volume(odf,cu,15*degree);
vs =  volume(odf,s,15*degree);
vb =  volume(odf,b,15*degree);
vc =  volume(odf,c,15*degree);
vgoss=volume(odf,goss,15*degree);
vrot_brass=volume(odf,rot_brass,15*degree);

V=[vcu,vs,vb,vc,vgoss,vrot_brass];
xlswrite('file.xlsx',V,'sheet1','A2');
xlswrite('file.xlsx',{'Copper','S','Brass','Cube','Goss','rotated brass'},'sheet1','A1'); %Excel spread sheet with volume fraction of individual texture components

% Create Fiber plots for fcc alpha, tau and beta

%Alpha fiber

phi1 = linspace(0*degree,90*degree); %created 100 evenly spaced points
Phi = 45*degree;
phi2 = 0*degree;
ori = orientation('euler',phi1,Phi,phi2,CS);
plot(phi1./degree,eval(odf,ori));
p = findobj(gca,'Type','line');
y=get(p,'Ydata');
x=get(p,'Xdata');
Z=[x',y'];
plot(x',y','-o','MarkerSize',5,'LineWidth',2,'LineStyle','-','linewidth',3,'Color','k')
xlim([0 90]);
xlabel('Phi1','fontweight','bold','fontsize',32);
ylabel('f(g)','fontweight','bold','fontsize',32);
set(gca,'FontSize',30,'fontweight','bold');
set(gcf,'color','w');
set(gca,'linewidth',3);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
legend('alphafiber','Location','Northeast','Orientation','vertical','fontsize',28);
xlswrite('alphafiber.xls', Z);

figure()

%Tau fiber
phi1 = 90*degree;
Phi = linspace(0*degree,90*degree);
phi2 = 45*degree;
ori = orientation('euler',phi1,Phi,phi2,CS);
plot(Phi./degree,eval(odf,ori));
p = findobj(gca,'Type','line');
y=get(p,'Ydata');
x=get(p,'Xdata');
Z=[x',y'];
plot(x',y','-o','MarkerSize',5,'LineWidth',2,'LineStyle','-','linewidth',3,'Color','k')
xlim([0 90]);
xlabel('Phi','fontweight','bold','fontsize',32);
ylabel('f(g)','fontweight','bold','fontsize',32);
set(gca,'FontSize',30,'fontweight','bold');
set(gcf,'color','w');
set(gca,'linewidth',3);
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
legend('taufiber','Location','Northeast','Orientation','vertical','fontsize',28);
xlswrite('taufiber.xls', Z);

figure ()

%Beta fiber
phi1 = linspace(90*degree,35*degree);
Phi = linspace(35*degree,45*degree);
phi2 = linspace(45*degree,90*degree);
ori = orientation('euler',phi1,Phi,phi2,CS);
plot(phi2./degree,eval(odf,ori));
p = findobj(gca,'Type','line');
y=get(p,'Ydata');
x=get(p,'Xdata');
Z=[x',y'];
plot(x',y','-o','MarkerSize',5,'LineWidth',2,'LineStyle','-','linewidth',3,'Color','k')
xlim([45 90]);
xlabel('Phi2','fontweight','bold','fontsize',32);
ylabel('f(g)','fontweight','bold','fontsize',32);
set(gca,'FontSize',30,'fontweight','bold');
set(gcf,'color','w');
set(gca,'linewidth',3);
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
legend('betafiber','Location','Northeast','Orientation','vertical','fontsize',28);
xlswrite('betafiber.xls', Z);
