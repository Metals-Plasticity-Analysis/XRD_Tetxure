clear;
close;
cs = crystalSymmetry('cubic');
ss = specimenSymmetry('orthorhombic');

cube = orientation('Euler',[0,0,0]*degree,cs,ss);
odf_Cube = unimodalODF(cube,'halfwidth',11*degree);

odf_1 = uniformODF(cs,ss);
odf=0.5*odf_Cube+0.5*odf_1;

% S=orientation('Euler',[59,37,63]*degree,cs,ss);
% odf_S=unimodalODF(S,'halfwidth',5*degree);

% Brass=orientation('Euler',[35,45,0]*degree,cs,ss);
% odf_Bs=unimodalODF(Brass,'halfwidth',5*degree);

%odf_2=odf_Cube;
ori1 = calcOrientations(odf,150);
% odf_1 = uniformODF(cs,ss);
% ori = orientation('Miller',[1,1,2],[1,1,-1],cs,ss);
% psi = vonMisesFisherKernel('HALFWIDTH',10*degree);
% odf = unimodalODF(ori,'halfwidth',5*degree);
%plotPDF(odf,[Miller(1,1,1,cs)],'antipodal','complete');
%figure ()
plot(odf,'phi2',[0 45 65]* degree,'contour','antipodal','linewidth',2,'colorbar');