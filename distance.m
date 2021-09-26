function [D,indS,Z] = distance(X)
%
% distance computes the inverse of the distance of each pixel in the image
% X from all the user marked labels.
%
% [D,inds,Z] = distance(X)
%
% provides the inverse of the distances of the image pixels from each
% marked region. These quantities are used as weights in the Laplacian
% matrix. The matrix Z contains the neighbourhood of each pixel, whilst
% indS contains the indexes of the neighbours.
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
% X       : (double array) image
%
% -------------------------------------------------------------------------
% OUTPUT
%
% D       : (double array) distance matrix
% indS    : (double array) Indexes
% Z       : (double array) neighbourhood matrix
% -------------------------------------------------------------------------
%
% See also LAPLAC_L, NINECLOSE

Z = nineClose(X);
dZ = size(Z);
indMatrix = reshape(1:prod(dZ(1:2)),dZ(1),dZ(2));
D = zeros([dZ(1:2),4]);
indS = D;
j1 = 1;
for dim = 1:2
    for jump = [-1,1]
        Z2 = circshift(Z,jump,dim);
        D(:,:,j1) = distMatr(Z,Z2);
        indS(:,:,j1) = circshift(indMatrix,jump,dim);
        j1 = j1+1;
    end
end


    function d = distMatr(Z,Z2)
        % computing the weights.
        d = 1./(sqrt(sum((Z-Z2).*(Z-Z2),3))+1e-3);
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