function I = isvalidhandle(toTest)

I = ~isempty(toTest) && ishandle(toTest) && isvalid(toTest);