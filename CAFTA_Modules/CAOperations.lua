local LightSource = {"TORCH","TORCHSTAND","RICOCHET","RATBOMB","CRABBOMB","PUNKRAT","TORCH2","SEWERLAMP","STREETLAMP","WINDOW1","WINDOW2","WINDOW3","WINDOW4","BEACHTORCH","POSTLANTERNS",
"LANTERN","WINDOWLIGHT","SKULLPOST","SKULLCANDLE","CRYSTALIGHT2","FISH","AQUATISWALLCRACK","TENTICLELAMP","FIRESTONE","DOUBLETORCH","FIREARCH","FIREPIT","GROUNDTORCH","THREETORCH"}
local path = "Assets/GAME/MODULES/CAFTA_Modules/"
local mdl_path = 'Assets.GAME.MODULES.CAFTA_Modules.'

caoperations = {}

-------------------------------------------------OPERATIONS-------------------------------------------------
function caoperations:CreateTools()
	tools.brush = ffi.C.CreateSolidBrush(0)
	tools.brusha = ffi.C.CreateHatchBrush(4,0x000000)
	tools.brushb = ffi.C.CreateHatchBrush(5,0x0099f2)
	tools[1] = ffi.C.CreateSolidBrush(0x162276)--0x162276 0x172991 0x2463b7 0x6fd2ff 0x0e0e1b
	tools[2] = ffi.C.CreateSolidBrush(0x172991)
	tools[3] = ffi.C.CreateSolidBrush(0x2463b7)
	tools[4] = ffi.C.CreateSolidBrush(0x6fd2ff)
	tools[5] = ffi.C.CreateSolidBrush(0x0e0e1b)
	tools[6] = ffi.C.CreateSolidBrush(0x0000ff)
	tools[7] = ffi.C.CreateSolidBrush(0x0000da)
	tools[8] = ffi.C.CreateSolidBrush(0x0000bb)
	tools[9] = ffi.C.CreateSolidBrush(0x00008c)
	tools[10] = ffi.C.CreateSolidBrush(0x000063)			
	tools[11] = ffi.C.CreateSolidBrush(0x0e0e0f)			
	tools[12] = ffi.C.CreateSolidBrush(0xab9e9f)			
	tools[13] = ffi.C.CreateSolidBrush(0xacacaa)			
	tools[14] = ffi.C.CreateSolidBrush(0x9da974)			
			
			
	tools.pen = ffi.C.CreatePen(5,0,0)
	tools.pena = ffi.C.CreatePen(0,2,0x00FF00)
	tools.penb = ffi.C.CreatePen(2,0,0x00FF00)
	tools.penc = ffi.C.CreatePen(0,2,0x0a72f2)
	tools.pend = ffi.C.CreatePen(0,2,0xf67232)
	tools.stocka = ffi.C.GetStockObject(4)
	tools.stockb = ffi.C.GetStockObject(2)
	tools.stockc = ffi.C.GetStockObject(1)
	
	tools.font = ffi.C.CreateFontA(20,0,0,0,0,0,0,0,1,8,0,5,2,"Arial Bold")
end

function caoperations:CreateFonts()
	fonts[1] = ffi.C.CreateFontA(16,0,0,0,0,0,0,0,1,8,0,5,2,"Verdana Bold")
	fonts[2] = ffi.C.CreateFontA(18,0,0,0,0,0,0,0,1,8,0,5,2,"Arial Bold")
	fonts[3] = ffi.C.CreateFontA(40,12,0,0,900,0,0,0,1,8,0,5,2,"Consolas Bold")
	fonts[4] = ffi.C.CreateFontA(12,0,0,0,0,0,0,0,1,8,0,5,2,"Courier")
	fonts[5] = ffi.C.CreateFontA(32,0,0,0,0,0,0,0,1,8,0,5,2,"Times New Roman Bold")
	fonts[6] = ffi.C.CreateFontA(14,0,0,0,0,0,0,0,1,8,0,5,2,"Arial Bold")
end

function caoperations:AddFont(pos,height,name,width,weight,italic,underline,strikeout)
	if not width then width = 0 end
	if not weight then weight = 0 end
	if not italic then italic = false end
	if not underline then underline = false end
	if not strikeout then strikeout = false end
	fonts[pos] = ffi.C.CreateFontA(height,width,0,0,weight,italic,underline,strikeout,1,8,0,5,2,name)
end

function caoperations:DestroyTools()
	if tools~=nil then
		for _,v in pairs(tools) do ffi.C.DeleteObject(v) end
	end
end

function caoperations:DestroyFonts()
	if fonts~=nil then
		for _,v in pairs(fonts) do ffi.C.DeleteObject(v) end
	end
end

function caoperations:AddLightSource(image)
	for v,w in pairs(LightSource) do
		local type1, type2, type3 = "LEVEL_"..w, "CUSTOM_"..w, "GAME_"..w
		if image==type1 or image==type2 or image==type3 then
			return true
		end
	end
	table.insert(LightSource,image)
end

function caoperations:ShowTiles(self)	
	self.DrawFlags.NoDraw = false	
end

function caoperations:CombineTileRegion(self)
	local claw = GetClaw()
	local rgn1 = nil
	local screenx,screeny = Game(9,23,16),Game(9,23,17)
	
	self.DrawFlags.NoDraw = true
	local osx, osy = self.X-screenx,self.Y-screeny+tonumber(ffi.cast("int&",0x535844))
	local rgn1 = nil
	rgn1 = ffi.C.CreateRectRgn(osx-32,osy-32,osx+32,osy+32)
	ffi.C.CombineRgn(DIFF, DIFF, rgn1, 2)
	ffi.C.DeleteObject(rgn1)
	rgn1 = nil		
end

function caoperations:CombineRegions(self)
	local claw = GetClaw()
	local screenx,screeny = Game(9,23,16),Game(9,23,17)
	local osx, osy = self.X-screenx,self.Y-screeny+tonumber(ffi.cast("int&",0x535844))
	local rgn1 = nil
	if cavalidators:IsLightSource(GetImgStr(self.Image)) or _GetName(self)=="CheckShadow" or _GetName(self)=="Fish" or _GetName(self)=="Fire" or _GetName(self)=="CampFire" or _GetName(self)=="HeartLantern" then
		if Lighting=="retro" then
			rgn1 = ffi.C.CreateRectRgn(osx+self.AttackRect.Left-lightBooster,osy+self.AttackRect.Top-lightBooster,osx+self.AttackRect.Right+lightBooster,osy+self.AttackRect.Bottom+lightBooster)
		else
			rgn1 = ffi.C.CreateEllipticRgn(osx+self.AttackRect.Left-lightBooster,osy+self.AttackRect.Top-lightBooster,osx+self.AttackRect.Right+lightBooster,osy+self.AttackRect.Bottom+lightBooster)
		end
	end	
	ffi.C.CombineRgn(DIFF, DIFF, rgn1, 2)
	ffi.C.DeleteObject(rgn1)
	rgn1 = nil	
end

function caoperations:AddText(str, rect, align, font_index, color)
if color == nil then color = 0xffffff end
local count = 0

	if STR~=nil then
		for v,w in pairs(STR) do
			if w==nil then break end
			count = count+1
		end
	end
	local pos = count+1

	STR[pos] = str
	RECT[pos] = rect
	ALIGN[pos] = align
	COLOR[pos] = color
	FONT_INDEX[pos] = font_index
end

function caoperations:ModifyText(str, newstr, rect, align, font_index, color)
local index = 1
	for v,w in pairs(STR) do
		if w==str then
			index = v
			break
		end
	end
	
	if not newstr then newstr = STR[index] end
	if not rect then rect = RECT[index] end
	if not align then align = ALIGN[index] end
	if not font_index then font_index = FONT_INDEX[index] end
	if not color then color = COLOR[index] end
	
	STR[index] = newstr
	RECT[index] = rect
	ALIGN[index] = align
	FONT_INDEX[index] = font_index
	COLOR[index] = color
end

function caoperations:RemoveText(str)
	for v,w in pairs(STR) do
		if w==str then
			STR[v] = nil
			RECT[v] = nil
			ALIGN[v] = nil
			COLOR[v] = nil
			FONT_INDEX[v] = nil
			break
		end
	end
end

function caoperations:RectsOverlap(rect1,rect2)
    local case1 = rect1[1] > rect2[3]
    local case2 = rect1[2] > rect2[4]
    local case3 = rect1[3] < rect2[1]
    local case4 = rect1[4] < rect2[2]
    return not (case1 or case2 or case3 or case4)
end

function caoperations:Hex(integer)
    if tonumber(integer) ~= nil then
        local hex = string.format("%x",integer)
        if integer <= 15 and integer > 0 then
            return "0x00000"..string.upper(hex)
        elseif integer == 0 then
            return "0x000000"
        else
			while string.len(hex)<6 do
				hex = "0"..hex
			end
            return "0x"..string.upper(hex)
        end
    else
        return "0x000000"
    end
end

function caoperations:HexToRGB(color)
local red,green,blue = 0,0,0
	color = caoperations:Hex(color)
	blue = tonumber("0x"..string.sub(color,3,4))
	green = tonumber("0x"..string.sub(color,5,6))
	red = tonumber("0x"..string.sub(color,7,8))
	return red,green,blue
end

function caoperations:RGBToHex(rgb)
	return string.format("0x%.2X%.2X%.2X", rgb[1], rgb[2], rgb[3])
end

return caoperations