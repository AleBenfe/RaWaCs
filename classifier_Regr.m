function [RegClass,Znew] = classifier_Regr(Z,indU,labelU)
%
% classifier_Regr computes the new weigths to use in the similariy index.
%
% [RegClass,Znew] = classifier_Regr(Z,indU,labelU)
%
% updates in Znew the values of the neighbourhood with the new weights,
% while RegClass provides the regression trees used for the adaptive
% strategy.
%
% If you use this code for your research, please cite
%
% Aletti G. , Benfenati A., Naldi G., A Semiautomatic Multi–Label Color
%   Image Segmentation Coupling Dirichlet Problem and Colour Distances,
%   Journal of Imaging, MDPI
%
% -------------------------------------------------------------------------
% MANDATORY INPUT
%
% Z       : (double array) neighbourhood matrix
% indU    : (double array) vector containing the positions of the marked
%                          regions. It refers to the vectorized version of
%                          the original image.
% labelU  : (double array) vector containing the corresponding labels.
%
% -------------------------------------------------------------------------
% OUTPUT
%
% Znew    : (double array) array of  dimension [m,n,d], where [m,n] is the
%                          size of the original image and d is the number
%                          of neighbourhoods. Each element is weighted via
%                          the weight computed by the regression tree.
%
% -------------------------------------------------------------------------
%
% See also NINECLOSE

[~,~,indLab] = unique(labelU);

Znew = zeros(size(Z));
dim3 = size(Z,3);
W    = nineClose(Z);
dW   = size(W);
Z1   = reshape(W,[prod(dW(1:2)),dW(3)]);
Y1   = reshape(Z,[prod(dW(1:2)),dim3]);

% Training set (labelled)
X  = Z1(indU,:);
Y1 = Y1(indU,:);
% Storing the result: a regression tree for each label.
RegClass = cell(dim3,1);
for r1 = 1:dim3
    centroid = groupsummary(Y1(:,r1),indLab,'mean'); % Y
    % Setting the seed for repeatability 
    rng default
    
    RegClass{r1} = compact(fitrtree(X,centroid(indLab),...
        'OptimizeHyperparameters','auto',...
        'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
        'expected-improvement-plus',...
        'ShowPlots',0,...
        'Verbose',0,...
        'UseParallel',1,...
        'MaxObjectiveEvaluations',30)...
        ));
    
    Znew(:,:,r1) = reshape(predict(RegClass{r1},Z1),dW(1:2));
end

end

%==========================================================================
%
% Version : 1.0 (23-09-2021)
% Authors  : G. Aletti (giacomo.aletti@unimi.it)
%            A. Benfenati (alessandro.benfenati@unimi.it)
%            G. Naldi (giovanni.naldi@unimi.it)
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

