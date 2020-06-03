if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_cap.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(136, 81, 50, 255)

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
end

function ROLE:GiveRoleLoadout(ply, isRoleChange)
	if not isRoleChange then
		ply:SetRole(ROLE_PIRATE, TEAM_PIRATE)
		SendFullStateUpdate()
	end
end

function ROLE:RemoveRoleLoadout(ply, isRoleChange)
	if not IsValid(ply.pir_contract) then
		return
	end

	local contract = ply.pir_contract
	local master = contract:GetOwner()
	if IsValid(master) then
		net.Start("TTT2PirContractTerminatedMaster")
		net.WriteEntity(ply)
		net.Send(master)
		master.is_pir_master = false
		ply.pirate_master = nil
	end
	contract:Remove()

	for _, pir in ipairs(player.GetAll()) do
		if pir:GetBaseRole() == ROLE_PIRATE then
			pir:UpdateTeam(TEAM_PIRATE)
		end
	end

	PIRATE.preventWin = not GetConVar("ttt_pir_win_alone"):GetBool()
	PIRATE_CAPTAIN.preventWin = not GetConVar("ttt_pir_win_alone"):GetBool()
	PIRATE.unknownTeam = false
	PIRATE_CAPTAIN.unknownTeam = false

	SendFullStateUpdate()

	ChooseNewCaptain()
end
