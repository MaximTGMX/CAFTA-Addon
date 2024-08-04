local LightSource = {"TORCH","TORCHSTAND","RICOCHET","RATBOMB","CRABBOMB","PUNKRAT","TORCH2","SEWERLAMP","STREETLAMP","WINDOW1","WINDOW2","WINDOW3","WINDOW4","BEACHTORCH","POSTLANTERNS",
"LANTERN","WINDOWLIGHT","SKULLPOST","SKULLCANDLE","CRYSTALIGHT2","FISH","AQUATISWALLCRACK","TENTICLELAMP","FIRESTONE","DOUBLETORCH","FIREARCH","FIREPIT","GROUNDTORCH","THREETORCH"}
local path = "Assets/GAME/MODULES/CAFTA_Modules/"
local mdl_path = 'Assets.GAME.MODULES.CAFTA_Modules.'
ca = {}

local caload       = require (mdl_path .. 'CALoad')
local cagetters    = require (mdl_path .. 'CAGetters')
local casetters    = require (mdl_path .. 'CASetters')
local cavalidators = require (mdl_path .. 'CAValidators')
local caoperations = require (mdl_path .. 'CAOperations')
local camenu       = require (mdl_path .. 'CAMenu')
local caprocess    = require (mdl_path .. 'CAProcess')

-------------------------------------------------LOAD-------------------------------------------------
function ca:LoadVariables()
	if not Reset then
		Reset = true
		ca:ResetValues()
		caload:Init()
		Resolution = "4/3"
		ResTime = true
		ResChange = false
		Width = 0
	end
end

function ca:LoadFunctions(ptr)
	if not ResChange then
		ResChange = true
		file = io.open(path.."CAFTAConfig.cfg", "r")
		if file then
			local lines = {}
			local crt = 0
			for line in file:lines() do
				table.insert(lines, line)
				crt = crt+1
			end
			for i=1,crt do						
				if string.find(lines[i],"Resolution:") then
					local arg = ""
					for s in lines[i]:gmatch"%b:;" do 
						arg = arg..s
					end
					arg = arg:gsub(':','')
					arg = arg:gsub(';','')	
					if arg=="4/3" then Resolution = "4/3"
					elseif arg=="16/9" then Resolution = "16/9"
					else Resolution = "unforced" end
					ResTime = true
				end				
			end
			io.close(file)
		end
	end
	
	local PLAY_AREA = ffi.cast("Rect*", 0x535840)[0]
	caprocess:HideLives()
	casetters:SetPtr(ptr)
	camenu:CustomOptions()
	caprocess:TextOnScreen()
	caprocess:CreateDarkness()
	caprocess:CreateBattleArea()
	caprocess:CreateBossBar()
	caprocess:LoopThroughObjectsInRange("Set Difficulty",GetClaw(),{-1*PLAY_AREA.Right,-1*PLAY_AREA.Bottom,PLAY_AREA.Right,PLAY_AREA.Bottom},"Camera Range")
end


function ApplyMultipliersToLoadedEnemies(self)
	if self.ObjectTypeFlags == 4 and self.User[4]==0 then
		self.Health = self.Health*multiplier
		self.Damage = self.Damage*multiplier
		self.User[4] = self.Health
	end
end


-------------------------------------------------RESET-------------------------------------------------

function ca:ResetValues()
	InCombat,Darkmode,Room,CanUseScroll,MenuOpened,options,getNewKey,isOnEasyMode = false,false,false,false,false,false,false,false
	BossID,Color,Show,ptr,hdc,selectedSlider,startHealth = nil,0xffffff,nil,nil,nil,nil,nil
	Difficulty,Lighting = "normal","fancy"
	multiplier,MaxHealth,lightBooster,CombatObjectID,controlsPage = 1,100,0,0,1
	BlacklistedEnemies = {}
	
	if HealthBar~=nil then
		HealthBar = nil
		Back = nil
		Number = nil
	end
	
	if STR~=nil then
		for v,w in pairs(STR) do
			STR[v] = nil
			RECT[v] = nil
			ALIGN[v] = nil
			COLOR[v] = nil
			FONT_INDEX[v] = nil
		end
	end
	caoperations:DestroyTools()
	tools = nil
	caoperations:DestroyFonts()
	fonts = nil
end

return ca
