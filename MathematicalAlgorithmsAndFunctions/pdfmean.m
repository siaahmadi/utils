function m = pdfmean(p, pts)
p = p(:);
pts = pts(:);

p = p / trapz(pts, p); % make sure it's a pdf
dx = abs(diff([pts(2); pts]));
m = sum(p .* pts .* dx); % expected value
end