function I = hoveratop(pt, v1, v2)

d = dot(pt-v1, v2-v1);

I = d > 0 & d < eucldist(v1(1), v1(2), v2(1), v2(2));