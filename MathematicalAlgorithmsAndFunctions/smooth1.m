function smooth_X = smooth1(X, kernel_std, sampleRate)
% Smoothing of 1-D vector with convolution

kernel_support = kernel_std * 5;
kernel_x = linspace(-kernel_support, kernel_support, 2*kernel_support*sampleRate+1);
kernel = normpdf(kernel_x, 0, kernel_std) / sampleRate;
smooth_X = conv(X, kernel, 'same');
