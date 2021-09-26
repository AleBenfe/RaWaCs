function G = cTransform(x,cSpace,varargin)
% cTransform converts a rgb image into cSpace image and viceversa.
%
% G = cTransform(x,cSpace,varargin)
%
% converts the image x from rgb colorspace to cSpace colorspace when the
% 3rd argument of the function is
% - ycbcr
% - lab
% - xyz
% - hsv
%
% If you use this code for your research, please cite
%
% Aletti G. , Benfenati A., Naldi G., A Semiautomatic Multi–Label Color
%   Image Segmentation Coupling Dirichlet Problem and Colour Distances,
%   Journal of Imaging, MDPI
%
% -------------------------------------------------------------------------
% MANDATORY INPUT
% x       : (double array) image
% cSpace  : (string)       colorspace in which the image is converted
%
% -------------------------------------------------------------------------
% OPTIONAL INPUT
%
% covnersion : (integer)   flag for direct(1) or inverse(-1) conversion.
%                          Default: 1.
%
% -------------------------------------------------------------------------
% OUTPUT
%
% G       : (double array) converted image
%


flag = 1;
if (nargin-length(varargin)) ~= 2
    error('Wrong number of required parameters');
end

if (rem(length(varargin),2)==1)
    error('Optional parameters should always go by pairs');
    % fprintf('!\n');
else
    for i=1:2:(length(varargin)-1)
        switch upper(varargin{i})
            case 'CONVERSION'
                flag = varargin{i+1};
                if abs(flag) ~= 1
                    error('Unkonwn option. Available choice are 1 (rgb->cSpace) or -1 (cSpace->rgb)')
                end
        end
    end
end

switch cSpace
    case 'ycbcr'
        T  = @(x) rgb2ycbcr(x);
        TI = @(x) ycbcr2rgb(x);
    case 'lab'
        T =  @(x) rgb2lab(x);
        TI = @(x) lab2rgb(x);
    case 'hsv'
        T  = @(x) rgb2hsv(x);
        TI = @(x) hsv2rgb(x);
    case 'xyz'
        T  = @(x) rgb2xyz(x);
        TI = @(x) xyz2rgb(x);
    case 'rgb'
        T  = @(x) x;
        TI = @(x) x;
    otherwise
        error('Unkown color space. Avaialable options: ycbcr,lab, hsv,xyz,rgb');
end

if flag
    G = T(x);
else
    G = TI(x);
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
%