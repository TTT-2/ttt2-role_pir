L = LANG.GetLanguageTableReference("english")

L[PIRATE.name] = "Pirate"
L["info_popup_" .. PIRATE.name] = [[You ARRR a Pirate! Search someone to fight for - earn gold and points.]]
L["body_found_" .. PIRATE.abbr] = "This was an Pirate..."
L["search_role_" .. PIRATE.abbr] = "This person was an Pirate!"
L["target_" .. PIRATE.name] = "Pirate"
L["ttt2_desc_" .. PIRATE.name] = [[The Pirate is a neutral role. He doesn’t really care about what’s good and what’s evil… 
all that matters is, that there’s money involved. As long as another person owns the Pirate Captain’s contract, all pirates are on the same team as them.]]
L["hilite_win_" .. TEAM_PIRATE] = "PIRATES WON" -- name of base role of a team -> maybe access with GetTeamRoles(ROLES.SERIALKILLER.team)[1].name
L["win_" .. TEAM_PIRATE] = "The Pirates won! ARRRR" -- teamname
L["ev_win_" .. TEAM_PIRATE] = "The Pirates have claimed their gold!"

L[PIRATE_CAPTAIN.name] = "Pirate Captain"
L["info_popup_" .. PIRATE_CAPTAIN.name] = [[You ARRR a Pirate Captain! Search someone to fight for - earn gold and points.]]
L["body_found_" .. PIRATE_CAPTAIN.abbr] = "This was an Pirate Captain..."
L["search_role_" .. PIRATE_CAPTAIN.abbr] = "This person was an Pirate Captain!"
L["target_" .. PIRATE_CAPTAIN.name] = "Pirate Captain"
L["ttt2_desc_" .. PIRATE_CAPTAIN.name] = [[The Pirate Captain is a neutral role. He doesn’t really care about what’s good and what’s evil… 
all that matters is, that there’s money involved. As long as another person owns the Pirate Captain’s contract, all pirates are on the same team as them.]]
