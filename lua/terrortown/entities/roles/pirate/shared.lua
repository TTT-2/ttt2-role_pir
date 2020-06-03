if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_pir.vmt")
end

-- creates global var "TEAM_PIRATE" and other required things
-- TEAM_[name], data: e.g. icon, color,...
roles.InitCustomTeam(ROLE.name, { -- this creates var "TEAM_PIRATE"
		icon = "vgui/ttt/dynamic/roles/icon_pir",
		color = Color(207, 148, 68, 255)
})

local ttt_pir_win_alone = CreateConVar("ttt_pir_win_alone", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
local ttt_pir_see_contractor_team = CreateConVar("ttt_pir_see_contractor_team", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY})

hook.Add("TTTUlxDynamicRCVars", "TTTUlxDynamicPirCVars", function(tbl)
	tbl[ROLE_PIRATE] = tbl[ROLE_PIRATE] or {}

	table.insert(tbl[ROLE_PIRATE], {cvar = "ttt_pir_win_alone", checkbox = true, desc = "Pirates can win as team if they have no live contract (Def. 0)"})
	--table.insert(tbl[ROLE_PIRATE], {cvar = "ttt_pir_see_contractor_team", checkbox = true, desc = "Pirates can see the team of the contractor (Def. 1)"})
end)

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

	self.abbr = "pir" -- abbreviation
	self.defaultTeam = TEAM_PIRATE -- the team name: roles with same team name are working together
	self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
	self.surviveBonus = 0 -- bonus multiplier for every survive while another player was killed
	self.scoreKillsMultiplier = 2 -- multiplier for kill of player of another team
	self.scoreTeamKillsMultiplier = -8 -- multiplier for teamkill
	self.unknownTeam = true -- player don't know their teammates
	self.preventWin = not ttt_pir_win_alone:GetBool()
	self.avoidTeamIcons = false

	self.conVarData = {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		random = 50,
		minPlayers = 7, -- minimum amount of players until this role is able to get selected
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
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
