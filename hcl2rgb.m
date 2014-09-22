
function rgb = hcl2rgb(h, c, l)
%HCL2RGB Convert a HCL (i.e., CIELUV) color space value to one
%   in sRGB space.
%   RGB = HCL2RGB(H, C, L) will convert the color (H, C, L) in
%   HCL color space to RGB = [R, G, B] in sRGB color space.
%   Values that lie outside sRGB space will be silently corrected.

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

% D65 White Point
WHITE_Y = 100.000;
WHITE_u = 0.1978398;
WHITE_v = 0.4683363;

if l < 0 || l > WHITE_Y || c < 0
    error('Invalid CIE-HCL color.');
end

% First convert to CIELUV (just a polar to Cartesian coordinate transformation)
L = l;
U = c * cosd(h);
V = c * sind(h);

% Now convert to CIEXYZ
if L <= 0 && U == 0 && V == 0
    X = 0;
    Y = 0;
    Z = 0;
else
    Y = WHITE_Y;
    if L > 7.999592
        Y = Y*((L + 16)/116)^3;
    else
        Y = Y*L/903.3;
    end
    u = U/(13*L) + WHITE_u;
    v = V/(13*L) + WHITE_v;
    X = (9.0*Y*u)/(4*v);
    Z = -X/3 - 5*Y + 3*Y/v;
end

% Now convert to sRGB
r = gamma_correct((3.240479*X - 1.537150*Y - 0.498535*Z)/WHITE_Y);
g = gamma_correct((-0.969256*X + 1.875992*Y + 0.041556*Z)/WHITE_Y);
b = gamma_correct((0.055648*X - 0.204043*Y + 1.057311*Z)/WHITE_Y);

% Round to integers and correct
r = round(255 * r);
g = round(255 * g);
b = round(255 * b);
r(r > 255) = 255;
r(r < 0) = 0;
g(g > 255) = 255;
g(g < 0) = 0;
b(b > 255) = 255;
b(b < 0) = 0;
rgb = [r, g, b];


function u = gamma_correct(u)

% Standard CRT Gamma
GAMMA = 2.4;

if u > 0.00304
	u = 1.055*u^(1/GAMMA) - 0.055;
else
	u = 12.92*u;
end
