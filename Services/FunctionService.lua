local Players = game:GetService("Players")
local TagService = require(script.Parent.Parent.Services.TagService)

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local table = require(script.Parent.Parent.Libraries.table)
local Signal = require(script.Parent.Parent.Classes.Signal)
local Settings = require(script.Parent.Parent.Settings.Settings)

local FunctionService = {}

local Functions = {}

function FunctionService:Create(group: string, f: () -> nil)
	if Functions[group] then error("Group " .. group .. " already used.") end
	Functions[group] = f
end

function FunctionService:Delete(group: string)
	Functions[group] = nil
end

function FunctionService:Fire(group: string, id: any)
	local f = Functions[group]
	if not f then return end
	local tabs = TagService:GetTaggedOfPredicate(Settings.TabTag, function(v: Instance)
		return v:IsDescendantOf(PlayerGui) and v:GetAttribute(Settings.GroupAttribute) == group
	end)
	local pages = TagService:GetTaggedOfPredicate(Settings.PageTag, function(v: Instance)
		return v:IsDescendantOf(PlayerGui) and v:GetAttribute(Settings.GroupAttribute) == group
	end)
	
	local selectedTabs = table.filter(tabs, function(v: Instance)
		return v:GetAttribute(Settings.IdAttribute) == id
	end)
	local unselectedTabs = table.filter(tabs, function(v: Instance)
		return v:GetAttribute(Settings.IdAttribute) ~= id
	end)
	local selectedPages = table.filter(pages, function(v: Instance)
		return v:GetAttribute(Settings.IdAttribute) == id
	end)
	local unselectedPages = table.filter(pages, function(v: Instance)
		return v:GetAttribute(Settings.IdAttribute) ~= id
	end)
	
	f(selectedTabs, selectedPages, unselectedTabs, unselectedPages)
end

return FunctionService