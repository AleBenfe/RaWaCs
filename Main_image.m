%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Script for using the RaWacs algorithm. Three images from the GrabCut
% dataseta are included in this folder: if one wants to apply RaWaCs to
% another image, it should be included in the current folder and selected
% in the drop down menu. Otherwise, the path of the image can be written 
% in the opportune space in the drop down menu.
%
% If you use this code for your research, please cite
%
% Aletti G. , Benfenati A., Naldi G., A Semiautomatic Multi–Label Color
%   Image Segmentation Coupling Dirichlet Problem and Colour Distances,
%   Journal of Imaging, MDPI
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars;
close all;
clc

% Flag for applying the adaptive strategy rof the weights
adaptive = 0;

% Choose the image
[G,indU, labelU,fig] = marking();
waitfor(fig,'BeingDeleted','on');

% Choose the colorspace: the choice 'rgb' does not modify the original
% image.
cSpace = 'rgb';
sG = size(G);
G1 = reshape(G,[prod(sG(1:2)),sG(3)]);
G = cTransform(G,cSpace,'Conversion',1);

figure;
image(G);
axis image, axis off
title("Original image ");

[lab,~,indLab] = unique(labelU);

% Adaptive strategy
if adaptive
    [RegClass,Gmod] = classifier_Regr(G,indU,labelU);
else
    Gmod = G;
end

% Create the Laplacian
[Laplac,D,Z] = laplac_L(Gmod);
% Random walk method
[P,Pone,LU,TOK] = probability_scratch(Laplac,indU,labelU,size(Gmod));
% Computing the similarity index
Sim = simil_end(Z,indU,labelU);

%% Choose the parameters
alpha = 1;
beta  = 1;

Final_function = alpha*log(Sim)+beta*log(P);
[~,IndClass]   = max(reshape(Final_function,[prod(sG(1:2)),size(P,3)]),[],2);

% Segmentation mask
finalMask = zeros(prod(sG(1:2)),1);

% Visualization of the segmentation process for each label
for j1 = 1:length(lab)
    
    figure;
    subplot(2,2,1);
    imagesc(log(P(:,:,j1)));
    axis image, axis off
    title(sprintf("Predict label log(P) %d",lab(j1)));
    
    subplot(2,2,2);
    imagesc(log(Sim(:,:,j1)));
    axis image, axis off
    title(sprintf("Predict label log(Sim) %d",lab(j1)));
    
    subplot(2,2,3);
    G2 = G1*0;
    G2(indU(indLab == j1),:) = G1(indU(indLab == j1),:);
    imagesc(reshape(G2,sG));
    axis image, axis off
    title(sprintf("Label %d",lab(j1)));
    
    subplot(2,2,4);
    G2 = G1*0;
    G2((IndClass == j1),:) = G1((IndClass == j1),:);
    imagesc(reshape(G2,sG));
    axis image, axis off
    title(sprintf("alpha = %2.2f, beta = %2.2f",alpha,beta));
    
    finalMask((IndClass == j1),:) = j1;
    
end

% Visualization of the segmentation mask.
figure
subplot(1,2,1)
imagesc(G)
axis off, axis image
title('Original Image')
subplot(1,2,2)
finalMask = reshape(finalMask,sG(1:2));
imagesc(finalMask)
title('Segmentation Mask')
axis off
axis image
cmap = colormap(parula(length(lab)));
colbar = colorbar;
colbar.Ticks = linspace(1+(length(lab)-1)/(2*length(lab)),...
    length(lab)-(length(lab)-1)/(2*length(lab)),length(lab));
for j1 = 1:length(lab)
    colbar.TickLabels{j1} = sprintf('Label %d',j1);
end

%==========================================================================
%
% Version : 1.0 (23-09-2021)
% Authors : G. Aletti, (giacomo.aletti@unimi.it)
%           A. Benfenati, (alessandro.benfenati@unimi.it)
%
%==========================================================================
%
% COPYRIGHT NOTIFICATION
%
% Permission to copy and modify this software and its documentation for
% internal research use is granted, provided that this notice is retained
% thereon and on all copies or modifications. The authors and their
% respective Universities makes no representations as to the suitability
% and operability of this software for any purpose. It is provided "as is"
% without express or implied warranty. Use of this software for commercial
% purposes is expressly prohibited without contacting the authors.
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 3 of the License, or (at your
% option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.
%
% You should have received a copy of the GNU General Public License along
% with this program; if not, either visite http://www.gnu.org/licenses/ or
% write to Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
% 02139, USA.