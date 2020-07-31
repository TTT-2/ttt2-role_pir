L = LANG.GetLanguageTableReference("spanish")

L[PIRATE.name] = "Pirata"
L["info_popup_" .. PIRATE.name] = [[¡Eres un Pirata! Lucha con tu equipo y sigue las órdenes del capitán.]]
L["body_found_" .. PIRATE.abbr] = "Era un Pirata..."
L["search_role_" .. PIRATE.abbr] = "Esta persona era un Pirata."
L["target_" .. PIRATE.name] = "Pirata"
L["ttt2_desc_" .. PIRATE.name] = [[El Pirata es un rol neutral. Realmente no le importa el bien o el mal… 
todo lo que importa es que hay dinero en juego. Siempre y cuando alguien tenga el Contrato del Pirata Capitán, todos los piratas están en su equipo.]]
L["hilite_win_" .. TEAM_PIRATE] = "LOS PIRATAS GANAN" -- name of base role of a team -> maybe access with GetTeamRoles(ROLES.SERIALKILLER.team)[1].name
L["win_" .. TEAM_PIRATE] = "¡Los Piratas han ganado! ARRRR" -- teamname
L["ev_win_" .. TEAM_PIRATE] = "¡Los Piratas han reclamado su oro!"

L[PIRATE_CAPTAIN.name] = "Pirata Capitán"
L["info_popup_" .. PIRATE_CAPTAIN.name] = [[¡Eres el Pirata Capitán! Encuentra a alguien por el cual valga la pena pelear - gana mucho oro en el proceso.]]
L["body_found_" .. PIRATE_CAPTAIN.abbr] = "Era un Pirata Capitán..."
L["search_role_" .. PIRATE_CAPTAIN.abbr] = "Esta persona era un Pirata Capitán."
L["target_" .. PIRATE_CAPTAIN.name] = "Pirata Capitán"
L["ttt2_desc_" .. PIRATE_CAPTAIN.name] = [[El Pirata es un rol neutral. Realmente no le importa el bien o el mal… 
todo lo que importa es que hay dinero en juego. Siempre y cuando alguien tenga el Contrato del Pirata Capitán, todos los piratas están en su equipo.]]
