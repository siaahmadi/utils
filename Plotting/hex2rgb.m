function [r, g, b] = hex2rgb(hexval)
r = bitand(bitshift(hex2dec(hexval), -16), 2^8-1) / 255;
g = bitand(bitshift(hex2dec(hexval), -8), 2^8-1) / 255;
b = bitand(hex2dec(hexval), 2^8-1) / 255;