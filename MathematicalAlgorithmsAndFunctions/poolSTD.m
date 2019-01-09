function standard_deviation = poolSTD(previousSTD, previousDOF, newSTD, newDOF)

if newDOF < 0
	standard_deviation = previousSTD;
	return
end

standard_deviation = sqrt((previousDOF.*previousSTD.^2 + newDOF.*newSTD.^2)./(previousDOF+newDOF));