function [Laplac,D,Z] = laplac_L(X)
% laplac_L computes the Laplacian matrix whose weights are computed using
% the function distance.
%
% [Laplac,D,Z] = laplac_L(X)
%
% provides the Laplacian matrix Laplac, the matrix D which contains the
% distances of each pixel  from the centroids of the marked regions and the
% matrix Z whose elements contains the 9 pixels of each neighbourhood.
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
% Laplac  : (double array) Laplacian matrix
% D       : (double array) distance matrix
% Z       : (double array) neighbourhood matrix
% -------------------------------------------------------------------------
%
% See also DISTANCE, NINECLOSE

%%
    [D,indS,Z]  = distance(X);
    dZ          = size(D);
    indE        = repmat(reshape(1:prod(dZ(1:2)),dZ(1),dZ(2)),[1,1,dZ(3)]);
    Laplac      = - sparse(indE(:), indS(:), D(:),prod(dZ(1:2)),prod(dZ(1:2)));
    Diag        = full(sum(Laplac,2));
    Laplac      = spdiags(-Diag,0,Laplac);
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