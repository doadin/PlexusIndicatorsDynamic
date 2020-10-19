local AddonName = ...
local Plexus = Plexus
local PlexusFrame = Plexus:GetModule("PlexusFrame")
local Media = LibStub("LibSharedMedia-3.0")
local AceGUI = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local PlexusIndicatorsDynamic = Plexus:NewModule(AddonName)
PlexusIndicatorsDynamic.defaultDB = {
	settings = {
		textId = 1,
		iconId = 1,
		boxId = 1,
	},
}

local options

local function UpdateIndicatorName(info, value)
	local id = info[#info - 1]
	PlexusIndicatorsDynamic.db.profile[id].name = value
	options.args[id].name = value
	Plexus.options.args.PlexusIndicator.args[id].name = value
	PlexusFrame:UpdateOptionsForIndicator(id, value)
end

local function DeleteIndicator(info)
	local id = info[#info - 1]
	PlexusIndicatorsDynamic.db.profile[id] = nil
	options.args[id] = nil
	PlexusFrame.db.profile.statusmap[id] = nil
	Plexus.options.args.PlexusIndicator.args[id] = nil
	for _, f in pairs(PlexusFrame.registeredFrames) do
		f:ClearIndicator(id)
	end
end

local function GetAnchorMenu()
	return {
		name = "Layout Anchor",
		desc = "Sets where this indicator is anchored relative to the frame.",
		order = 5,
		width = "double",
		type = "select",
		values = {
			CENTER      = "Center",
			TOP         = "Top",
			BOTTOM      = "Bottom",
			LEFT        = "Left",
			RIGHT       = "Right",
			TOPLEFT     = "Top Left",
			TOPRIGHT    = "Top Right",
			BOTTOMLEFT  = "Bottom Left",
			BOTTOMRIGHT = "Bottom Right",
		},
	}
end

local function GetDefaultTextOptionMenu()
	return {
		name = "New Dynamic Text",
		desc = "Configure this text",
		order = 300,
		type = "group",
		args = {
			name = {
				name = "Name",
				order = 1,
				type = "input",
				set = UpdateIndicatorName
			},
			delete = {
				name = "Delete",
				order = 2,
				type = "execute",
				func = DeleteIndicator
			},
			anchor = GetAnchorMenu(),
			offsetX = {
				name = "Offset X",
				desc = "Adjust the X offset",
				order = 10,
				type = "range", min = -100, max = 100, step = 1,
			},
			offsetY = {
				name = "Offset Y",
				desc = "Adjust the Y offset",
				order = 11,
				type = "range", min = -100, max = 100, step = 1,
			},
			font = {
				name = "Font",
				desc = "Adjust the font settings",
				order = 20, width = "double",
				type = "select",
				values = Media:HashTable("font"),
				dialogControl = "LSM30_Font",
			},
			fontSize = {
				name = "Font Size",
				desc = "Adjust the font size.",
				order = 21, width = "double",
				type = "range", min = 6, max = 24, step = 1,
			},
			fontOutline = {
				name = "Font Outline",
				desc = "Adjust the font outline.",
				order = 30, width = "double",
				type = "select",
				values = {
					NONE = "None",
					OUTLINE = "Thin",
					THICKOUTLINE = "Thick",
				},
			},
			fontShadow = {
				name = "Font Shadow",
				desc = "Toggle the font drop shadow effect.",
				order = 40, width = "double",
				type = "toggle",
			},
			textlength = {
				name = "Text Length",
				desc = "Number of characters to show on the text indicators.",
				order = 50, width = "double",
				type = "range", min = 1, max = 12, step = 1,
			},
			frameLevel = {
				name = "Frame level",
				desc = "If you have overlapping indicators this determines which gets rendered on top.",
				order = 60, width = "double",
				type = "range", min = -1, max = 10, step = 1,
			},
		},
	}
end

local function GetDefaultIconOptionMenu()
	return {
		name = "New Dynamic Icon",
		desc = "Configure this icon.",
		order = 300,
		type = "group",
		args = {
			name = {
				name = "Name",
				order = 1,
				type = "input",
				set = UpdateIndicatorName
			},
			delete = {
				name = "Delete",
				order = 2,
				type = "execute",
				func = DeleteIndicator
			},
			anchor = GetAnchorMenu(),
			offsetX = {
				name = "Offset X",
				desc = "Adjust the X offset",
				order = 20,
				type = "range", min = -100, max = 100, step = 1,
			},
			offsetY = {
				name = "Offset Y",
				desc = "Adjust the Y offset",
				order = 21,
				type = "range", min = -100, max = 100, step = 1,
			},
			iconSize = {
				name = "Icon Size",
				desc = "Adjust the size of the icons.",
				order = 30, width = "double",
				type = "range", min = 5, max = 50, step = 1,
			},
			iconBorderSize = {
				name = "Icon Border Size",
				desc = "Adjust the size of the center icon's borders.",
				order = 31, width = "double",
				type = "range", min = 0, max = 9, step = 1,
			},
			enableIconCooldown = {
				name = "Enable Icon Cooldown Frame",
				desc = "Toggle center icon's cooldown frame.",
				order = 40, width = "double",
				type = "toggle",
			},
			enableIconStackText = {
				name = "Enable Icon Stack Text",
				desc = "Toggle center icon's stack count text.",
				order = 50, width = "double",
				type = "toggle",
			},
			stackFontSize = {
				name = "Icon Stack Text Font Size",
				desc = "Adjust the font size of the icon stack text.",
				order = 51, width = "double",
				type = "range", min = 4, max = 24, step = 1,
			},
			stackOffsetX = {
				name = "Icon Stack Text Offset X",
				desc = "Adjust the position of the icon stack text.",
				order = 60, width = "normal",
				type = "range", softMin = -20, softMax = 20, step = 1,
			},
			stackOffsetY = {
				name = "Icon Stack Text Offset Y",
				desc = "Adjust the position of the icon stack text.",
				order = 61, width = "normal",
				type = "range", softMin = -20, softMax = 20, step = 1,
			},
			frameLevel = {
				name = "Frame level",
				desc = "If you have overlapping indicators this determines which gets rendered on top.",
				order = 70, width = "double",
				type = "range", min = -1, max = 10, step = 1,
			},
		},
	}
end

local function GetDefaultBoxOptionMenu()
	return {
		name = "New Dynamic Box",
		desc = "Configure this box",
		order = 300,
		type = "group",
		args = {
			name = {
				name = "Name",
				order = 1,
				type = "input",
				set = UpdateIndicatorName
			},
			delete = {
				name = "Delete",
				order = 2,
				type = "execute",
				func = DeleteIndicator
			},
			anchor = GetAnchorMenu(),
			offsetX = {
				name = "Offset X",
				desc = "Adjust the X offset",
				order = 20,
				type = "range", min = -100, max = 100, step = 1,
			},
			offsetY = {
				name = "Offset Y",
				desc = "Adjust the Y offset",
				order = 21,
				type = "range", min = -100, max = 100, step = 1,
			},
			size = {
				name = "Size",
				desc = "Adjust the size.",
				order = 30, width = "double",
				type = "range", min = 1, max = 24, step = 1,
			},
			frameLevel = {
				name = "Frame level",
				desc = "If you have overlapping indicators this determines which gets rendered on top.",
				order = 70, width = "double",
				type = "range", min = -1, max = 10, step = 1,
			},
		},
	}
end

local function NewIconIndicator()
	PlexusIndicatorsDynamic.db.profile.settings.iconId = PlexusIndicatorsDynamic.db.profile.settings.iconId + 1
	local id = "pid_icon_" .. PlexusIndicatorsDynamic.db.profile.settings.iconId
	PlexusIndicatorsDynamic.db.profile[id] = {
		anchor = "CENTER",
		offsetX = 0,
		offsetY = 0,
		iconSize = 12,
		iconBorderSize = 0,
		enableIconStackText = true,
		enableIconCooldown = true,
		stackFontSize = 7,
		stackOffsetX = 4,
		stackOffsetY = -2,
		frameLevel = 1,
	}
	options.args[id] = GetDefaultIconOptionMenu()
	PlexusIndicatorsDynamic:Icon_RegisterIndicator(id, options.args[id].name)
	PlexusFrame:UpdateOptionsForIndicator(id, options.args[id].name)
	AceConfigDialog:SelectGroup("Plexus", "PlexusIndicatorsDynamic", id)
end

local function NewTextIndicator()
	PlexusIndicatorsDynamic.db.profile.settings.textId = PlexusIndicatorsDynamic.db.profile.settings.textId + 1
	local id = "pid_text_" .. PlexusIndicatorsDynamic.db.profile.settings.textId
	PlexusIndicatorsDynamic.db.profile[id] = {
		anchor = "CENTER",
		offsetX = 0,
		offsetY = 0,
		font = "Friz Quadrata TT",
		fontSize = 8,
		fontOutline = "THIN",
		fontShadow = false,
		textlength = 6,
		frameLevel = 1,
	}
	options.args[id] = GetDefaultTextOptionMenu()
	PlexusIndicatorsDynamic:Text_RegisterIndicator(id, options.args[id].name)
	PlexusFrame:UpdateOptionsForIndicator(id, options.args[id].name)
	AceConfigDialog:SelectGroup("Plexus", "PlexusIndicatorsDynamic", id)
end

local function NewBoxIndicator()
	PlexusIndicatorsDynamic.db.profile.settings.boxId = PlexusIndicatorsDynamic.db.profile.settings.boxId + 1
	local id = "pid_box_" .. PlexusIndicatorsDynamic.db.profile.settings.boxId
	PlexusIndicatorsDynamic.db.profile[id] = {
		anchor = "CENTER", --luacheck: ignore 314
		size = 8,
		offsetX = 0,
		offsetY = 0,
		anchor = "TOPRIGHT",
		frameLevel = 1,
	}
	options.args[id] = GetDefaultBoxOptionMenu()
	PlexusIndicatorsDynamic:Box_RegisterIndicator(id, options.args[id].name)
	PlexusFrame:UpdateOptionsForIndicator(id, options.args[id].name)
	AceConfigDialog:SelectGroup("Plexus", "PlexusIndicatorsDynamic", id)
end

function PlexusIndicatorsDynamic:Reset() --luacheck: ignore 212
	for k, _ in pairs(Plexus.options.args.PlexusIndicator.args) do
		if string.match(k, "pid_") then
			options.args[k] = nil
			PlexusFrame.indicators[k] = nil
			Plexus.options.args.PlexusIndicator.args[k] = nil
		end
	end
	options = {
		name = "Dynamic Indicators",
		order = 1000,
		type = "group",
		set = function(info, value)
			PlexusIndicatorsDynamic.db.profile[info[#info - 1]][info[#info]] = value
			PlexusFrame:UpdateAllFrames()
		end,
		get = function(info)
			return PlexusIndicatorsDynamic.db.profile[info[#info - 1]][info[#info]]
		end,
		args = {
			newText = {
				name = "New Text Indicator",
				order = 1,
				type = "execute",
				func = NewTextIndicator,
			},
			newIcon = {
				name = "New Icon Indicator",
				order = 2,
				type = "execute",
				func = NewIconIndicator,
			},
			newBox = {
				name = "New Box Indicator",
				order = 3,
				type = "execute",
				func = NewBoxIndicator,
			},
		}
	}
	for k, v in pairs(PlexusIndicatorsDynamic.db.profile) do
		if string.match(k, "pid_icon_") then
			v.frameLevel = v.frameLevel or 1 -- remove somewhere in the future
			options.args[k] = GetDefaultIconOptionMenu()
			PlexusIndicatorsDynamic:Icon_RegisterIndicator(k, v.name or options.args[k].name)
		elseif string.match(k, "pid_text_") then
			v.frameLevel = v.frameLevel or 1 -- remove somewhere in the future
			options.args[k] = GetDefaultTextOptionMenu()
			PlexusIndicatorsDynamic:Text_RegisterIndicator(k, v.name or options.args[k].name)
		elseif string.match(k, "pid_box_") then
			v.frameLevel = v.frameLevel or 1 -- remove somewhere in the future
			options.args[k] = GetDefaultBoxOptionMenu()
			PlexusIndicatorsDynamic:Box_RegisterIndicator(k, v.name or options.args[k].name)
		end
		if v.name then
			options.args[k].name = v.name
		end
	end
	Plexus.options.args["PlexusIndicatorsDynamic"] = options
	PlexusFrame:UpdateOptionsMenu()
	AceGUI:NotifyChange("Plexus")
end

function PlexusIndicatorsDynamic:OnInitialize()
    if not self.db then
		self.db = Plexus.db:RegisterNamespace(self.moduleName, { profile = self.defaultDB or { } })
	end
	self:Reset()
end
