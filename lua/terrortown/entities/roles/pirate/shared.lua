if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_pir.vmt")
end

roles.InitCustomTeam(ROLE.name, {
		icon = "vgui/ttt/dynamic/roles/icon_pir",
		color = Color(207, 148, 68, 255)
})

local ttt_pir_win_alone = CreateConVar("ttt_pir_win_alone", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
local ttt_pir_see_contractor_team = CreateConVar("ttt_pir_see_contractor_team", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY})

cvars.AddChangeCallback(ttt_pir_win_alone:GetName(), function(name, old, new)
	PIRATE.preventWin = not ttt_pir_win_alone:GetBool()
	PIRATE_CAPTAIN.preventWin = not ttt_pir_win_alone:GetBool()
end, "TTT2PirWinAloneCallback")

function ChooseNewCaptain()
	local pirs = {}
	for _, ply in ipairs(player.GetAll()) do
		if ply:GetSubRole() == ROLE_PIRATE_CAPTAIN and ply:Alive() then
			return
		end
		if ply:GetSubRole() == ROLE_PIRATE then
			table.insert(pirs, ply)
		end
	end

	if #pirs > 0 then
		local newCap = table.Random(pirs)
		newCap:SetRole(ROLE_PIRATE_CAPTAIN, TEAM_PIRATE)
		newCap:SetDefaultCredits()
		SendFullStateUpdate()
	end
end

function ROLE:PreInitialize()
	self.color = Color(207, 148, 68, 255)

	self.abbr = "pir"
	self.score.surviveBonusMultiplier = 0.5
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 2
	self.score.teamKillsMultiplier = -8
	self.score.bodyFoundMuliplier = 0
	self.unknownTeam = true
	self.preventWin = not ttt_pir_win_alone:GetBool()
	self.avoidTeamIcons = false

	self.defaultTeam = TEAM_PIRATE
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.conVarData = {
		pct = 0.17,
		maximum = 1,
		random = 50,
		minPlayers = 7,
		togglable = true,
	}
end

function ROLE:GiveRoleLoadout(ply, isRoleChange)
	ChooseNewCaptain()
end

if SERVER then
	hook.Add("TTTPrepareRound", "TTT2PirPrepRound", function()
		for _, ply in ipairs(player.GetAll()) do
			ply.is_pir_master = nil
			ply.pirate_master = nil
			ply.pir_contract = nil
		end
	end)

	--pirates and master should always see their roles 
	hook.Add("TTT2SpecialRoleSyncing", "TTT2RolePirVis", function(ply, tbl)
		if ply and not ply.is_pir_master and ply:GetBaseRole() ~= ROLE_PIRATE or GetRoundState() == ROUND_POST then return end

		for pir in pairs(tbl) do
			if pir:GetBaseRole() == ROLE_PIRATE or pir.is_pir_master then
				tbl[pir] = {pir:GetSubRole(), pir:GetTeam()}
			end
		end
	end)
end

if CLIENT then
	function ROLE:AddToSettingsMenu(parent)
		local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

		form:MakeCheckBox({
			serverConvar = "ttt_pir_win_alone",
			label = "label_pir_win_alone"
		})

		form:MakeCheckBox({
			serverConvar = "ttt_pir_see_contractor_team",
			label = "label_pir_see_contractor_team"
		})
	end
end
