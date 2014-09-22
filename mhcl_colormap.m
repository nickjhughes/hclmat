
function map = mhcl_colormap(m, c, l, mod, tau)
% MHCL_COLORMAP Generate a colormap using mHCL color space,
%    which is HCL with a modulated luminance.
%    MAP = MHCL_COLORMAP(M) will create a colormap of M equally
%    spaced hues with chroma 35 and luminance 85+5*sin(hue).
%    
%    MAP = MHCL_COLORMAP(M, C, L, MOD, TAU) will create a colormap
%    as above but with chroma C and luminance L+mod*sin(hue*tau),
%    which will be clamped to [0,100] silently.

% Code written by Nicholas J. Hughes, 2014, released under the following
% licence.
%
% The MIT License (MIT)
%
% Copyright (c) 2014 Nicholas J. Hughes
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

if nargin < 2
    c = 35;
end
if nargin < 3
    l = 85;
end
if nargin < 4
    mod = 5;
end
if nargin < 5
    tau = 1;
end

h = (0:m-1)'/max(m,1)*360;
l = l + mod*sind(tau*h);
l(l > 100) = 100;
l(l < 0) = 0;
map = nan(m,3);
for j = 1:m
    map(j,:) = hcl2rgb(h(j), c, l(j))/255;
end
