function es = effectsize(x, y, s_x, s_y, n_x, n_y, proportions)
%EFFECTSIZE Statistical Effect Size for Normally Distributed Samples
%
% es = EFFECTSIZE(x, y)
% Effect size based on samples
%    difference between mean of x and y devided by their pooled standard
%    deviation
%
% es = EFFECTSIZE(m1, m2, s1, s2)
% Effect size based on mean and s.t.d

% Siavash Ahmadi
% 10/07/2017

if ~exist('s_x', 'var')
	v1 = var(x);
	v2 = var(x);
	m_x = mean(x);
	m_y = mean(y);
	n1 = length(x);
	n2 = length(y);
else
	v1 = s_x^2;
	v2 = s_y^2;
	m_x = x;
	m_y = y;
	n1 = n_x;
	n2 = n_y;
end

if proportions
% 	S_p = sqrt(x*(1-y)*(n1+n2)/(n1*n2));
	S_p = sqrt( (x*(1-x)/n1) + (y*(1-y)/n2) );
else
	S_p = sqrt( ((n1-1)*v1 + (n2-1)*v2) / (n1 + n2 - 2) ); % pooled s.t.d.
end

es = (m_y - m_x) / S_p;