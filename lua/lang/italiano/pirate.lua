L = LANG.GetLanguageTableReference("italiano")

L[PIRATE.name] = "Pirata"
L["info_popup_" .. PIRATE.name] = [[Tu sei un Pirata! Cerca qualcuno per cui combattere - guadagna oro e punti.]]
L["body_found_" .. PIRATE.abbr] = "Era un Pirata..."
L["search_role_" .. PIRATE.abbr] = "Questa persona era un Pirata!"
L["target_" .. PIRATE.name] = "Pirata"
L["ttt2_desc_" .. PIRATE.name] = [[Il Pirata è un ruolo neutrale. Non gli interessa tanto chi è buono o cattivo… 
tutto quello che conta è, che ci siano dei soldi. Finché un'altra persona ha il contratto del Capo Pirata, tutti i pirati sono nella sua stessa squadra.]]
L["hilite_win_" .. TEAM_PIRATE] = "I PIRATI HANNO VINTO" -- name of base role of a team -> maybe access with GetTeamRoles(ROLES.SERIALKILLER.team)[1].name
L["win_" .. TEAM_PIRATE] = "Il Pirata ha vinto! ARRRR" -- teamname
L["ev_win_" .. TEAM_PIRATE] = "I Pirati hanno reclamato il loro oro!"

L[PIRATE_CAPTAIN.name] = "Capo Pirata"
L["info_popup_" .. PIRATE_CAPTAIN.name] = [[Tu sei un Capo Pirata! Cerca qualcuno per cui combattere - guadagna oro e punti.]]
L["body_found_" .. PIRATE_CAPTAIN.abbr] = "Era un Capo Pirata..."
L["search_role_" .. PIRATE_CAPTAIN.abbr] = "Questa persona era un Capo Pirata!"
L["target_" .. PIRATE_CAPTAIN.name] = "Capo Pirata"
L["ttt2_desc_" .. PIRATE_CAPTAIN.name] = [[Il Capo Pirata è un ruolo neutrale. Non gli interessa tanto chi è buono o cattivo… 
tutto quello che conta è, che ci siano dei soldi. Finché un'altra persona ha il contratto del Capo Pirata, tutti i pirati sono nella sua stessa squadra.]]
