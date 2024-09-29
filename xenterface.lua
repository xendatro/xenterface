local FunctionService = require(script.Parent.Services.FunctionService)

require(script.Parent.Modules.tagger)()

local xenterface = {}

function xenterface:CreateFunction(group: string, f: (functionObject: FunctionService.FunctionObject) -> nil)
	FunctionService:Create(group, f)
end

function xenterface:DeleteFunction(group: string)
	FunctionService:Delete(group)
end

function xenterface:FireFunction(group: string, id: any)
	FunctionService:Fire(group, id)
end

return xenterface