Locale                          = Locale or {}

Locale.fr = { -- 'fr' est la référence qui sera utilisé par 'Config.Language'
	StandaloneLapText			= "Demander un lap dance", -- Définit le texte qui sera affiché au-dessus du marqueur si 'Config.Framework' est mis sur 'standalone'
	LapText						= "Acheter un lap dance (~g~%$~w~)", -- Définit le texte qui sera affiché au-dessus du marqueur
	BoughtLapdance				= "Vous avez acheté un lap dance pour %$", -- Texte de la notification lorsqu'un lap dance est acheté
	StripperActive				= "La strip-teaseuse est déjà occupé !", -- Texte de la notification si une strip-teaseuse est déjà occupé lorsque vous essayez d'acheter un lap dance
	NotEnoughMoney				= "Vous n'avez pas assez d'argent. Un lap dance coûte %$", -- Texte de la notification si le joueur n'a pas assez d'argent
	AllPlacesTaken				= "Toutes les places sont déjà prises", -- Texte de la notification si toutes les places sont déjà prises
	lapStopped					= "Ta lap dance a été interrompu !", -- Texte si la lap dance est interrompu
	Lean						= "Se pencher", -- Texte pour se pencher au niveau de la bar de poledance
	StandaloneLeanNotice		= "Appuyez sur ~INPUT_CONTEXT~ pour arrêter de vous pencher\nAppuyez sur ~INPUT_JUMP~ pour jeter de l'argent", -- Définit le texte qui sera affiché une fois penché si 'Config.Framework' est mis sur 'standalone'
	LeanNotice					= "Appuyez sur ~INPUT_CONTEXT~ pour arrêter de vous pencher\nAppuyez sur ~INPUT_JUMP~ pour jeter de l'argent (~g~%$~w~)", -- Définit le texte qui sera affiché une fois penché
	NotEnoughCashLean			= "Vous n'avez pas assez d'argent" -- Texte si le joueur n'a pas assez d'argent pour jeter un billet une fois penché
}