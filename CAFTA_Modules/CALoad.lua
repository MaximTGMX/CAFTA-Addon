local LightSource = {"TORCH","TORCHSTAND","RICOCHET","RATBOMB","CRABBOMB","PUNKRAT","TORCH2","SEWERLAMP","STREETLAMP","WINDOW1","WINDOW2","WINDOW3","WINDOW4","BEACHTORCH","POSTLANTERNS",
"LANTERN","WINDOWLIGHT","SKULLPOST","SKULLCANDLE","CRYSTALIGHT2","FISH","AQUATISWALLCRACK","TENTICLELAMP","FIRESTONE","DOUBLETORCH","FIREARCH","FIREPIT","GROUNDTORCH","THREETORCH"}
local path = "Assets/GAME/MODULES/CAFTA_Modules/"
local mdl_path = 'Assets.GAME.MODULES.CAFTA_Modules.'

caload = {}

-------------------------------------------------INIT-------------------------------------------------
function caload:Init()
LoopThroughObjects(find_multistats)
Rate,Spawn = GetTicks(),GetTicks()
keybinds = {
	["Move Left"] = {"Move Left",cagetters:GetInput("Move Left")},
	["Move Right"] = {"Move Right",cagetters:GetInput("Move Right")},
	["Move Up"] = {"Move Up",cagetters:GetInput("Move Up")},
	["Move Down"] = {"Move Down",cagetters:GetInput("Move Down")},
	Jump = {"Jump",cagetters:GetInput("Jump")},
	["Primary Attack"] = {"Primary Attack",cagetters:GetInput("Primary Attack")},
	["Secondary Attack"] = {"Secondary Attack",cagetters:GetInput("Secondary Attack")},
	["Switch Weapon"] = {"Switch Weapon",cagetters:GetInput("Switch Weapon")},
	Lift = {"Lift",cagetters:GetInput("Lift")},
	Pistol = {"Pistol",cagetters:GetInput("Pistol")},
	Magic = {"Magic",cagetters:GetInput("Magic")},
	Dynamite = {"Dynamite",cagetters:GetInput("Dynamite")},
	Special = {"Special",cagetters:GetInput("Special")},
	
	Adrenaline = {"Adrenaline",cagetters:GetVKCode("X")},
	Rage = {"Rage",cagetters:GetVKCode("Z")},
	["Help Prompt"] = {"Help Prompt",cagetters:GetVKCode("G")},
	Heal = {"Heal",cagetters:GetVKCode("H")},
	Eat = {"Eat",cagetters:GetVKCode("J")},
	Drink = {"Drink",cagetters:GetVKCode("K")},
	["Fill Empty Glasses"] = {"Fill Empty Glasses",cagetters:GetVKCode("L")},
	Buff = {"Buff",cagetters:GetVKCode("B")},
	["Cycle Paladin"] = {"Cycle Paladin",cagetters:GetVKCode("C")},
	Inventory = {"Inventory",cagetters:GetVKCode("I")},
	["Toggle Powerup Backward"] = {"Toggle Powerup Backward",cagetters:GetVKCode("NUM1")},
	["Trigger Powerup"] = {"Trigger Powerup",cagetters:GetVKCode("NUM2")},
	["Toggle Powerup Forward"] = {"Toggle Powerup Forward",cagetters:GetVKCode("NUM3")}
}

	STR,RECT,ALIGN,COLOR,FONT_INDEX = {},{},{},{},{}
	
	caload:ReadConfig()
	cagetters:GetBoundInputs()
	
	tools = {}
	caoperations:CreateTools()
	fonts = {}
	caoperations:CreateFonts()
	casetters:SetMultipliers()
	LoopThroughObjects(ApplyMultipliersToLoadedEnemies)
end

function caload:ReadConfig()
	Show,ShowHealthDetails,Darkness,Difficulty,Lighting,Color = true,true,true,"Normal","retro",tonumber(0x0000ff)

	file = io.open(path.."CAFTAConfig.cfg", "r")
	if file then
		local lines = {}
		local crt = 0
		for line in file:lines() do
			table.insert(lines, line)
			crt = crt+1
		end
		for i=1,crt do
			if string.find(lines[i],"Show:") then
				local arg = ""
				for s in lines[i]:gmatch"%b:;" do 
					arg = arg..s
				end
				arg = arg:gsub(':','')
				arg = arg:gsub(';','')	
				if arg=="true" then Show = true end
				if arg~="true" then
					Show = false
				end
			end					
			if string.find(lines[i],"Show health details:") then
				local arg = ""
				for s in lines[i]:gmatch"%b:;" do 
					arg = arg..s
				end
				arg = arg:gsub(':','')
				arg = arg:gsub(';','')	
				if arg=="true" then ShowHealthDetails = true end
				if arg~="true" then
					ShowHealthDetails = false
				end
			end							
			if string.find(lines[i],"Darkness:") then
				local arg = ""
				for s in lines[i]:gmatch"%b:;" do 
					arg = arg..s
				end
				arg = arg:gsub(':','')
				arg = arg:gsub(';','')	
				if arg=="true" then Darkness = true end
				if arg~="true" then
					Darkness = false
				end
			end		
			if string.find(lines[i],"Difficulty:") then
				local arg = ""
				for s in lines[i]:gmatch"%b:;" do 
					arg = arg..s
				end
				arg = arg:gsub(':','')
				arg = arg:gsub(';','')
				arg = string.lower(arg)
				local dic = {["easy"] = "Easy", ["normal"] = "Normal", ["hard"] = "Hard", ["very hard"] = "Very Hard", ["revengeance"] = "Revengeance", ["mpcultist"] = "Mpcultist"}
				if arg=="easy" or arg=="normal" or arg=="hard" or arg=="very hard" or arg=="revengeance" or arg=="mpcultist" then Difficulty = dic[arg] end
			end										
			if string.find(lines[i],"Lighting:") then
				local arg = ""
				for s in lines[i]:gmatch"%b:;" do 
					arg = arg..s
				end
				arg = arg:gsub(':','')
				arg = arg:gsub(';','')	
				if arg=="retro" then Lighting = arg
				elseif arg=="fancy" then Lighting = arg end
			end						
			if string.find(lines[i],"Color:") then
				local arg = ""
				for s in lines[i]:gmatch"%b:;" do 
					arg = arg..s
				end
				arg = arg:gsub(':','')
				arg = arg:gsub(';','')	
				Color = tonumber(arg)
				if arg=="0x000000" then Color = 0 end
				local _arg = string.sub(arg,3)
				if string.len(_arg)~=6 or (_arg:gsub("[0123456789abcdefABCDEF$]",""))~="" then
					Color = 0x0000ff
				end
			end				
			if string.find(lines[i],"Blacklisted enemies:") and _cline==nil then
				_cline = i+2
			end
			if _cline and i>=_cline and i<crt then
				local arg = ""
				arg = arg..lines[i]
				arg = arg:gsub(';','')	
				table.insert(BlacklistedEnemies,arg)
			end
		end
		io.close(file)
	end
	_Difficulty = Difficulty
end

return caload