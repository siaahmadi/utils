function color = colorpallette(requestedcolor)
pallette = nrnColorSet;

pallette.RED_DARK = [194, 66, 67] / 255;
pallette.RED_LIGHT = [241, 181, 186] / 255;
pallette.BLUE_DARK1 = [51,85,107] / 255;
pallette.BLUE_DARK2 = [55, 92, 170] / 255;
pallette.BLUE_LIGHT2 = [120, 200, 235] / 255;
pallette.TURQOISE_DARK = [92, 177, 180] / 255;
pallette.TURQOISE_LIGHT = [119, 205, 211] / 255;

requestedcolor = upper(requestedcolor);

color = pallette.(requestedcolor);

function nrnColors = nrnColorSet()
% some of the colors used by the journal Nature Reviews Neuroscience

[nrnColors.RED(1), nrnColors.RED(2), nrnColors.RED(3)] = hex2rgb('ef4522');
[nrnColors.RED_CANESCENT(1), nrnColors.RED_CANESCENT(2), nrnColors.RED_CANESCENT(3)] = hex2rgb('e7cbc5');
[nrnColors.RED_ORANGE(1), nrnColors.RED_ORANGE(2), nrnColors.RED_ORANGE(3)] = hex2rgb('e46044');
[nrnColors.BROWN(1), nrnColors.BROWN(2), nrnColors.BROWN(3)] = hex2rgb('f4b179');
[nrnColors.BROWN_LIGHT(1), nrnColors.BROWN_LIGHT(2), nrnColors.BROWN_LIGHT(3)] = hex2rgb('f6bd8b');
[nrnColors.ORANGE(1), nrnColors.ORANGE(2), nrnColors.ORANGE(3)] = hex2rgb('ea7f22');
[nrnColors.ORANGE_DUTCH(1), nrnColors.ORANGE_DUTCH(2), nrnColors.ORANGE_DUTCH(3)] = hex2rgb('eb740c');
[nrnColors.ORANGE_DUTCH2(1), nrnColors.ORANGE_DUTCH2(2), nrnColors.ORANGE_DUTCH2(3)] = hex2rgb('ff6600');
[nrnColors.GREEN_LIGHT(1), nrnColors.GREEN_LIGHT(2), nrnColors.GREEN_LIGHT(3)] = hex2rgb('bee0db');
[nrnColors.GREEN_ASPARAGUS(1), nrnColors.GREEN_ASPARAGUS(2), nrnColors.GREEN_ASPARAGUS(3)] = hex2rgb('82ba78');
[nrnColors.GREEN(1), nrnColors.GREEN(2), nrnColors.GREEN(3)] = hex2rgb('239f64');
[nrnColors.GREEN_CANESCENT(1), nrnColors.GREEN_CANESCENT(2), nrnColors.GREEN_CANESCENT(3)] = hex2rgb('b4d7c6');
[nrnColors.BLUE_LIGHT(1), nrnColors.BLUE_LIGHT(2), nrnColors.BLUE_LIGHT(3)] = hex2rgb('bae7f3');
[nrnColors.BLUE(1), nrnColors.BLUE(2), nrnColors.BLUE(3)] = hex2rgb('0077ba');
[nrnColors.BLUE_INK(1), nrnColors.BLUE_INK(2), nrnColors.BLUE_INK(3)] = hex2rgb('0477fb');
[nrnColors.BLUE_LIGHT_NAVY(1), nrnColors.BLUE_LIGHT_NAVY(2), nrnColors.BLUE_LIGHT_NAVY(3)] = hex2rgb('3c5f99');
[nrnColors.BLUE_NAVY(1), nrnColors.BLUE_NAVY(2), nrnColors.BLUE_NAVY(3)] = hex2rgb('3853a3');
[nrnColors.YELLOW(1), nrnColors.YELLOW(2), nrnColors.YELLOW(3)] = hex2rgb('fed892');
[nrnColors.GOLDEN(1), nrnColors.GOLDEN(2), nrnColors.GOLDEN(3)] = hex2rgb('fdbf11');
[nrnColors.PINK(1), nrnColors.PINK(2), nrnColors.PINK(3)] = hex2rgb('e1b8d0');
[nrnColors.PURPLE(1), nrnColors.PURPLE(2), nrnColors.PURPLE(3)] = hex2rgb('9a91bf');
[nrnColors.VIOLET(1), nrnColors.VIOLET(2), nrnColors.VIOLET(3)] = hex2rgb('670167');
[nrnColors.MAGENTA(1), nrnColors.MAGENTA(2), nrnColors.MAGENTA(3)] = hex2rgb('c2619c');

function [r, g, b] = hex2rgb(hexval)
r = bitand(bitshift(hex2dec(hexval), -16), 2^8-1) / 255;
g = bitand(bitshift(hex2dec(hexval), -8), 2^8-1) / 255;
b = bitand(hex2dec(hexval), 2^8-1) / 255;