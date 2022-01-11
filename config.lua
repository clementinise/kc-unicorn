Config                              = Config or {}

-- Framework
Config.Framework					= 'Standalone'		-- Choose which framework your server is using so kc-unicorn can work with it [ESX, QBCore, Standalone]
-- Since there is too many esx version, only this one is supported (https://github.com/esx-framework/es_extended/tree/v1-final). Maybe I will test other version, but not a priority

-- Lap dance 
Config.LapDanceCost					= 120 		-- Cost of the lap dance
Config.ThrowCost					= 40 		-- Cost of the lap dance
Config.LegMoney                     = 10000     -- Little easter egg for your player, will add an accessory "Leg money" to the stripper if the player has more than 'Config.LegMoney' in cash. Set to a huge value if you don't want this
Config.Nudity                       = false      -- Set to true if you want the stripper to be topless (Only for player above 'Config.NudityAge')
Config.NudityAge                    = 21        -- (QBCore only!!) Player age restriction. If underage and 'Config.Nudity' is set to true, the stripper won't be topless. Set to 0 if you don't want age restriction

-- Text/Blip/Marker
Config.Text 						= 'Better3D'   -- 2D, 3D, Better3D, None (Set the one you like to suit your server, the performance difference is mostly non-existant)
Config.Blip                         = true         -- Set to false if you don't want the blip on the map
Config.BlipName                     = "Strip-Club" -- Blip name
Config.BlipStripclub = {
	Sprite = 121,  -- Sprite list can be found here: https://docs.fivem.net/docs/game-references/blips/
	Colour = 50,   -- Color list in the same URL as above
	Display = 27,   -- Explanation here: https://docs.fivem.net/natives/?_0x9029B2F3DA924928
	Scale = 0.7    -- Self explanatory, let you set the scale of the blip
}
Config.BlipCoord					= { x=128.87, y=-1298.93, z=4.0 } -- If you want to move the blip on the map, change this.
Config.LapMarker					= true		-- Set to true if you want the marker for the lapdance to be "drawn"

-- Strippers
Config.SelectStrippers				= true		-- Set to true if you want to let your player choose which stripper they want for their lapdance
Config.Strippers = {
	[1] = {
		Name = "Eisha",
		Model = 1846523796,
		Drawables = { Head = 0, Hair = 0, Torso = 0, Torso2 = 0, Shoes = 1, Underwear = 0 },
		Textures = { HairTex = 0, BraTex = 2, ShoesTex = 2, UnderwearTex = 0 }
	},
	[2] = {
		Name = "Jade",
		Model = 1846523796,
		Drawables = { Head = 0, Hair = 2, Torso = 0, Torso2 = 1, Shoes = 1, Underwear = 0 },
		Textures = { HairTex = 0, BraTex = 5, ShoesTex = 1, UnderwearTex = 0 }
	}
}

-- Locale
Config.Language						= 'en'		-- Currently Available: fr, en
-- Locales can be easily created or modified in `kc-unicorn/locales`

-- Misc
Config.Debug        				= false   	-- If you think something is not working, you can set 'Config.Debug' to true. It will then print a lot of debug information in your console
Config.DebugPolyzones				= false		-- Set to true if you want to display the Polyzones
Config.MoreDebug					= false		-- If set to true, this will print more debug about server and client lapdance seat status
Config.MoreDebugRefreshTime			= 5		-- Refresh time of "Config.MoreDebug" in seconds
Config.UpdateChecker                = true      -- Set to false if you don't want to check for resource update on start
Config.ChangeLog					= true		-- Set to false if you don't want to display the changelog if new version is find



----- DO NOT TOUCH! /!\ LOCALE SYSTEM /!\
Language = {}

function Loc(text,replacement)
    Language = (load)("return Locale." .. Config.Language)()

    if (load)("return Locale." .. Config.Language)() == nil then
        return 'Locale [' .. Config.Language .. '] (Does not exist/Is mispelled)'
    end
    if (load)("return ".."Language."..text)() == nil then
        return 'Error with [' .. Config.Language .. '.' .. text .. '] translation (Does not exist/Is mispelled)'
    end

	if replacement then
		text = (string.gsub((load)("return ".."Language."..text)(), "%%", replacement))
	else
		text = (load)("return ".."Language."..text)()
	end
	return text
end
-----------------------------------------