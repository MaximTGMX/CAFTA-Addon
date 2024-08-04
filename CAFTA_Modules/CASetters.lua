local LightSource = {"TORCH","TORCHSTAND","RICOCHET","RATBOMB","CRABBOMB","PUNKRAT","TORCH2","SEWERLAMP","STREETLAMP","WINDOW1","WINDOW2","WINDOW3","WINDOW4","BEACHTORCH","POSTLANTERNS",
"LANTERN","WINDOWLIGHT","SKULLPOST","SKULLCANDLE","CRYSTALIGHT2","FISH","AQUATISWALLCRACK","TENTICLELAMP","FIRESTONE","DOUBLETORCH","FIREARCH","FIREPIT","GROUNDTORCH","THREETORCH"}
local path = "Assets/GAME/MODULES/CAFTA_Modules/"
local mdl_path = 'Assets.GAME.MODULES.CAFTA_Modules.'

casetters = {}

-------------------------------------------------SETTERS-------------------------------------------------
function casetters:SetDarkmode(bool)
	Darkmode = bool
end
function casetters:SetMaxHealth(health)
	MaxHealth = health
end
function casetters:SetCombatObjectID(id)
	CombatObjectID = id
end
function casetters:SetBossID(id)
	BossID = id
end
function casetters:SetRoom(bool)
	Room = bool
	if not Room then
		caprocess:LoopThroughObjectsInRange("Show Tiles",GetClaw(),{-384,-304,384,304},"All Tiles")
	end
end
function casetters:LightBooster(r)
	lightBooster = lightBooster + r
end
function casetters:SetBlindness(bool)
	Blindness = bool
end
function casetters:SetCanUseScroll(bool)
	CanUseScroll = bool
end
function casetters:SetPtr(p)
	if p then hdc = tonumber(ffi.cast("int",p)) end
end
function casetters:scrollWheelUsed(bool)
	if getNewKey then scrollWheelUsed = bool end
end

function casetters:SetInput(name,code)
local inputs = ffi.cast("int**", 0x535918)[0]
    local Keys = {
		["MOVE LEFT"] = 14,
		["MOVE RIGHT"] = 15,
		["MOVE UP"] = 16,
		["MOVE DOWN"] = 17,
		JUMP = 18,
		["PRIMARY ATTACK"] = 19,
		["SECONDARY ATTACK"] = 20,
		["SWITCH WEAPON"] = 21,
		LIFT = 23,
		PISTOL = 24,
		MAGIC = 25,
		DYNAMITE = 26,
		SPECIAL = 27
    }
	inputs[ Keys[string.upper(name)] ] = code
end

function casetters:SetMultipliers()
	if string.lower(Difficulty)=="easy" then	
		multiplier = 0.5 
	elseif string.lower(Difficulty)=="normal" then 
		multiplier = 1 
	elseif string.lower(Difficulty)=="hard" then 
		multiplier = 2
	elseif string.lower(Difficulty)=="very hard" then 
		multiplier = 3
	elseif string.lower(Difficulty)=="revengeance" then 
		multiplier = 4
	else 
		multiplier = 5 
	end
end

return casetters