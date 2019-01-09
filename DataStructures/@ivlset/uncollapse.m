function obj = uncollapse(obj)

obj.Begin = obj.CollapseBuffer_Begin;
obj.End = obj.CollapseBuffer_End;

obj.CollapseBuffer_Begin = int32([]);
obj.CollapseBuffer_End = int32([]);
obj.inCollapsedState = false;