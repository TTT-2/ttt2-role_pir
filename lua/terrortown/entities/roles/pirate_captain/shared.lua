if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_cap.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(136, 81, 50, 255)

	self.abbr = "cap"
	self.score.surviveBonusMultiplier = 0.5
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 2
	self.score.teamKillsMultiplier = -8
	self.score.bodyFoundMuliplier = 0
	self.unknownTeam = true
	self.preventWin = not GetConVar("ttt_pir_win_alone"):GetBool()
	self.avoidTeamIcons = false
	self.notSelectable = true

	self.defaultTeam = TEAM_PIRATE
	self.defaultEquipment = SPECIAL_EQUIPMENT

	self.conVarData = {
		credits = 0,
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
