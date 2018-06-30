AddCSLuaFile()

SWEP.HoldType            = "ar2"

if CLIENT then
   SWEP.PrintName        = "MP5"
   SWEP.Slot             = 2

   SWEP.ViewModelFlip    = false
   SWEP.ViewModelFOV     = 54

   SWEP.Icon             = "vgui/ttt/icon_mac"
   SWEP.IconLetter       = "l"
end

SWEP.Base                = "weapon_tttbase"

SWEP.Kind                = WEAPON_HEAVY

SWEP.Primary.Damage      = 14
SWEP.Primary.Delay       = 0.09
SWEP.Primary.Cone        = 0.02
SWEP.Primary.ClipSize    = 30
SWEP.Primary.ClipMax     = 60
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "smg1"
SWEP.Primary.Recoil      = 1.15
SWEP.Primary.Sound       = Sound( "weapons/mac10/mac10-1.wav" )

SWEP.AutoSpawnable       = true
SWEP.AmmoEnt             = "item_ammo_smg1_ttt"

SWEP.UseHands            = true
SWEP.ViewModel           = "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel          = "models/weapons/w_smg_mp5.mdl"
SWEP.IronSightsPos       = Vector(-5.3, -5, 1.1)
SWEP.IronSightsAng       = Vector(3, 0, 0)

SWEP.DeploySpeed         = 3
