SWEP.Base = "weapon_tttbase"

SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.AdminSpawnable = true

SWEP.HoldType = "pistol"

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("TTT2PirContractMaster")
	util.AddNetworkString("TTT2PirContractTerminatedMaster")
	util.AddNetworkString("TTT2PirContractPirate")
	util.AddNetworkString("TTT2PirContractTerminatedPirate")
else
	SWEP.PrintName = "Pirate Contract"
	SWEP.Author = "LeBroomer"

	SWEP.Slot = 7

	SWEP.ViewModelFOV = 40
	SWEP.ViewModelFlip = false
end

-- some other stuff
SWEP.InLoadoutFor = {ROLE_PIRATE_CAPTAIN}
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.UseHands = true
SWEP.Kind = WEAPON_EXTRA
SWEP.CanBuy = {}
SWEP.LimitedStock = true
SWEP.globalLimited = true
SWEP.NoRandom = true

-- view / world
SWEP.ViewModel = "models/weapons/ttt2_pirate_contract/v_contract.mdl"
SWEP.WorldModel = "models/weapons/ttt2_pirate_contract/contract.mdl"
SWEP.Weight = 5

SWEP.notBuyable = true

function SWEP:Initialize()
	if CLIENT then
		self:AddTTT2HUDHelp("Drop the contract for someone")
	end
end

function SWEP:MakeContract()
	local pirate = self.OrigOwner
	local master = self.Owner

	if not IsValid(pirate) or not IsValid(master) then
		return
	end

	master.is_pir_master = true

	--change the team of the pirate captain and his crew
	pirate:UpdateTeam(master:GetTeam())
	pirate.pirate_master = master

	for _, ply in ipairs(player.GetAll()) do
		if ply:GetSubRole() == ROLE_PIRATE then
			ply:UpdateTeam(master:GetTeam())
		end
	end

	if GetConVar("ttt_pir_see_contractor_team"):GetBool() then
		--update pirates team visibility according to his new mates
		local visibility = roles.GetByIndex(master:GetSubRole()).unknownTeam
		PIRATE.unknownTeam = visibility
		PIRATE_CAPTAIN.unknownTeam = visibility
	else
		PIRATE_CAPTAIN.unknownTeam = true
		PIRATE.unknownTeam = true
	end

	local preventWinState = roles.GetByIndex(master:GetSubRole()).preventWin
	PIRATE.preventWin = preventWinState
	PIRATE_CAPTAIN.preventWin = preventWinState

	SendFullStateUpdate()

	--send a message to the new contract owner
	net.Start("TTT2PirContractMaster")
	net.WriteEntity(pirate)
	net.Send(master)

	--send a message to the pirate about the successful contract
	net.Start("TTT2PirContractPirate")
	net.WriteEntity(master)
	net.Send(pirate)

	--status symbol
	STATUS:AddStatus(master, "ttt2_pirate_contract")

	for _, ply in ipairs(player.GetAll()) do
		if ply:GetSubRole() == ROLE_PIRATE then
			net.Start("TTT2PirContractPirate")
			net.WriteEntity(master)
			net.Send(ply)
		end
	end
end

function SWEP:PrimaryAttack()
	if SERVER and self.AllowDrop then
		self.Owner:DropWeapon(self)
	end
end

function SWEP:SecondaryAttack()
	if SERVER and self.AllowDrop then
		self.Owner:DropWeapon(self)
	end
end

function SWEP:OnDrop()
	timer.Create("TTT2PirContractTimer" .. self:EntIndex(), 20, 1, function()
		if IsValid(self) and not IsValid(self:GetOwner()) then
			self:Remove()
			self.OrigOwner:Give("weapon_ttt2_contract")
		end
	end)

	self.AllowDrop = false
	if self.OrigOwner == self.Owner then
		return true
	else
		return false
	end
end

function SWEP:Equip()
	if timer.Exists("TTT2PirContractTimer" .. self:EntIndex()) then timer.Remove("TTT2PirContractTimer" .. self:EntIndex()) end

	--first owner equip
	if not IsValid(self.OrigOwner) then
		self.OrigOwner = self.Owner
		self.OrigOwner.pir_contract = self
		return
	end

	--another player equipped
	if self.OrigOwner ~= self.Owner then
		self:MakeContract()
		self.AllowDrop = false
	else
		self.AllowDrop = true
	end
end


--hooks and messages
if CLIENT then
	hook.Add("Initialize", "ttt_pirate_contract init", function()
		STATUS:RegisterStatus("ttt2_pirate_contract", {
			hud = Material("vgui/ttt/hud_icon_pirate.png"),
			type = "good"
		})
	end)

	net.Receive("TTT2PirContractMaster", function()
		local pirate = net.ReadEntity()

		chat.AddText(Color(255, 0, 0), "TTT2 Pirate: ", Color(255, 255, 255), "The pirate captain ", pirate:GetRoleColor(), pirate:GetName(), Color(255, 255, 255), " and his crew is now fighting for you.")
		chat.PlaySound()
	end)

	net.Receive("TTT2PirContractTerminatedMaster", function()
		local pirate = net.ReadEntity()

		STATUS:RemoveStatus("ttt2_pirate_contract")

		chat.AddText(Color(255, 0, 0), "TTT2 Pirate: ", Color(255, 255, 255), "Your contract with ", pirate:GetRoleColor(), pirate:GetName(), Color(255, 255, 255), " was terminated with his death.")
		chat.PlaySound()
	end)

	net.Receive("TTT2PirContractPirate", function()
		local master = net.ReadEntity()
		local masterTeamData = TEAMS[master:GetTeam()]

		if GetConVar("ttt_pir_see_contractor_team"):GetBool() and masterTeamData then
			chat.AddText(Color(255, 0, 0), "TTT2 Pirate: ", Color(255, 255, 255), "Your new master is " .. master:GetName() .. " and you are fighting for Team ", masterTeamData.color , string.upper(master:GetTeam()))
		else
			chat.AddText(Color(255, 0, 0), "TTT2 Pirate: ", Color(255, 255, 255), "Your new master is ", master:GetName(), Color(255, 255, 255))
		end

		chat.PlaySound()
	end)

	net.Receive("TTT2PirContractTerminatedPirate", function()
		local master = net.ReadEntity()

		if GetConVar("ttt_pir_see_contractor_team"):GetBool() then
			chat.AddText(Color(255, 0, 0),"TTT2 Pirate: ",Color(255, 255, 255),"Your contract with " .. master:GetName() .. " was terminated with his death.")
		else
			chat.AddText(Color(255, 0, 0),"TTT2 Pirate: ",Color(255, 255, 255),"Your contract with ", master:GetName(), Color(255, 255, 255)," was terminated with his death.")
		end

		PIRATE.preventWin = not GetConVar("ttt_pir_win_alone"):GetBool()
		PIRATE_CAPTAIN.preventWin = not GetConVar("ttt_pir_win_alone"):GetBool()

		PIRATE.unknownTeam = false
		PIRATE_CAPTAIN.unknownTeam = false

		chat.PlaySound()
	end)
else
	hook.Add( "PlayerCanPickupWeapon", "TTT2PirNoContractPickup", function( ply, wep )
		if wep:GetClass() == "weapon_ttt2_contract" and ply:GetBaseRole() == ROLE_PIRATE and IsValid(wep.OrigOwner) and wep.OrigOwner ~= ply then
			return false
		end
	end )

	hook.Add( "PostPlayerDeath", "TTT2PirHandleMastersDeath", function(master)
		if not master.is_pir_master then return end

		for _, ply in ipairs(player.GetAll()) do
			if ply:GetBaseRole() == ROLE_PIRATE then
				net.Start("TTT2PirContractTerminatedPirate")
				net.WriteEntity(master)
				net.Send(ply)
				ply:UpdateTeam(TEAM_PIRATE)
			end
		end

		PIRATE.preventWin = not GetConVar("ttt_pir_win_alone"):GetBool()
		PIRATE_CAPTAIN.preventWin = not GetConVar("ttt_pir_win_alone"):GetBool()
		PIRATE.unknownTeam = false
		PIRATE_CAPTAIN.unknownTeam = false

		SendFullStateUpdate()

		master.is_pir_master = false
	end)

	hook.Add("TTT2UpdateTeam", "TTT2ChangeTeamWithMaster", function(master, oldTeam, team)
		if master.is_pir_master then
			for _, ply in ipairs(player.GetAll()) do
				if ply:GetBaseRole() == ROLE_PIRATE then
					ply:UpdateTeam(team)
				end
			end
			SendFullStateUpdate()
		end
	end)
end
