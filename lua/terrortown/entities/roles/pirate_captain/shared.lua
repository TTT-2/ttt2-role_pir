if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_cap.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(136, 81, 50, 255) -- ...
	self.dkcolor = Color(136, 81, 50, 255) -- ...
	self.bgcolor = Color(136, 81, 50, 255) -- ...
	self.abbr = "cap" -- abbreviation
	self.defaultTeam = TEAM_PIRATE -- the team name: roles with same team name are working together
	self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
	self.surviveBonus = 0 -- bonus multiplier for every survive while another player was killed
	self.scoreKillsMultiplier = 2 -- multiplier for kill of player of another team
	self.scoreTeamKillsMultiplier = -8 -- multiplier for teamkill
	self.unknownTeam = true -- player don't know their teammates
	self.preventWin = not GetConVar("ttt_pir_win_alone"):GetBool()
	self.avoidTeamIcons = false
	self.notSelectable = true -- role cant be selected!

	self.conVarData = {
		credits = 0, -- the starting credits of a specific role
		shopFallback = SHOP_DISABLED
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_PIRATE)
	
	if CLIENT then
		-- Role specific language elements
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
	end
end