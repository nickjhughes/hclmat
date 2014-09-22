
%HCLCOLS Define a struct 'cols' with fields the same as the default MATLAB
%   colors (e.g., 'r', 'b', etc.), but which are defined using the HCL
%   colorspace. These are a drop-in replacement, so instead of
%   plot(x, y, 'r') one can use plot(x, y, 'Color', cols.r) to use these
%   much nicer colours.

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

cols = struct('b', hcl2rgb(240, 80, 50)/255, ...
              'g', hcl2rgb(120, 80, 50)/255, ...
              'r', hcl2rgb(0,   80, 50)/255, ...
              'c', hcl2rgb(180, 80, 50)/255, ...
              'm', hcl2rgb(300, 80, 50)/255, ...
              'y', hcl2rgb(80, 80, 50)/255, ...
              'k', [0 0 0], ...
              'w', [1 1 1]);
