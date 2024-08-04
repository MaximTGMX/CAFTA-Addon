local LightSource = {"TORCH","TORCHSTAND","RICOCHET","RATBOMB","CRABBOMB","PUNKRAT","TORCH2","SEWERLAMP","STREETLAMP","WINDOW1","WINDOW2","WINDOW3","WINDOW4","BEACHTORCH","POSTLANTERNS",
"LANTERN","WINDOWLIGHT","SKULLPOST","SKULLCANDLE","CRYSTALIGHT2","FISH","AQUATISWALLCRACK","TENTICLELAMP","FIRESTONE","DOUBLETORCH","FIREARCH","FIREPIT","GROUNDTORCH","THREETORCH"}
local path = "Assets/GAME/MODULES/CAFTA_Modules/"
local mdl_path = 'Assets.GAME.MODULES.CAFTA_Modules.'

cagetters = {}

-------------------------------------------------GETTERS-------------------------------------------------
function cagetters:GetBoundInputs()
	local file = io.open(path.."CAFTAConfig.cfg", "r")
	local index1 = 1
	local index2 = 1
	local crt = 1
	if file then
		local FileLines = {}
		for line in file:lines() do
			if string.find(line,"# Keybinds:") then
				index1 = crt+2
			end		
			if string.find(line,"}") and index2==1 then
				index2 = crt-1
			end
			table.insert(FileLines,line)
			crt = crt+1
		end
		local _c = 0
		for i=index1,index2 do
			_c = _c+1
			local first = string.find(FileLines[i],":")
			local second = string.find(FileLines[i],";")
			--get key name
			if string.find(FileLines[i],":") then
				crt = string.sub(FileLines[i],1,first-1)
			end
			--get set input
			local arg = string.sub(FileLines[i],first+1,second-1)
			local keyIndex = cagetters:GetVKCode(arg)
			--set new input
			if keyIndex~=nil and keybinds[crt]~=nil then
				keybinds[crt][2] = keyIndex
				if _c<14 then
					casetters:SetInput(crt,keyIndex)
					if crt=="Switch Weapon" and keyIndex==cagetters:GetVKCode("SCROLL") then
						CanUseScroll = true
					end
				end
			end
		end
		io.close(file)
	end
end

function cagetters:GetVKCode(key)
    local Keys = {
		MOUSE1 = 0x01,
        MOUSE2 = 0x02,
        MOUSE3 = 0x04,
        MOUSE4 = 0x05,
        MOUSE5 = 0x06,
		SCROLL = 0x07,
        BACKSPACE = 0x08,
        TAB = 0x09,
        ENTER = 0x0D,
        SHIFT = 0x10, LSHIFT = 0xA0, RSHIFT = 0xA1,
		CTRL = 0x11, LCTRL = 0xA2, RCTRL = 0xA3,
        ALT = 0x12, LALT = 0xA4, RALT = 0xA5,
        PAUSE = 0x13,
        CAPS_LOCK = 0x14,
        ESC = 0x1B,
        SPACE = 0x20,
        PG_UP = 0x21,
        PG_DOWN = 0x22,
        END = 0x23,
        HOME = 0x24,
        LEFT = 0x25,
        UP = 0x26,
        RIGHT = 0x27,
        DOWN = 0x28,
		SELECT = 0x29,
        PRT_SC = 0x2C,
        INSERT = 0x2D,
        DELETE = 0x2E,
		NUMLOCK = 0x90,
        NUM0 = 0x60,
        NUM1 = 0x61,
        NUM2 = 0x62,
        NUM3 = 0x63,
        NUM4 = 0x64,
        NUM5 = 0x65,
        NUM6 = 0x66,
        NUM7 = 0x67,
        NUM8 = 0x68,
        NUM9 = 0x69,    
		MUL = 0x6A,
		ADD = 0x6B,
		SUB = 0x6D,
		DIV = 0x6F,
        F1 = 0x70,
        F2 = 0x71,
        F3 = 0x72,
        F4 = 0x73,
        F5 = 0x74,
        F6 = 0x75,
        F7 = 0x76,
        F8 = 0x77,
        F9 = 0x78,
        F10 = 0x79,
        F11 = 0x7A,
        F12 = 0x7B
    }
	if string.len(key)<2 then
		local code = tonumber(string.byte(string.upper(key)))
		return code
	else
		return Keys[string.upper(key)]
	end
end

function cagetters:GetVKName(code)
    local Keys = {
		[0x01] = "MOUSE1",
        [0x02] = "MOUSE2",
        [0x04] = "MOUSE3",
        [0x05] = "MOUSE4",
        [0x06] = "MOUSE5",
		[0x07] = "SCROLL",
        [0x08] = "BACKSPACE",
        [0x09] = "TAB",
        [0x0D] = "ENTER",
        [0x10] = "SHIFT", [0xA0] = "LSHIFT", [0xA1] = "RSHIFT",
		[0x11] = "CTRL", [0xA2] = "LCTRL", [0xA3] = "RCTRL",
        [0x12] = "ALT", [0xA4] = "LALT", [0xA5] = "RALT",
        [0x13] = "PAUSE",
        [0x14] = "CAPS_LOCK",
        [0x1B] = "ESC",
		[0x20] = "SPACE",
        [0x21] = "PG_UP",
        [0x22] = "PG_DOWN",
        [0x23] = "END",
        [0x24] = "HOME",
        [0x25] = "LEFT",
        [0x26] = "UP",
        [0x27] = "RIGHT",
        [0x28] = "DOWN",
		[0x29] = "SELECT",
        [0x2C] = "PRT_SC",
        [0x2D] = "INSERT",
        [0x2E] = "DELETE",
		[0x90] = "NUMLOCK",
        [0x60] = "NUM0",
        [0x61] = "NUM1",
        [0x62] = "NUM2",
        [0x63] = "NUM3",
        [0x64] = "NUM4",
        [0x65] = "NUM5",
        [0x66] = "NUM6",
        [0x67] = "NUM7",
        [0x68] = "NUM8",
        [0x69] = "NUM9",    
		[0x6A] = "MUL",
		[0x6B] = "ADD",
		[0x6D] = "SUB",
		[0x6F] = "DIV",
        [0x70] = "F1",
        [0x71] = "F2",
        [0x72] = "F3",
        [0x73] = "F4",
        [0x74] = "F5",
        [0x75] = "F6",
        [0x76] = "F7",
        [0x77] = "F8",
        [0x78] = "F9",
        [0x79] = "F10",
        [0x7A] = "F11",
        [0x7B] = "F12"
    }
	if code>=0x30 and code<=0x5A then
		return string.char(code)
	end
	return Keys[code]
end

function cagetters:GetInput(name)
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
	return inputs[ Keys[string.upper(name)] ]
end

function cagetters:GetBoundKey(name)
	return keybinds[name][2]
end

function cagetters:GetDarkmode()
	return Darkmode
end
function cagetters:GetMaxHealth()
	return MaxHealth
end
function cagetters:GetCombatObjectID()
	return CombatObjectID
end
function cagetters:GetBossID()
	return BossID
end
function cagetters:GetRoom()
	return Room
end
function cagetters:GetLightBooster()
	return lightBooster
end
function cagetters:GetMultiplier()
	return multiplier
end
function cagetters:GetBlindness()
	return Blindness
end
function cagetters:GetCanUseScroll()
	return CanUseScroll
end
function cagetters:GetPlayArea()
    return ffi.cast("Rect*", 0x535840)[0]
end
function cagetters:GetScreen()
    return Game(9,23,16),Game(9,23,17)
end
function cagetters:GetFontCount()
local count = 0
	for v,w in pairs(fonts) do
		count = count+1
	end
	return count
end

return cagetters