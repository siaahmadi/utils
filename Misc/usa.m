function cmap = usa(res)
%USA Color map loosely based on the red and blue United States flag colors

if nargin < 1
	res = 64;
end

cmap = [

            0      0.44706      0.74118
     0.036685      0.46734      0.75067
      0.07337      0.48763      0.76017
      0.11005      0.50791      0.76966
      0.14674       0.5282      0.77916
      0.18342      0.54848      0.78865
      0.22011      0.56877      0.79815
      0.25679      0.58905      0.80764
      0.29348      0.60934      0.81714
      0.33016      0.62962      0.82663
      0.36685       0.6499      0.83613
      0.40353      0.67019      0.84562
      0.44022      0.69047      0.85512
       0.4769      0.71076      0.86461
      0.51359      0.73104       0.8741
      0.55027      0.75133       0.8836
      0.58696      0.77161      0.89309
      0.62364       0.7919      0.90259
      0.66033      0.81218      0.91208
      0.69701      0.83246      0.92158
       0.7337      0.85275      0.93107
      0.77038      0.87303      0.94057
      0.80707      0.89332      0.95006
      0.84375       0.9136      0.95956
      0.85806      0.92015        0.961
      0.87237       0.9267      0.96245
      0.88668      0.93325      0.96389
      0.90099       0.9398      0.96533
      0.91531      0.94635      0.96678
      0.92962       0.9529      0.96822
      0.94393      0.95945      0.96966
      0.95824        0.966      0.97111
      0.97255      0.97255      0.97255
      0.97286      0.96515      0.96182
      0.97317      0.95776      0.95109
      0.97348      0.95037      0.94036
      0.97379      0.94297      0.92963
       0.9741      0.93558       0.9189
      0.97441      0.92818      0.90817
      0.97472      0.92079      0.89744
      0.97503      0.91339      0.88671
      0.97534        0.906      0.87598
      0.97565       0.8986      0.86525
      0.97596      0.89121      0.85452
      0.96972      0.86292       0.8167
      0.96347      0.83464      0.77887
      0.95722      0.80635      0.74105
      0.95097      0.77806      0.70323
      0.94472      0.74978       0.6654
      0.93847      0.72149      0.62758
      0.93222      0.69321      0.58975
      0.92597      0.66492      0.55193
      0.91972      0.63664      0.51411
      0.91347      0.60835      0.47628
      0.90722      0.58006      0.43846
      0.90097      0.55178      0.40063
      0.89472      0.52349      0.36281
      0.88848      0.49521      0.32498
      0.88223      0.46692      0.28716
      0.87598      0.43863      0.24934
      0.86973      0.41035      0.21151
      0.86348      0.38206      0.17369
      0.85723      0.35378      0.13586
      0.85098      0.32549     0.098039
			];