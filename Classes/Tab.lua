local FunctionService = require(script.Parent.Parent.Services.FunctionService)

local Settings = require(script.Parent.Parent.Settings.Settings)

local Tab = {}
Tab.__index = Tab

local function setUpConnections(self)
	self.Connections = {}
	self.MouseButton1Click = self.Tab.MouseButton1Click:Connect(function()
		FunctionService:Fire(
			self.Tab:GetAttribute(Settings.GroupAttribute),
			self.Tab:GetAttribute(Settings.IdAttribute)
		)
	end)
end

function Tab.new(tab: GuiButton)
	local self = setmetatable({}, Tab)

	self.Tab = tab

	setUpConnections(self)

	return self
end

function Tab:Destroy()
	if self.Connections.MouseButton1Click then
		self.Connections.MouseButton1Click:Disconnect()
	end
end

return Tab