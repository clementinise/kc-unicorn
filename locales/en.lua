Locale                          = Locale or {}

Locale.en = { -- 'fr' is the reference that will be used for 'Config.Language'
	StandaloneLapText			= "Ask for a lap dance", -- Set the text that will be displayed above marker if 'Config.Framework' is set to 'standalone'
	LapText						= "Buy a lap dance (~g~%$~w~)", -- Set the text that will be displayed above marker
	BoughtLapdance				= "You just bought a lap dance for %$", -- Notification text when a lap dance is bought
	StripperActive				= "The stripper is already busy!", -- Notification text if a stripper is already active when you try to buy a lap dance
	NotEnoughMoney				= "You do not have enough money. A lap dance costs %$", -- Notification text if player don't have enough cash
	AllPlacesTaken				= "All places are already taken", -- Notification text if all places are already taken
	lapStopped					= "Your lap dance has been interrupted", -- Notification text if lapdance is interrupted
	Lean						= "Lean", -- Text displayed when near poledance 
	StandaloneLeanNotice		= "Press ~INPUT_CONTEXT~ to stop leaning\nPress ~INPUT_JUMP~ to throw money", -- Set the text that will be displayed once lean if 'Config.Framework' is set to 'standalone'
	LeanNotice					= "Press ~INPUT_CONTEXT~ to stop leaning\nPress ~INPUT_JUMP~ to throw money (~g~%$~w~)", -- Set the text that will be displayed once lean
	NotEnoughCashLean			= "Not enough cash to throw" -- Text if player doesn't have enough money to throw once lean
}