local FunctionService = require(script.Parent.Services.FunctionService)

require(script.Parent.Modules.tagger)()

local xenterface = {}

function xenterface:CreateFunction(pageGroup: string, f: (functionObject: FunctionService.FunctionObject) -> nil)
	FunctionService:Create(pageGroup, f)
end

function xenterface:DeleteFunction(pageGroup: string)
	FunctionService:Delete(pageGroup)
end

function xenterface:FireFunction(pageGroup: string, pageId: string | number, rawTab: GuiButton?)
	FunctionService:Fire(pageGroup, pageId, rawTab)
end

return xenterface