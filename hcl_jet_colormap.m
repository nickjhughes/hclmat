
function map = hcl_jet_colormap(m, c, l)
%HCL_JET_COLORMAP Generate a non-periodic colormap using HCL color space.
%   MAP = HCL_JET_COLORMAP(M) will create a colormap of M equally
%   spaced hues ranging from blue to red, with chroma 35 and luminance
%   85. The size of MAP is [M,3], where each row is an RGB triple in [0,1].
%   
%   MAP = HCL_JET_COLORMAP(M, C, L) will create a colormap as
%   above but with chroma C and luminance L, 0 <= C <= 100 and
%   0 <= L <= 100.
%
%   This can be thought of as the equal-perception version of JET.

% Code written by Nicholas J. Hughes, 2015, released under the following
% licence.
%
% The MIT License (MIT)
%
% Copyright (c) 2015 Nicholas J. Hughes
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
% THE SOFTWARE.

if nargin < 1
    m = size(get(gcf,'colormap'),1);
end
if nargin < 2
    c = 35;
end
if nargin < 3
    l = 85;
end
h = flipud((0:m-1)'/max(m-1,1)*250);
if isempty(h)
    map = [];
else
    map = nan(m,3);
    for j = 1:m
        map(j,:) = hcl2rgb(h(j), c, l)/255;
    end
end
