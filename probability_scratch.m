function [P,Pone,LU,TOK] = probability_scratch(Laplac,indU,labelU,dX)
%
% probability_scratch apply the randow walk method using the Laplacian
% matrix Laplax and the information about the user-marked regions.
%
% [P,Pone,LU,TOK] = probability_scratch(Laplac,indU,labelU,dX)
%
% extracts the submatrix of the Laplacian related to unmarked regions, and
% then solves the linear system Lu = B^t m, where u denotes the unmarked
% pixels and m the marked ones.
%
% -------------------------------------------------------------------------
% MANDATORY INPUT
%
% Laplac  : (double array) Laplacian matrix
% indU    : (double array) vector containing the positions of the marked
%                          regions. It refers to the vectorized version of
%                          the original image.
% labelU  : (double array) vector containing the corresponding labels.
% dX      : (double array) size of the image
%
% -------------------------------------------------------------------------
% OUTPUT
%
% P       : (double array) probabilities of all pixels. Its dimension
%                          is m x n x l, where [m,n] is the dimension of
%                          the original image, while l is the number of
%                          labels.
% Pone    : (double array) probabilities of unmarked pixels.
% LU      : (double array) submatrix of the Laplacian reffering to unmarked
%                          pixels.
% TOK     : (double array) marked pixels.
% -------------------------------------------------------------------------
%
% See also LAPLAC_L, DISTANCE, NINECLOSE


[lab,~,indLab] = unique(labelU);

mLab = sparse(1:length(indLab),indLab,1,length(indLab),length(lab));
indL = setdiff(1:size(Laplac,1),indU);
% Submatrix of the Laplacian reffering to unmarked pixels.
LU  = Laplac(indL,indL);
% rhs term of the linear system
TOK = - Laplac(indL,indU)* mLab;
% Solving the system
Pone =  LU \ TOK;
% Resizing and storing the correct probabilities
P         = full(sparse(indU,indLab,1,size(Laplac,1),length(lab)));
P(indL,:) = full(Pone);
P         = reshape(P,[dX(1:2),length(lab)]);
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