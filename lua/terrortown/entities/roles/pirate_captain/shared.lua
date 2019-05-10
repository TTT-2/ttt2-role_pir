if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_cap.vmt")
end

ROLE.color = Color(136, 81, 50, 255) -- ...
ROLE.dkcolor = Color(136, 81, 50, 255) -- ...
ROLE.bgcolor = Color(136, 81, 50, 255) -- ...
ROLE.abbr = "cap" -- abbreviation
ROLE.defaultTeam = TEAM_PIRATE -- the team name: roles with same team name are working together
ROLE.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
ROLE.surviveBonus = 0 -- bonus multiplier for every survive while another player was killed
ROLE.scoreKillsMultiplier = 2 -- multiplier for kill of player of another team
ROLE.scoreTeamKillsMultiplier = -8 -- multiplier for teamkill
ROLE.unknownTeam = true -- player don't know their teammates
ROLE.preventWin = GetConVar("ttt_pir_win_alone"):GetBool()
ROLE.avoidTeamIcons = false
ROLE.notSelectable = true -- role cant be selected!

ROLE.conVarData = {
	credits = 0, -- the starting credits of a specific role
	shopFallback = SHOP_DISABLED
}

-- now link this subrole with its baserole
hook.Add("TTT2BaseRoleInit", "TTT2ConBRPirWithCap", function()
	PIRATE_CAPTAIN:SetBaseRole(ROLE_PIRATE)
end)

if CLIENT then -- just on client and first init !
	-- if sync of roles has finished
	hook.Add("TTT2FinishedLoading", "PirCapInitT", function()
		-- setup here is not necessary but if you want to access the role data, you need to start here
		-- setup basic translation !
		LANG.AddToLanguage("English", PIRATE_CAPTAIN.name, "Pirate Captain")
		LANG.AddToLanguage("English", "info_popup_" .. PIRATE_CAPTAIN.name, [[You ARRR a Pirate Captain! Search someone to fight for - earn gold and points.]])
		LANG.AddToLanguage("English", "body_found_" .. PIRATE_CAPTAIN.abbr, "This was an Pirate Captain...")
		LANG.AddToLanguage("English", "search_role_" .. PIRATE_CAPTAIN.abbr, "This person was an Pirate Captain!")
		LANG.AddToLanguage("English", "target_" .. PIRATE_CAPTAIN.name, "Pirate Captain")
		LANG.AddToLanguage("English", "ttt2_desc_" .. PIRATE_CAPTAIN.name, [[The Pirate Captain is a neutral role. He doesn’t really care about what’s good and what’s evil… 
		all that matters is, that there’s money involved. As long as another person owns the Pirate Captain’s contract, all pirates are on the same team as them.]])

		---------------------------------

		-- maybe this language as well...
		LANG.AddToLanguage("Deutsch", PIRATE_CAPTAIN.name, "Piraten Kapitän")
		LANG.AddToLanguage("Deutsch", "info_popup_" .. PIRATE_CAPTAIN.name, [[Du bist ein Piraten Kapitän! Tu dich mit jemandem zusammen und kämpfe für Gold und Punkte.]])
		LANG.AddToLanguage("Deutsch", "body_found_" .. PIRATE_CAPTAIN.abbr, "Er war ein Piraten Kapitän...")
		LANG.AddToLanguage("Deutsch", "search_role_" .. PIRATE_CAPTAIN.abbr, "Diese Person war ein Piraten Kapitän!")
		LANG.AddToLanguage("Deutsch", "target_" .. PIRATE_CAPTAIN.name, "Piraten Kapitän")
		LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. PIRATE_CAPTAIN.name, [[ Der Piraten Kapitän ist neutral. Er kümmert sich nicht um gut und böse... das Geld muss stimmen.
		So lange eine andere Person einen Vertrag mit dem Piraten Kapitän geschlossen hat, kämpfen alle Piraten für sein Team.]])
	end)
else

end