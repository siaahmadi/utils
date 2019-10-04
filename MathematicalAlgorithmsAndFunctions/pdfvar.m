function v = pdfvar(p, pts)
p = p(:);
pts = pts(:);

p = p / trapz(pts, p); % make sure it's a pdf

dx = abs(diff([pts(2); pts]));
EX2 = sum(p .* pts.^2 .* dx); % expected value

E2X = pdfmean(p, pts) ^ 2;

v = EX2 - E2X; % variance
end