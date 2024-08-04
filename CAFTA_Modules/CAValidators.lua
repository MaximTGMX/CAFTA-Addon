local LightSource = {"TORCH","TORCHSTAND","RICOCHET","RATBOMB","CRABBOMB","PUNKRAT","TORCH2","SEWERLAMP","STREETLAMP","WINDOW1","WINDOW2","WINDOW3","WINDOW4","BEACHTORCH","POSTLANTERNS",
"LANTERN","WINDOWLIGHT","SKULLPOST","SKULLCANDLE","CRYSTALIGHT2","FISH","AQUATISWALLCRACK","TENTICLELAMP","FIRESTONE","DOUBLETORCH","FIREARCH","FIREPIT","GROUNDTORCH","THREETORCH"}
local path = "Assets/GAME/MODULES/CAFTA_Modules/"
local mdl_path = 'Assets.GAME.MODULES.CAFTA_Modules.'

cavalidators = {}

-------------------------------------------------VALIDATORS-------------------------------------------------
function cavalidators:IsLightSource(image)
	for v,w in pairs(LightSource) do
		local type1, type2, type3 = "LEVEL_"..w, "CUSTOM_"..w, "GAME_"..w
		if image==type1 or image==type2 or image==type3 then
			return true
		end
	end
	return false
end

function cavalidators:CheckImage(str)
	for i,j in pairs(BlacklistedEnemies) do	
		if str==j then
			return false
		end
	end
	return true
end

function cavalidators:ObjectInRect(object1,object2,rect)
    return (object1.X >= rect[1]+object2.X and object1.X <= rect[3]+object2.X and object1.Y >= rect[2]+object2.Y and object1.Y <= rect[4]+object2.Y)
end

function cavalidators:isInRange(self, target, rect, case)
local PLAY_AREA = ffi.cast("Rect*", 0x535840)[0]
local screenx,screeny = math.ceil(Game(9,23,16)+PLAY_AREA.Right/2),math.ceil(Game(9,23,17)+PLAY_AREA.Bottom/2)
	if case=="Camera Range" then
		local screen = {}
		screen.X, screen.Y = screenx, screeny
		if cavalidators:ObjectInRect(self,screen,rect) then
			return true
		end
	elseif case=="Tiles" then
		local screen = {}
		screen.X, screen.Y = screenx, screeny
		if (GetImgStr(self.Image)=="ACTION" or GetImgStr(self.Image)=="BACK" or GetImgStr(self.Image)=="FRONT") and cavalidators:ObjectInRect(self,screen,rect) then
			return true
		end	
	elseif case=="All Tiles" then
		local screen = {}
		screen.X, screen.Y = screenx, screeny
		if (GetImgStr(self.Image)=="ACTION" or GetImgStr(self.Image)=="BACK" or GetImgStr(self.Image)=="FRONT") then
			return true
		end
	elseif (case=="Default" or (case=="Cave" and 
	(cavalidators:IsLightSource(GetImgStr(self.Image)) or (GetImgStr(self.Image)=="LEVEL_POWDERKEG" and self.I >= 2 and self.I < 14) or _GetName(self)=="CampFire" or 
	_GetName(self)=="HeartLantern" or _GetName(self)=="Fire" or _GetName(self)=="CheckShadow" or 
	(_GetName(self)=="Fish" and GetImgStr(self.Image)~=nil) or self.Logic==Dynamite or self.ObjectTypeFlags==33554432 or self.ObjectTypeFlags==32)) or
	(case=="Enemies" and self.ObjectTypeFlags==4)) and cavalidators:ObjectInRect(self,target,rect) then
		return true
	end	
	return false
end

return cavalidators