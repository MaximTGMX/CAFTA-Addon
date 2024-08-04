local LightSource = {"TORCH","TORCHSTAND","RICOCHET","RATBOMB","CRABBOMB","PUNKRAT","TORCH2","SEWERLAMP","STREETLAMP","WINDOW1","WINDOW2","WINDOW3","WINDOW4","BEACHTORCH","POSTLANTERNS",
"LANTERN","WINDOWLIGHT","SKULLPOST","SKULLCANDLE","CRYSTALIGHT2","FISH","AQUATISWALLCRACK","TENTICLELAMP","FIRESTONE","DOUBLETORCH","FIREARCH","FIREPIT","GROUNDTORCH","THREETORCH"}
local path = "Assets/GAME/MODULES/CAFTA_Modules/"
local mdl_path = 'Assets.GAME.MODULES.CAFTA_Modules.'

caprocess = {}

-------------------------------------------------PROCESSES-------------------------------------------------
function caprocess:CreateHUDElement(x, y, image)
	local _CreateHUDElement = ffi.cast("ObjectA* (*__thiscall)(ObjectA*, int, int, int, int, int, int)", 0x4D52F0)
	local object = _CreateHUDElement(MULTI_STATS, 0, x, y, 9999, 0x520624, 0)
	object:SetImage(image)
	return object
end

function caprocess:BladeMode()
local PLAY_AREA = cs:PlayArea()
	local p = ffi.new("POINT",{0,0})
	local cX,cY = PLAY_AREA.Right/2,PLAY_AREA.Bottom/2
	local mX,mY = GetCursorPos().x,GetCursorPos().y
	local angle = math.atan2(mY-cY,mX-cX)
	angle = math.rad((math.deg(angle)))
	local coordX,coordY = 2*cX*math.cos(angle),2*cX*math.sin(angle)

	ffi.C.MoveToEx(hdc,cX,cY,p)
	ffi.C.LineTo(hdc,cX+coordX,cY+coordY)
	ffi.C.LineTo(hdc,cX-coordX,cY-coordY)
end

function caprocess:HideLives()
	if string.lower(Difficulty)=="easy" then 
		--ffi.cast("char*",0x494A77)[0] = 0
		--PrivateCast(0, "char*", 0x494A77)
		GetInterface"LivesFrame".DrawFlags.NoDraw = true
		GetInterface("LivesFrame",1).DrawFlags.NoDraw = true
		isOnEasyMode = true
	else
		--ffi.cast("char*",0x494A77)[0] = 0x19
		--PrivateCast(0x19, "char*", 0x494A77)
		GetInterface"LivesFrame".DrawFlags.NoDraw = false
		GetInterface("LivesFrame",1).DrawFlags.NoDraw = false
		isOnEasyMode = false
	end
end

function caprocess:ApplyDifficulty(self)
local claw = GetClaw()
local screenx,screeny = Game(9,23,16),Game(9,23,17)
local PLAY_AREA = ffi.cast("Rect*", 0x535840)[0]

local osx, osy = self.X-screenx,self.Y-screeny+tonumber(ffi.cast("int&",0x535844))
local frenzyMode = ffi.cast("int**", 0x5326FC)[0]

	--stop the current health bar
	if not startHealth then startHealth = GetClaw().Health end
	if Spawn and GetTicks()-Spawn > 100 then
		GetClaw().Health = startHealth
		Spawn = nil
	elseif Spawn then
		GetClaw().Health = 190
	end
	--[[new healthbar
	if HealthBar==nil then
		HealthBar = caprocess:CreateHUDElement(PLAY_AREA.Right-32, PLAY_AREA.Top+15, "GAME_CAFTA_ADDON_HEALTHINTERFACE")
	end
	HealthBar.X = PLAY_AREA.Right-32
	HealthBar.Y = PLAY_AREA.Top+15
	if GetClaw().Health > 0 and GetTicks()-Rate > MaxHealth-GetClaw().Health+50 then
		Rate = GetTicks()
		if HealthBar.I+1>3 then
			HealthBar:SetFrame(1)
		else
			HealthBar.I = HealthBar.I+1
			HealthBar:SetFrame(HealthBar.I)
		end
	elseif GetClaw().Health <= 0 then
		HealthBar:SetFrame(HealthBar.I)
	end
	-----]]

	if string.lower(Difficulty)=="easy" then
		--increase health cap
		MaxHealth = 200
		if GetClaw().Health < 200 then
			local bytes3 = {0xE9,0xB1,0,0,0,0x90}
			--[[for i=0,5 do
				ffi.cast("char*",0x41E454)[i] = 0x90
				ffi.cast("char*",0x41E465)[i] = bytes3[i+1]
			end]]
			for i=0,5 do
				PrivateCast(0x90, "char*", 0x41E454, i)
				PrivateCast(bytes3[i+1], "char*", 0x41E465, i)
			end
		else
			GetClaw().Health = 200
			local bytes = {0x0F,0x8D,0x0D,0x06,0,0}
			local bytes2 = {0x0F,0x8E,0xB0,0,0,0}
			for i=0,5 do
				--ffi.cast("char*",0x41E454)[i] = bytes[i+1]
				--ffi.cast("char*",0x41E465)[i] = bytes2[i+1]
				
				PrivateCast(bytes[i+1], "char*", 0x41E454, i)
				PrivateCast(bytes2[i+1], "char*", 0x41E465, i)
			end
		end
		--------------------------------
		ffi.cast("int*",0x535950)[0] = 1  --easymode on
		ffi.cast("int*",0x535944)[0] = 1  --playallday on
		--more pickups
		local pickup = ffi.cast("int*", 0x536768)
        pickup[0] = 25*2 -- ammo deathbag
        pickup[1] = 5*2 -- ammo
        pickup[2] = 10*2 -- ammo bag
        pickup[3] = 15000 -- catnip golden
        pickup[4] = 30000 -- catnip red
        pickup[5] = 5*2 -- food
        pickup[6] = 25*2 -- big potion
        pickup[7] = 10*2 -- small potion
        pickup[8] = 15*2 -- medium potion
        pickup[9] = 5*2 -- magic
        pickup[10] = 10*2 -- magic starglow 
        pickup[11] = 35*2 -- magic claw		
		--skip ammo cap
		ffi.cast("char*",0x41E58C)[0] = 0xeb
		ffi.cast("char*",0x41E54F)[0] = 0xeb
		ffi.cast("char*",0x4203CA)[0] = 0xeb			
		--increased ammo cap
		--[[if isOnEasyMode and Back==nil then
			Back = ca:CreateHUDElement(PLAY_AREA.Right-52, PLAY_AREA.Top+46, "GAME_CAFTA_ADDON_UI")		
			Number = ca:CreateHUDElement(PLAY_AREA.Right-50, PLAY_AREA.Top+46, "GAME_INTERFACE_SMALLNUMBERS")
		end
		Back.X = PLAY_AREA.Right-52
		Back.Y = PLAY_AREA.Top+46		
		Number.X = PLAY_AREA.Right-50
		Number.Y = PLAY_AREA.Top+46	
		if PlayerData()._unkn13 == 1 then
			Number:SetFrame(PlayerData().PistolAmmo/100)
		elseif PlayerData()._unkn13 == 2 then
			Number:SetFrame(PlayerData().MagicAmmo/100)
		else
			Number:SetFrame(PlayerData().TNTAmmo/100)
		end]]
			
		if PlayerData().PistolAmmo>999 then PlayerData().PistolAmmo = 999 end
		if PlayerData().MagicAmmo>999 then PlayerData().MagicAmmo = 999 end
		if PlayerData().TNTAmmo>999 then PlayerData().TNTAmmo = 999 end
		---------------------------
			
		--tamer tigers
		ffi.cast("int*", 0x44DF38)[0] = 12
		--no frenzy mode aquatis
		if (GetImgStr(self.Image)=="LEVEL_KINGAQUATIS" or GetImgStr(self.Image)=="CUSTOM_KINGAQUATIS") and frenzyMode then
			frenzyMode[322] = 0
		end
		--redtail wind doesnt blow claw back that much
		if self.Logic==RedTailWind and GetClaw().Y > 1959 and GetClaw().X < 37875 and self.State == 2110 then
			--self.MoveRect = {37056,1959,37875,2186}
			if not Force and PlayerData()._unkn34 ~= 0 then
				Force = PlayerData()._unkn34
			end
			if Force then PlayerData()._unkn34 = Force + 100 end
		end
		if self.Logic==RedTailWind and self.State ~= 2110 and Force then
			Force = nil
		end
	else
		--ammo cap
		ffi.cast("char*",0x41E58C)[0] = 0x7e
		ffi.cast("char*",0x41E54F)[0] = 0x7e
		ffi.cast("char*",0x4203CA)[0] = 0x7e
		--aggressive tigers
		ffi.cast("int*", 0x44DF38)[0] = 14*multiplier
	end
	
	if self.User[5]==0 then self.User[5] = self.Health end
	--damage multiplier for enemies
	ffi.cast("float*", 0x524580)[0] = multiplier
	--health multiplier for enemies
	ffi.cast("float*", 0x524584)[0] = multiplier
	--??? multiplier for ???
	ffi.cast("float*", 0x524588)[0] = multiplier
	
	ffi.cast("int*", 0x498B45)[0] = 20*multiplier --Tiger's Lunge Attack Dmg
	ffi.cast("int*", 0x498D9C)[0] = 15*multiplier --Tiger's Knife Attack Dmg

	
	EnemyLogics={FloorSpike,FloorSpike2,FloorSpike3,FloorSpike4,SawBlade,SawBlade2,SawBlade3,SawBlade4,TProjectile,Stalactite,SkullCannon,GooVent,Laser,LavaMouth,LavaGeyser,LavaHand,
	TowerCannonLeft}
	BulletLogics={WolvingtonBullet,TridentBullet,RedTailBullet,RatBomb,GabrielBomb,RedTailKnife,RedTailSpikes,OmarBullet,CannonBall}
	for _,l in pairs(EnemyLogics) do
		if self.User[4]==0 and self.Logic==l then
			self.Damage = self.Damage*multiplier
			self.User[4] = self.Damage
			if string.lower(Difficulty)=="easy" then
				if self.Logic==TProjectile or _GetName(self)=="TProjectile" then
					self.DrawFlags.NoDraw = true
				else
					self:SetFrame(1)
				end
				self.Logic = DoNothing  
				self.ObjectTypeFlags = 1
				self.State = 1007
			end
		end
	end
	if self.ObjectTypeFlags == 64 and self.User[4]==0 then

	--
		--set projectile stats
		--[[if self.User[4]==0 and (self.ObjectTypeFlags == 64 or self.ObjectTypeFlags==16777216 or self.Logic==WolvingtonBullet or self.Logic==TridentBullet or self.Logic==RedTailBullet or self.Logic==RatBomb 
		or self.Logic==GabrielBomb or self.Logic==RedTailKnife or self.Logic==RedTailSpikes or self.Logic==OmarBullet or self.Logic==CannonBall) then
			self.User[4] = self.Damage*multiplier
			self.Damage = self.Damage*multiplier
		end]]
		

		--traps are disabled on easy; increased stats on the other difficulties
		--[[if self.User[4]==0 and (self.Logic==FloorSpike or self.Logic==FloorSpike2 or self.Logic==FloorSpike3 or self.Logic==FloorSpike4
		or _GetName(self)=="FloorSpike" or _GetName(self)=="FloorSpike2" or _GetName(self)=="FloorSpike3" or _GetName(self)=="FloorSpike4"
		or self.Logic==SawBlade or self.Logic==SawBlade2 or self.Logic==SawBlade3 or self.Logic==SawBlade4
		or _GetName(self)=="SawBlade" or _GetName(self)=="SawBlade2" or _GetName(self)=="SawBlade3" or _GetName(self)=="SawBlade4"
		or self.Logic==TProjectile or self.Logic==Stalactite or self.Logic==SkullCannon or self.Logic==GooVent or self.Logic==Laser or self.Logic==LavaMouth 
		or self.Logic==LavaGeyser or self.Logic==LavaHand or self.Logic==TowerCannonLeft or self.Logic==TowerCannonRight
		or _GetName(self)=="TProjectile" or _GetName(self)=="Stalactite" or _GetName(self)=="SkullCannon" or _GetName(self)=="GooVent" or _GetName(self)=="Laser" or _GetName(self)=="LavaMouth"
		or _GetName(self)=="LavaGeyser" or _GetName(self)=="LavaHand" or _GetName(self)=="TowerCannonLeft" or _GetName(self)=="TowerCannonRight") then
			if string.lower(Difficulty)=="easy" then
				if self.Logic==TProjectile or _GetName(self)=="TProjectile" then
					self.DrawFlags.NoDraw = true
				else
					self:SetFrame(1)
				end
				self.ObjectTypeFlags = 1
				self.Logic = DoNothing
				self.State = 1007
				self.User[4] = 1
			else
				self.User[4] = self.Damage*multiplier
				self.Damage = self.Damage*multiplier
			end
		end]]
		
		if self.Health > 0 and self.ObjectTypeFlags == 4 then 
			if (self.User[4] == 0 or self.Health > self.User[4]) and self.User[4]~=-1 then
				--self.Health = self.Health*multiplier
				--self.Damage = self.Damage*multiplier
				if (GetImgStr(self.Image)=="LEVEL_KINGAQUATIS" or GetImgStr(self.Image)=="CUSTOM_KINGAQUATIS" or GetImgStr(self.Image)=="LEVEL_GABRIEL" or GetImgStr(self.Image)=="CUSTOM_GABRIEL") then
					self.Health = 100
				end
				self.User[4] = self.Health
			--[[elseif self.Health < self.User[4] and GetClaw().State==5009 then
				if GetClaw().State==5009 and self.User[5]==0 then
					self.User[5] = 1
				end
				if self.User[5]~=0 and GetClaw().State~=5009 then
					self.User[5] = 0
					self.Health = self.User[4]
				end]]
			end
		end
		
		--set fish stats
		--[[if self.User[4]==0 and (self.Logic==Fish or _GetName(self)=="Fish" or (self.ObjectTypeFlags==4 and self.Health==0)) then
			self.Damage = self.Damage*multiplier
			self.User[4] = self.Damage
		end]]
	end
		
	if Show and self.Health > 0 and (self.ObjectTypeFlags == 4 or self.ObjectTypeFlags == 16) and self.HitTypeFlags ~= 50331698 and self.HitTypeFlags ~= 50331682 and self.DrawFlags.NoDraw == false and cavalidators:CheckImage(GetImgStr(self.Image)) then
		if self.User[4] == 0 then
			self.User[4] = self.Health
		end
		ffi.C.SelectObject(hdc,tools.font)
		ffi.C.SelectObject(hdc,tools.pen)
		if ShowHealthDetails then
			ffi.C.SetTextColor(hdc, Color)
			local lines = 1
			local ost = math.min(self.HitRect.Top, self.MoveRect.Top)
			local str = tostring(self.Health)
			local rct = ffi.new("Rect",{osx-#str+24, osy+ost-32, osx+#str*10+48, osy+ost+22})
			local lprct = ffi.new("Rect[1]",rct)
			ffi.C.DrawTextA(hdc, str,#str, lprct, 1)
		end
		local increase = 64-64*self.Health/self.User[4]
		local xmin = osx-32+increase
		local xmax = osx+32
		local top = math.min(self.HitRect.Top, self.MoveRect.Top)
		local rgn = ffi.C.CreateRectRgn(xmin,osy+4+top-22,xmax,osy-4+top-22)
		local brush = ffi.C.CreateSolidBrush(Color)
		ffi.C.FillRgn(hdc, rgn, brush)
		ffi.C.DeleteObject(brush)
		ffi.C.DeleteObject(rgn)
		rgn,brush = nil,nil
	end
end

function caprocess:CheckLightObject()
	local claw = GetClaw()
	local screenx,screeny = Game(9,23,16),Game(9,23,17)
	local PLAY_AREA = ffi.cast("Rect*", 0x535840)[0]
	
	local csx, csy = GetClaw().X-screenx,GetClaw().Y-screeny+tonumber(ffi.cast("int&",0x535844))
	--ffi.C.SetBkMode(hdc, 1)
	if Lighting=="retro" then
		DIFF = ffi.C.CreateRectRgn(csx-92-lightBooster,csy-128-lightBooster,csx+92+lightBooster,csy+128+lightBooster)
	else
		DIFF = ffi.C.CreateEllipticRgn(csx-92-lightBooster,csy-128-lightBooster,csx+92+lightBooster,csy+128+lightBooster)
	end
	local TreasureHUD = ffi.C.CreateRectRgn(PLAY_AREA.Left,PLAY_AREA.Top,PLAY_AREA.Left+288,PLAY_AREA.Top+32)
	ffi.C.CombineRgn(DIFF, DIFF, TreasureHUD, 2)
	ffi.C.DeleteObject(TreasureHUD)
	TreasureHUD = nil		
	local HealthHUD = ffi.C.CreateRectRgn(PLAY_AREA.Right-70,PLAY_AREA.Top,PLAY_AREA.Right,PLAY_AREA.Top+80)
	ffi.C.CombineRgn(DIFF, DIFF, HealthHUD, 2)
	ffi.C.DeleteObject(HealthHUD)
	HealthHUD = nil
	local GemHUD = ffi.C.CreateRectRgn(PLAY_AREA.Right-155,PLAY_AREA.Top,PLAY_AREA.Right-100,PLAY_AREA.Top+50)
	ffi.C.CombineRgn(DIFF, DIFF, GemHUD, 2)
	ffi.C.DeleteObject(GemHUD)
	GemHud = nil
	if _CurrentPowerup[0] >= 9911 and _CurrentPowerup[0] <= 9917 then
		local TimerHUD = ffi.C.CreateRectRgn(PLAY_AREA.Left,PLAY_AREA.Top+32,PLAY_AREA.Left+64,PLAY_AREA.Top+64)
		ffi.C.CombineRgn(DIFF, DIFF, TimerHUD, 2)
		ffi.C.DeleteObject(TimerHUD)
		TimerHUD = nil
	end
	local rgn2 = ffi.C.CreateRectRgn(0,0,PLAY_AREA.Right+1,PLAY_AREA.Bottom+1)
	
	if not Blindness then
		if Room and Darkness then
			caprocess:LoopThroughObjectsInRange("Combine Tile Region",GetClaw(),{-384,-304,384,304},"Tiles")
		end
		
		if Darkmode and Darkness then
			caprocess:LoopThroughObjectsInRange("Set Darkness",GetClaw(),{-384,-304,384,304},"Cave")
		end
	end

	ffi.C.CombineRgn(rgn2, rgn2, DIFF, 4)
	ffi.C.FillRgn(hdc, rgn2, tools.stocka)
			
	ffi.C.DeleteObject(DIFF)
	DIFF = nil					
	ffi.C.DeleteObject(rgn2)
	rgn2 = nil
end

function caprocess:CreateDarkness()
	if (Darkness==true and (Darkmode or Room)) or Blindness then
		caprocess:CheckLightObject()
	end
end

function caprocess:TextOnScreen()
local aligns = {
	BOTTOM = 0x8,
	CENTER = 0x1,
	LEFT = 0x0, TOP = 0x0,
	RIGHT = 0x2,
	BREAK = 0x10
}
	if STR~=nil then
		for v,w in pairs(STR) do
			local rct = ffi.new("Rect",{RECT[v][1], RECT[v][2], RECT[v][3], RECT[v][4]})
			local lprct = ffi.new("Rect[1]",rct)
			ffi.C.SelectObject(hdc, fonts[FONT_INDEX[v]])
			ffi.C.SetTextColor(hdc, COLOR[v])
			local value = aligns[string.upper(ALIGN[v])]
			ffi.C.DrawTextA(hdc, STR[v], #STR[v], lprct, value)
		end
	end
end

function caprocess:CreateBattleArea()
	local claw = GetClaw()
	local screenx,screeny = Game(9,23,16),Game(9,23,17)

	if tools~=nil and CombatObjectID~=0 then
		local osxMin, osyMin, osxMax, osyMax = GetObject(CombatObjectID).XMin-screenx-16,GetObject(CombatObjectID).YMin-screeny+tonumber(ffi.cast("int&",0x535844)),GetObject(CombatObjectID).XMax-screenx+16,GetObject(CombatObjectID).YMax-screeny+tonumber(ffi.cast("int&",0x535844))
		ffi.C.SelectObject(hdc, tools.penc)
		ffi.C.SelectObject(hdc, tools.brushb)
		ffi.C.Rectangle(hdc,{osxMin-24,osyMin,osxMin,osyMax})
		ffi.C.Rectangle(hdc,{osxMax,osyMin,osxMax+24,osyMax})
	end
end

function caprocess:CreateBossBar()
local PLAY_AREA = ffi.cast("Rect*", 0x535840)[0]
local osx, osy = PLAY_AREA.Right-101,PLAY_AREA.Bottom-19+tonumber(ffi.cast("int&",0x535844))
	if BossID~=nil then	
		local self = GetObject(BossID)
		regions = {}
		--yellow/health bar
		for i=1,9 do
			regions[i] = ffi.C.CreateRectRgn(osx+self.CurrentBar[1],osy-5+i,osx+self.CurrentBar[2],osy-4+i)
			if i<5 then
				ffi.C.FillRgn(hdc, regions[i], tools[i])
			elseif i>=5 and i<9 then
				ffi.C.FillRgn(hdc, regions[i], tools[8-i])
			else
				ffi.C.FillRgn(hdc, regions[i], tools[5])
			end
		end	
		--red/damage bar
		for i=10,18 do
			regions[i] = ffi.C.CreateRectRgn(osx+self.CurrentBar[1],osy-14+i,osx+self.CurrentBar[1]+self.DamageBar,osy-13+i)
			if i<14 then
				ffi.C.FillRgn(hdc, regions[i], tools[19-i])
			elseif i>=14 and i < 18 then
				ffi.C.FillRgn(hdc, regions[i], tools[i-8])
			else
				ffi.C.FillRgn(hdc, regions[i], tools[10])
			end
		end	
		--gray upper bar
		for i=19,22 do
			regions[i] = ffi.C.CreateRectRgn(osx-81,osy-31+i,osx+101,osy-30+i)
			ffi.C.FillRgn(hdc, regions[i], tools[i-8])
		end
			
		for v,w in pairs(regions) do
			ffi.C.DeleteObject(w)
		end
		regions = nil
	end
end

function caprocess:LoopThroughObjectsInRange(funct,target, rect, case, arg)
	target = target or GetClaw()
	if Game(2) ~= 0 then
		local node = ffi.cast("node*", Game(2,5))
		while node ~= nil do
			local object = node.object
			node = node.next
			if funct=="Set Difficulty" then
				if cavalidators:isInRange(object,target,rect,case) then 
					caprocess:ApplyDifficulty(object)
				end				
			elseif funct=="Set Darkness" then
				if cavalidators:isInRange(object,target,rect,case) then
					caoperations:CombineRegions(object)
				end				
			elseif funct=="Combine Tile Region" then
				if cavalidators:isInRange(object,target,rect,case) then
					caoperations:CombineTileRegion(object)
				end				
			elseif funct=="Show Tiles" then
				if cavalidators:isInRange(object,target,rect,case) then
					caoperations:ShowTiles(object)
				end
			elseif funct then
				if cavalidators:isInRange(object,target,rect,case) then
					funct(object, arg) 
				end
			else
				object:Logic()
			end
		end
	end
end

return caprocess