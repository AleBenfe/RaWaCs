function Sfin = simil_end(Z,indU,labelU)
%
% simil_end computes the similarity index of between each pixel of the
% image and the centroids of the marked regions.
%
% Sfin = simil_end(Z,indU,labelU)
%
% computes the similarity index between each array in position (i,j,:) in the
% matrix Z, which contains the neighbourhood of a the (i,j)--th pixel in
% the original image, and the centroids of the region marked by the user.
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
% Sfin    : (double array) array with dimension [m,n,l], where [m,n] is the
%                          size of the original image and l is the number
%                          of labels. Each layer in the 3rd dimension
%                          provides the similarity index from each label.
%
% -------------------------------------------------------------------------
%
% See also NINECLOSE


[lab,~,indLab] = unique(labelU);
dZ             = size(Z);
Z1             = reshape(Z,[prod(dZ(1:2)),dZ(3)]);
Sfin           = zeros([dZ(1:2),length(lab)]);

for j1 = 1:length(lab)
    centroid = reshape(mean(Z1(indU(indLab==j1),:)),[1,1,dZ(3)]);
    Sfin(:,:,j1) = simils(Z,repmat(centroid,[dZ(1:2),1]));
end

Sfin = Sfin ./ sum(Sfin,3);

    function s = simils(Z,Z2)
        % Implementing the similarity index
        s = 1./(sqrt(sum((Z-Z2).*(Z-Z2),3))+1e-3);
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