CS = crystalSymmetry('m-3m', [1 1 1]); % crystal symmetry
SS = specimenSymmetry('mmm'); % specimen symmetry
setMTEXpref('xAxisDirection','north'); % plotting convention
setMTEXpref('zAxisDirection','outOfPlane'); % plotting convention

%% Specify File Names
pname = 'H:\phd data\Bulk Texture Analysis\Matrix\95-pct-rolled'; % path to all the files
fname = {...
  [pname '\111.ASC'],...
  [pname '\200.ASC'],...
  [pname '\220.ASC'],...
  }; % which files to be imported
h = { ...
  Miller(1,1,1,CS),...
  Miller(2,0,0,CS),...
  Miller(2,2,0,CS),...
  }; % Specify Miller Indices of corresponding files
pf = PoleFigure.load(fname,h,CS,SS,'interface','xrd'); % importing and creating pole figure
pf(pf.intensities<0) = 0; % Correcting the PF


% plot(pf,'contourf')
odf = calcODF(pf,'silent', 'resolution',5*degree); % ODF Estimation


% In case rotation is required
% rot = rotation('axis', zvector,'angle',5*degree);
% odf=rotate(odf,rot);

% Texture_index = textureindex(odf, 'fourier') % Texture index calculation
% plotPDF(odf,pf.h)
% pf=normalize(pf,odf);

%% Plotting ODF [0 45 65] (f0r FCC) one by one for good quality image
figure()
plot(odf,'phi2',[0]*degree,'contourf')
setColorRange([1 5.1])
set(gca,'TickDir','out'); % The only other option is 'in
saveas(gcf,'0_ODF.svg')
saveas(gcf,'0_ODF.png')
figure()
plot(odf,'phi2',[45]*degree,'contourf')
setColorRange([1 5.1])
set(gca,'TickDir','out'); % The only other option is 'in'
saveas(gcf,'45_odf.svg')
saveas(gcf,'45_odf.png')
figure()
plot(odf,'phi2',[65]*degree,'contourf')
setColorRange([1 5.1])
set(gca,'TickDir','out'); % The only other option is 'in'
saveas(gcf,'65_odf.svg')
saveas(gcf,'65_odf.png')
close all



% Visualize the ODF
%plot(odf,'contour','linewidth',1.5)
% mtexColorMap LaboTeX

%% To plot pole figures
%figure
plotPDF(odf,pf.h,'complete','upper');
setColorRange([1 2.7])
saveas(gcf,'Pole_figure.svg')
saveas(gcf,'Pole_figure.png')
% plotPDF(odf,Miller({1,1,1},CS,'complete','antipodal'))
% add one colorbar for all sub figures
setColorRange('equal') % set equal color range for all subplots
mtexColorbar % add the color bar
% add individual colorbars for all sub figures
% mtexColorbar('multiple')
annotate([xvector, yvector, zvector], 'label', {'RD','ND', 'TD'}, 'BackgroundColor', 'w');

 % plot(odf,'phi2',[65]*degree,'contourf')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Plotting Fibers       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%
%%% alpha fibre%%%
%%%%%%%%%%%%%%%%%%
% 
Phi1 = linspace(0*degree,90*degree);
Phi = 45*degree;
Phi2 = 0*degree;
ori = orientation('euler',Phi1,Phi,Phi2,CS);
plot(Phi1./degree,eval(odf,ori));
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
legend('Alpha fiber','Location','Northeast','Orientation','vertical','fontsize',28);
xlswrite('Alpha_fiber.xlsx', Z);





%%%%%%%%%%%%%%%%
%%% tau fibre%%%
%%%%%%%%%%%%%%%%


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
xlswrite('taufiber.xlsx', Z);


%%%%%%%%%%%%%%%%
% % beta fiber%%
%%%%%%%%%%%%%%%%


BFOri = [...
[35.3 45.0 0.0 ];...
[33.6 47.7 5.0 ];...
[32.1 51.0 10.0];...
[31.1 54.7 15.0];...
[31.3 59.1 20.0];...
[35.2 64.2 25.0];...
[46.1 69.9 30.0];...
[49.5 76.2 35.0];...
[51.8 83.0 40.0];...
[54.7 90.0 45.0];...
[90.0 35.3 45.0];...
[80.2 35.4 50.0];...
[73.0 35.7 55.0];...
[66.9 36.2 60.0];...
[61.2 37.0 65.0];...
[55.9 38.0 70.0];...
[50.7 39.2 75.0];...
[45.6 40.8 80.0];...
[40.5 42.7 85.0];...
[35.3 45.0 90.0];...
]*degree;
betaFibre = orientation('Euler', BFOri(:,1), BFOri(:,2), BFOri(:,3),CS,SS,'bunge');
figure();
plot(BFOri(:,3)./degree,eval(odf,betaFibre));
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
xlswrite('beta_fiber.xlsx', Z);




%%%%%%%%%%%%%%%%%%%%
% % volume fraction%
%%%%%%%%%%%%%%%%%%%%
  
Cu_comp = orientation.byMiller([1 1 2],[1 1 -1],CS,SS);
S_comp = orientation.byMiller([1 2 3],[6 3 -4],CS,SS);
Brass_comp = orientation.byMiller([1 1 0],[1 -1 2],CS,SS);
Cube_comp = orientation.byMiller([0 0 1],[1 0 0],CS,SS);
Goss_comp = orientation.byMiller([1 1 0],[1 0 0],CS,SS);

radius = 15*degree;

volume_frac_Cu_Comp = volume(odf,Cu_comp,radius);
volume_frac_S_Comp = volume(odf,S_comp,radius);
volume_frac_Brass_Comp = volume(odf,Brass_comp,radius);
volume_frac_Cube_Comp = volume(odf,Cube_comp,radius);
volume_frac_Goss_Comp = volume(odf,Goss_comp,radius);

Volume_fraction = [volume_frac_Cu_Comp; volume_frac_S_Comp; volume_frac_Brass_Comp; volume_frac_Cube_Comp;volume_frac_Goss_Comp];



%%%%%%%%%%%%%%v%%%%%%%%%%%%%%%%%%%%
% % volume fraction of any Fibre %%%%
%%%%%%%%%%%%%%%v%%%%%%%%%%%%%%%%%%%

ori=calcOrientations(odf, 10000); % Extracting representative orientations

r = zvector; 
h1 = Miller(0,0,1,CS,'uvw'); % Defining the plane normal parallel to r(defined above)
Volume_fraction_001 = fibreVolume (ori, h1, r, 15 * degree);
Volume_per_cent_001 = 100*Volume_fraction_001;

r = zvector;
h2 = Miller(1,1,1,CS,'uvw');
Volume_fraction_111 = fibreVolume (ori, h2, r, 15 * degree);
Volume_per_cent_111 = 100*Volume_fraction_111;

