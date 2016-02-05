surface.CreateFont( "tickhud", {
 font = "Bebas Neue",
 size = 24,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "tickhudsmall", {
 font = "Bebas Neue",
 size = 16,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "jobname", {
 font = "Bebas Neue",
 size = 20,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "moneysmall", {
 font = "Bebas Neue",
 size = 20,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

surface.CreateFont( "moneylarge", {
 font = "Bebas Neue",
 size = 25,
 weight = 500,
 blursize = 0,
 scanlines = 0,
 antialias = true
} )

local hideHUDElements = {
	-- if you DarkRP_HUD this to true, ALL of DarkRP's HUD will be disabled. That is the health bar and stuff,
	-- but also the agenda, the voice chat icons, lockdown text, player arrested text and the names above players' heads
	["DarkRP_HUD"] = false,

	-- DarkRP_EntityDisplay is the text that is drawn above a player when you look at them.
	-- This also draws the information on doors and vehicles
	["DarkRP_EntityDisplay"] = false,

	-- DarkRP_ZombieInfo draws information about zombies for admins who use /showzombie.
	["DarkRP_ZombieInfo"] = false,

	-- This is the one you're most likely to replace first
	-- DarkRP_LocalPlayerHUD is the default HUD you see on the bottom left of the screen
	-- It shows your health, job, salary and wallet, but NOT hunger (if you have hungermod enabled)
	["DarkRP_LocalPlayerHUD"] = true,

	-- If you have hungermod enabled, you will see a hunger bar in the DarkRP_LocalPlayerHUD
	-- This does not get disabled with DarkRP_LocalPlayerHUD so you will need to disable DarkRP_Hungermod too
	["DarkRP_Hungermod"] = false,

	-- Drawing the DarkRP agenda
	["DarkRP_Agenda"] = false,

	-- Lockdown info on the HUD
	["DarkRP_LockdownHUD"] = false,

	-- Arrested HUD
	["DarkRP_ArrestedHUD"] = false,
}

-- this is the code that actually disables the drawing.
hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
	if hideHUDElements[name] then return false end
end)


function CreatePlayerFrame()


if not ValidPanel(HUDBackPanel) then
	HUDBackPanel = vgui.Create( "DPanel" )
	HUDBackPanel:SetPos( 30, ScrH() - 125 )
	HUDBackPanel:SetSize( 90, 90 )
	HUDBackPanel:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
end

if not ValidPanel(mdl) then
	mdl = vgui.Create( "DModelPanel", HUDBackPanel )
	mdl:SetSize( HUDBackPanel:GetSize() )
	mdl:SetModel( "models/player/gman_high.mdl" )
end

function mdl:LayoutEntity( ent )
	ent:SetSequence( ent:LookupSequence( "menu_gman" ) )
	mdl:RunAnimation()
	return
end
	eyepos = mdl.Entity:GetBonePosition( mdl.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
	eyepos:Add( Vector( 0, 0, 2 ) )	-- Move up slightly
	mdl:SetLookAt( eyepos )
	mdl:SetCamPos( eyepos-Vector( -15, 0, 0 ) )	-- Move cam in front of eyes
	mdl.Entity:SetEyeTarget( eyepos-Vector( -13, 0, 0 ) )
end

function Respawner()
	if mdl.Model != LocalPlayer():GetModel() then
		mdl:SetModel(LocalPlayer():GetModel())
	end	
end

local function formatNumber(number)
	if not number then return "" end
	if number >= 1e14 then return tostring(number) end
    number = tostring(number)
    local sep = sep or ","
    local dp = string.find(number, "%.") or #number+1
	for i=dp-4, 1, -3 do
		number = number:sub(1, i) .. sep .. number:sub(i+1)
    end
    return number
end

local function DrawPlayerAvatar( p )
	
	if not ValidPanel(av) then
		av = vgui.Create("AvatarImage")
		av:SetPos(35,ScrH() - 115)
		av:SetSize(80, 80)
		av:SetPlayer( p, 90 )
	end
end

local Health = 0
local function hudPaint()

local x, y = 30, ScrH() - 20

	DrawPlayerAvatar( LocalPlayer() )
	draw.RoundedBox(5, 25, ScrH() - 127, 352, 102, Color(23, 23, 23, 255))
	draw.RoundedBox(5, 30, ScrH() - 120, 90, 90, Color(255, 0, 0, 255))
	draw.RoundedBox(0, 35, ScrH() - 115, 80, 80, Color(43, 43, 43, 255))
	
	draw.RoundedBox(5, 125, ScrH() - 125, 150, 45, Color(36, 36, 36, 255))
	draw.RoundedBox(5, 125, ScrH() - 77, 210, 50, Color(36, 36, 36, 255))
	draw.RoundedBox(5, 278, ScrH() - 125, 97, 45, Color(36, 36, 36, 255))
	//draw.RoundedBox(0, 25, ScrH() - 175, 163, 50, Color(36, 36, 36, 255))
	
	
	
	surface.SetFont( "tickhud" )
	local plyName = LocalPlayer():Name()
	local w, h = surface.GetTextSize(plyName)
	if w > 150 then
		font = "tickhudsmall"
	else
		font = "tickhud"
	end
	
	draw.SimpleText( plyName, font, 130, ScrH() - 120, Color( 255, 255, 255 ) )
	
	local plyCurrentJob = team.GetName(LocalPlayer():Team())
	draw.SimpleText( plyCurrentJob, "jobname", 130, ScrH() - 100, Color( 255, 255, 255 ) )
	
	surface.SetFont( "moneylarge" )
	local plyWalletMoney = formatNumber(LocalPlayer():getDarkRPVar( "money" ))
	local mw, mh = surface.GetTextSize(plyWalletMoney)
	if w > 90 then
		moneyfont = "moneysmall"
	else
		moneyfont = "moneylarge"
	end
	
	if LocalPlayer():isWanted() then
		draw.SimpleText("★", "tickhud", 357, ScrH() - 80, Color( math.sin( CurTime() * 10 ) * 255, 0, 0 ), TEXT_ALIGN_CENTER)
	else
		draw.SimpleText("★", "tickhud", 357, ScrH() - 80, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER)
	end

	draw.SimpleText( "$"..plyWalletMoney, moneyfont, 325, ScrH() - 125, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	draw.SimpleText( "Salary: $"..formatNumber(LocalPlayer():getDarkRPVar( "salary" )), "moneylarge", 325, ScrH() - 105, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	
	local localplayer = LocalPlayer()
	Health = math.min(100, (Health == localplayer:Health() and Health) or Lerp(0.1, Health, localplayer:Health())) 

	local DrawHealth = math.Min(Health / GAMEMODE.Config.startinghealth, 1)
	if DrawHealth <= 0 then
		DrawHealth = 0
	end
	local Border = math.Min(6, math.pow(2, math.Round(3*DrawHealth)))
	//draw.RoundedBox(10, 130, ScrH() - 74, 200 - 10, 18, Color(66,66,66,200))
	//draw.RoundedBox(10, 130, ScrH() - 74, (200 - 9) * DrawHealth, 18, Color(255,0,0,255))
	draw.RoundedBox(Border, x + 100, y - 54, 200 - 8, 20, Color(0,0,0,200))
	draw.RoundedBox(Border, x + 100, y - 54, (200 - 9) * DrawHealth, 18, Color(255,0,0,180))
	
	draw.RoundedBox(Border, 130, ScrH() - 49, 200 - 9, 17, Color(0,0,0,200))
	
	local armor = LocalPlayer():Armor()
	if armor ~= 0 then
		draw.RoundedBox(Border, 130, ScrH() - 50, (200 - 9) * armor / 100, 18, Color(47,5,255,255))
	end
	
	draw.DrawText(math.Max(0, math.Round(localplayer:Armor())), "tickhud", 130 + 4 + (200 - 15)/2, ScrH() - 52, Color(255,255,255,200), 1)
	draw.DrawText(math.Max(0, math.Round(localplayer:Health())), "tickhud", 130 + 4 + (200 - 15)/2, ScrH() - 77, Color(255,255,255,200), 1)
	
	local gunLicense = Material("icon16/page_white_text.png")
    if LocalPlayer():getDarkRPVar("HasGunlicense") then
        surface.SetMaterial(gunLicense)
        surface.SetDrawColor(255, 255, 255, 255)
        surface.DrawTexturedRect(342, ScrH() - 57, 25, 25)
	else
		surface.SetMaterial(gunLicense)
        surface.SetDrawColor(255, 255, 255, 10)
        surface.DrawTexturedRect(342, ScrH() - 57, 25, 25)
    end
	
end
hook.Add("HUDPaint", "DarkRP_Mod_HUDPaint", hudPaint)