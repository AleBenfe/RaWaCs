function Z = nineClose(X)
%
% nineClose computes the neighbourhood matrix for each pixel of the image
% X.
%
% Z = nineClose(X)
%
% is a m x n x 9p array, where [m,n,p] is the size of X. It provides the
% 8-neighbourhood of a pixel (and the pixel itself).
%
% -------------------------------------------------------------------------
% MANDATORY INPUT
%
% X       : (double array) image
%
% -------------------------------------------------------------------------
% OUTPUT
%
% Z       : (double array) neighbourhood matrix
% -------------------------------------------------------------------------
%
% See also LAPLAC_L, DISTANCE

dX = size(X);
if ismatrix(X)
    d3 = 1;
else
    d3 = dX(3);
end
dX  = [dX(1:2),9*d3];
Z   = zeros(dX);
j1  = 1;
for r = -1:1
    Y = circshift(X,r,1);
    for c = -1:1
        Z(:,:,((j1-1)*d3+1):(j1*d3)) = circshift(Y,c,2);
        j1 = j1 + 1;
    end
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
