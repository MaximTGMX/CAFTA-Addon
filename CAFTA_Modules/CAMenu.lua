local LightSource = {"TORCH","TORCHSTAND","RICOCHET","RATBOMB","CRABBOMB","PUNKRAT","TORCH2","SEWERLAMP","STREETLAMP","WINDOW1","WINDOW2","WINDOW3","WINDOW4","BEACHTORCH","POSTLANTERNS",
"LANTERN","WINDOWLIGHT","SKULLPOST","SKULLCANDLE","CRYSTALIGHT2","FISH","AQUATISWALLCRACK","TENTICLELAMP","FIRESTONE","DOUBLETORCH","FIREARCH","FIREPIT","GROUNDTORCH","THREETORCH"}
local path = "Assets/GAME/MODULES/CAFTA_Modules/"
local mdl_path = 'Assets.GAME.MODULES.CAFTA_Modules.'

camenu = {}

function camenu:GraphicsMenu(x,y)
local mouse1 = cagetters:GetVKCode("mouse1")
local PlayArea = cagetters:GetPlayArea()
local red,green,blue = caoperations:HexToRGB(Color)
local RGB = {red,green,blue}

	--create color box and color bars
	local brush = {ffi.C.CreateSolidBrush(Color),ffi.C.CreateSolidBrush(0x0000ff),ffi.C.CreateSolidBrush(0x00ff00),ffi.C.CreateSolidBrush(0xff0000)}
	local extras = {ffi.C.CreateRectRgn(PlayArea.Right/2-96,PlayArea.Bottom/2+40,PlayArea.Right/2-80,PlayArea.Bottom/2+56),
	ffi.C.CreateRectRgn(PlayArea.Right/2,PlayArea.Bottom/2+64,PlayArea.Right/2+256,PlayArea.Bottom/2+72),
	ffi.C.CreateRectRgn(PlayArea.Right/2,PlayArea.Bottom/2+84,PlayArea.Right/2+256,PlayArea.Bottom/2+92),
	ffi.C.CreateRectRgn(PlayArea.Right/2,PlayArea.Bottom/2+104,PlayArea.Right/2+256,PlayArea.Bottom/2+112)}
	
	for v,w in pairs(brush) do
		ffi.C.FillRgn(hdc, extras[v], w)
	end
		
	for v,w in pairs(brush) do
		ffi.C.DeleteObject(w)
		ffi.C.DeleteObject(extras[v])
	end
	brush,extras = nil,nil
	
	--create sliders
	local slider = {ffi.C.CreateRectRgn(PlayArea.Right/2+red,PlayArea.Bottom/2+60,PlayArea.Right/2+red+4,PlayArea.Bottom/2+76),
	ffi.C.CreateRectRgn(PlayArea.Right/2+green,PlayArea.Bottom/2+80,PlayArea.Right/2+green+4,PlayArea.Bottom/2+96),
	ffi.C.CreateRectRgn(PlayArea.Right/2+blue,PlayArea.Bottom/2+100,PlayArea.Right/2+blue+4,PlayArea.Bottom/2+116)
	}
	for v,w in pairs(slider) do
		ffi.C.FillRgn(hdc, w, tools.stockb)
	end
		
	for v,w in pairs(slider) do
		ffi.C.DeleteObject(w)
	end
	slider = nil

	--change color
	for i=1,3 do
		local sliderRect = {PlayArea.Right/2+RGB[i]-8,PlayArea.Bottom/2+60+(i-1)*20-4,PlayArea.Right/2+RGB[i]+8,PlayArea.Bottom/2+76+(i-1)*20-16}
		
		if caoperations:RectsOverlap({x-16,y-16,x,y},sliderRect) and GetVKInput(mouse1) and not selectedSlider then
			selectedSlider = i
		end
		if selectedSlider and selectedSlider==i and GetVKInput(mouse1) then
			local pos = math.floor(x-PlayArea.Right/2)
			if pos<0 then pos = 0 end
			if pos>255 then pos = 255 end
			local text = GraphicsCategory[6]..tostring(GraphicsEntries[6])
			
			RGB[selectedSlider] = pos
			local hex = caoperations:RGBToHex({RGB[3],RGB[2],RGB[1]})
			Color = tonumber(hex)
			GraphicsEntries[6] = "\nRed: "..RGB[1].."\nGreen: "..RGB[2].."\nBlue: "..RGB[3]
			local text2 = GraphicsCategory[6]..tostring(GraphicsEntries[6])
			caoperations:ModifyText(text,text2,nil,nil,nil,0x5cd7f4)
		end
		if selectedSlider and not GetVKInput(mouse1) then
			selectedSlider = nil
		end
	end
	
	
	--change graphics settings
	for i=1,5 do
		local text = GraphicsCategory[i]..tostring(GraphicsEntries[i])
		local buttonRect = {GraphicsInitRect[1],GraphicsInitRect[2]+(i-1)*Increment[1],GraphicsInitRect[1]+#(text)*7,GraphicsInitRect[2]+(i-1)*Increment[1]+10}
		local rect = {GraphicsInitRect[1],GraphicsInitRect[2]+(i-1)*Increment[1],GraphicsInitRect[3],GraphicsInitRect[4]}
				
		if caoperations:RectsOverlap({x-16,y-16,x,y},buttonRect) and GraphicsFont[i] == normalGraphicsFont and not selectedSlider then
			PlaySound("GAME_CLICK")
			GraphicsFont[i] = underlineGraphicsFont
			caoperations:ModifyText(text,text,rect,"left",underlineGraphicsFont,0x5cd7f4)
		end		
				
		if not caoperations:RectsOverlap({x-16,y-16,x,y},buttonRect) and GraphicsFont[i] == underlineGraphicsFont and not selectedSlider then
			GraphicsFont[i] = normalGraphicsFont
			caoperations:ModifyText(text,text,rect,"left",normalGraphicsFont,0x5cd7f4)
		end
				
		if GraphicsFont[i] == underlineGraphicsFont and GetVKInput(mouse1) and not keyPressed then
			PlaySound("GAME_SELECT")
			keyPressed = true
			if i==1 then
				Show = not Show
			elseif i==2 then
				ShowHealthDetails = not ShowHealthDetails
			elseif i==3 then
				Darkness = not Darkness
			elseif i==4 then
				if Lighting=="fancy" then Lighting = "retro"
				else Lighting = "fancy" end
			else
				if Resolution=="4/3" then Resolution = "16/9" ChangeResolution(1280,720)
				elseif Resolution=="16/9" then Resolution = "unforced"
				else Resolution = "4/3" end
				ResTime = true Width = 0
				_ResChange = PlayArea.Right
			end
			GraphicsEntries = {Show, ShowHealthDetails, Darkness, Lighting, Resolution}
			local text2 = GraphicsCategory[i]..tostring(GraphicsEntries[i])
			caoperations:ModifyText(text,text2,rect,"left",underlineGraphicsFont,0x5cd7f4)
		end
	end
	TextOut(tostring(ffi.cast("int*",_nResult[0][1])[1]).." "..tostring(_nResult[0]))
end

function camenu:DifficultyMenu(x,y)
local mouse1 = cagetters:GetVKCode("mouse1")
local PlayArea = cagetters:GetPlayArea()
	for i=1,6 do
		local text = DifficultyCategory[i]
		local mid = (DifficultyInitRect[1]+DifficultyInitRect[3])/2
		local buttonRect = {mid-#(text)*3.5,DifficultyInitRect[2]+(i-1)*Increment[2],mid+#(text)*3.5,DifficultyInitRect[2]+(i-1)*Increment[2]+10}
		local rect = {DifficultyInitRect[1],DifficultyInitRect[2]+(i-1)*Increment[2],DifficultyInitRect[3],DifficultyInitRect[4]}
				
		local color = 0x5cd7f4
		if string.upper(text)==string.upper(_Difficulty) then color = 0x00FF00 end
		
		if caoperations:RectsOverlap({x-16,y-16,x,y},buttonRect) and DifficultyFont[i] == normalGraphicsFont then
			PlaySound("GAME_CLICK")
			DifficultyFont[i] = underlineGraphicsFont
			caoperations:ModifyText(text,text,rect,"center",underlineGraphicsFont,color)
		end		
				
		if not caoperations:RectsOverlap({x-16,y-16,x,y},buttonRect) and DifficultyFont[i] == underlineGraphicsFont then
			DifficultyFont[i] = normalGraphicsFont
			caoperations:ModifyText(text,text,rect,"center",normalGraphicsFont,color)
		end
				
		if DifficultyFont[i] == underlineGraphicsFont and GetVKInput(mouse1) and not keyPressed then
			PlaySound("GAME_SELECT")
			keyPressed = true
			caoperations:ModifyText(_Difficulty,nil,nil,nil,nil,0x5cd7f4)
			_Difficulty = DifficultyCategory[i]
			caoperations:ModifyText(_Difficulty,_Difficulty,rect,"center",nil,0x00ff00)
		end
	end
end

function camenu:ControlsMenu(x,y)
local mouse1 = cagetters:GetVKCode("mouse1")
local PlayArea = cagetters:GetPlayArea()
	for i=1,14 do
		local text = ControlsCategory[controlsPage][i]
		local offsetX, offsetY = 0,0
		if i == 14 then 
			offsetX,offsetY = 350,260 
		else
			text = text..": "..tostring(cagetters:GetVKName(cagetters:GetBoundKey(text)))
		end
		
		local buttonRect = {ControlsInitRect[1]+offsetX,ControlsInitRect[2]+(i-1)*Increment[3]-offsetY,ControlsInitRect[1]+#(text)*7+offsetX,ControlsInitRect[2]+(i-1)*Increment[3]+4-offsetY}
		local rect = {ControlsInitRect[1]+offsetX,ControlsInitRect[2]+(i-1)*Increment[3]-offsetY,ControlsInitRect[3],ControlsInitRect[4]}
		
		if caoperations:RectsOverlap({x-16,y-16,x,y},buttonRect) and ControlsFont[i] == normalGraphicsFont and not getNewKey then
			PlaySound("GAME_CLICK")
			ControlsFont[i] = underlineGraphicsFont
			caoperations:ModifyText(text,text,rect,"left",underlineGraphicsFont)
		end		
				
		if not caoperations:RectsOverlap({x-16,y-16,x,y},buttonRect) and ControlsFont[i] == underlineGraphicsFont and not getNewKey then
			ControlsFont[i] = normalGraphicsFont
			caoperations:ModifyText(text,text,rect,"left",normalGraphicsFont)
		end

		if ControlsFont[i] == underlineGraphicsFont and GetVKInput(mouse1) and not keyPressed and not getNewKey then
			PlaySound("GAME_SELECT")
			keyPressed = true
			if i~=14 then
				index,text2 = i,ControlsCategory[controlsPage][i]..": "..tostring(cagetters:GetVKName(cagetters:GetBoundKey(ControlsCategory[controlsPage][i])))
				getNewKey = true
				scrollWheelUsed = false
				timeDelay = GetTicks()
			else
				if controlsPage==1 then controlsPage = 2
				else controlsPage = 1 end
				camenu:ChangeControlsPage()
			end
		end

		if getNewKey and GetTicks()-timeDelay > 100 then
			local temp = nil
			local k = ffi.new("BYTE[256]")
			ffi.C.GetKeyboardState(k)
			for j=1,165 do
				if k[j]==128 then
					temp = j
					break
				end
				if scrollWheelUsed and ControlsCategory[controlsPage][index]=="Switch Weapon" then
					CanUseScroll = true
					scrollWheelUsed = false
					temp = 0x07
					break
				end
			end
			
			if temp then
				if temp~=0x07 and ControlsCategory[controlsPage][index]=="Switch Weapon" then
					CanUseScroll = false
				end
				
				ControlsFont[index] = normalGraphicsFont
				keybinds[ ControlsCategory[controlsPage][index] ][2] = temp
				
				if controlsPage == 1 then
					casetters:SetInput(ControlsCategory[controlsPage][index],temp)
				end
				
				local text3 = ControlsCategory[controlsPage][index]..": "..tostring(cagetters:GetVKName(temp))
				caoperations:ModifyText(text2,text3,nil,nil,normalGraphicsFont)
				getNewKey = false
			end
		end
	end
end

function camenu:CloseMenu()
	keyPressed = true
	MenuOpened = false
	options = false
	for v,w in pairs(optionDefaults) do
		caoperations:RemoveText(w[1])
	end	
	camenu:ClearOptionsOnScreen()
	
	local dictionary = {"Color","Show","Show health details","Darkness","Lighting","Difficulty","Resolution",
	"Move Left","Move Right","Move Up","Move Down","Jump","Primary Attack","Secondary Attack","Switch Weapon","Lift","Pistol","Magic","Dynamite","Special",
	"Adrenaline","Rage","Help Prompt","Heal","Eat","Drink","Fill Empty Glasses","Buff","Cycle Paladin","Inventory","Toggle Powerup Backward","Trigger Powerup","Toggle Powerup Forward"}
	local value = {caoperations:Hex(Color),Show,ShowHealthDetails,Darkness,Lighting,_Difficulty,Resolution}

	file = io.open(path.."CAFTAConfig.cfg", "r")
	local lines = {}
	local crt = 0
	if file then
		for line in file:lines() do
			table.insert(lines, line)
			crt = crt+1
		end
		io.close(file)
	end
	file = io.open(path.."CAFTAConfig.cfg", "w")
	if file then
		crt = 1
		for v,line in pairs(lines) do
			if crt<=33 and string.find(line,dictionary[crt]) then
				if crt<=7 then
					file:write(dictionary[crt]..":"..tostring(value[crt])..";\n")
				elseif crt>7 and crt<=33 then
					file:write(dictionary[crt]..":"..cagetters:GetVKName(keybinds[dictionary[crt]][2])..";\n")
				end
				crt = crt+1
			else
				file:write(line.."\n")
			end
		end
		io.close(file)
	end
	while (ffi.C.ShowCursor(false)>=0) do end
end

function camenu:ClearOptionsOnScreen()
	controlsPage = 1
	GraphicsMenu,DifficultyMenu,ControlsMenu = false,false,false
	for v,w in pairs(GraphicsCategory) do
		caoperations:RemoveText(w..tostring(GraphicsEntries[v]))
	end	
	for v,w in pairs(DifficultyCategory) do
		caoperations:RemoveText(w)
	end	
	for v,w in pairs(ControlsCategory[1]) do
		if v==14 then
			caoperations:RemoveText(w)
		else
			caoperations:RemoveText(w..": "..tostring(cagetters:GetVKName(cagetters:GetBoundKey(w))))
		end
	end	
	for v,w in pairs(ControlsCategory[2]) do
		if v==14 then
			caoperations:RemoveText(w)
		else
			caoperations:RemoveText(w..": "..tostring(cagetters:GetVKName(cagetters:GetBoundKey(w))))
		end
	end
	caoperations:RemoveText("(This will take effect after restarting the level)")
end

function camenu:ChangeControlsPage()
	for v,w in pairs(ControlsCategory[controlsPage]) do
		local prev = 1
		if controlsPage == 1 then prev = 2
		else prev = 1 end
		local t1 = ControlsCategory[prev][v]
		local t2 = ControlsCategory[controlsPage][v]
		if v~=14 then
			t1 = t1..": "..tostring(cagetters:GetVKName(cagetters:GetBoundKey(t1)))
			t2 = t2..": "..tostring(cagetters:GetVKName(cagetters:GetBoundKey(w)))
		end
		caoperations:ModifyText(t1,t2)
	end
end

function camenu:UpdateTextPos()
local PlayArea = cagetters:GetPlayArea()
	clickBox = {
		{PlayArea.Right/2-280,PlayArea.Bottom/2-108,PlayArea.Right/2-161,PlayArea.Bottom/2-98},
		{PlayArea.Right/2-280,PlayArea.Bottom/2-68,PlayArea.Right/2-161,PlayArea.Bottom/2-58},
		{PlayArea.Right/2-280,PlayArea.Bottom/2-28,PlayArea.Right/2-161,PlayArea.Bottom/2-18},
		{PlayArea.Right/2-265,PlayArea.Bottom/2+80,PlayArea.Right/2-176,PlayArea.Bottom/2+90}
	}
	optionDefaults = {
		{"Graphics",PlayArea.Right/2-280,PlayArea.Bottom/2-108,PlayArea.Right/2-173,PlayArea.Bottom/2},
		{"Difficulty",PlayArea.Right/2-280,PlayArea.Bottom/2-68,PlayArea.Right/2-173,PlayArea.Bottom/2},
		{"Controls",PlayArea.Right/2-280,PlayArea.Bottom/2-28,PlayArea.Right/2-173,PlayArea.Bottom/2},
		{"Exit",PlayArea.Right/2-280,PlayArea.Bottom/2+80,PlayArea.Right/2-173,PlayArea.Bottom/2+100}
	}	
	for i=1,4 do
		fontType[ optionDefaults[i][1] ] = normalFont
		local rect = {optionDefaults[i][2],optionDefaults[i][3],optionDefaults[i][4],optionDefaults[i][5]}
		caoperations:ModifyText(optionDefaults[i][1],optionDefaults[i][1],rect,"center",normalFont,0x5cd7f4)
	end
	for i=1,6 do
		local text = GraphicsCategory[i]..tostring(GraphicsEntries[i])
		local rect = {GraphicsInitRect[1],GraphicsInitRect[2]+(i-1)*Increment[1],GraphicsInitRect[3],GraphicsInitRect[4]}
		GraphicsFont[i] = normalGraphicsFont
		caoperations:ModifyText(text,text,rect,"left",normalGraphicsFont,0x5cd7f4)
	end
end

function camenu:ShowGraphicsSettings()
local PlayArea = cagetters:GetPlayArea()
	for v,w in pairs(GraphicsCategory) do
		caoperations:AddText(w..tostring(GraphicsEntries[v]),{PlayArea.Right/2-150,PlayArea.Bottom/2-108+(v-1)*Increment[1],PlayArea.Right/2+104,PlayArea.Bottom/2+200},"left",2,0x5cd7f4)
	end
end

function camenu:ShowDifficultySettings()
local PlayArea = cagetters:GetPlayArea()
	for v,w in pairs(DifficultyCategory) do
		local color = 0x5cd7f4
		if string.upper(w)==string.upper(_Difficulty) then color = 0x00FF00 end
		caoperations:AddText(w,{PlayArea.Right/2-150,PlayArea.Bottom/2-108+(v-1)*Increment[2],PlayArea.Right/2+281,PlayArea.Bottom/2+100},"center",2,color)
	end
	caoperations:AddText("(This will take effect after restarting the level)",{PlayArea.Right/2-150,PlayArea.Bottom/2+110,PlayArea.Right/2+286,PlayArea.Bottom/2+150},"right",6,0x0000ff)
end

function camenu:ShowControlsSettings()
local PlayArea = cagetters:GetPlayArea()
	for v,w in pairs(ControlsCategory[controlsPage]) do
		if v==14 then
			caoperations:AddText(w,{PlayArea.Right/2+200,PlayArea.Bottom/2-128,PlayArea.Right/2+300,PlayArea.Bottom/2+150},"left",2,0x5cd7f4)
		else
			caoperations:AddText(w..": "..tostring(cagetters:GetVKName(cagetters:GetBoundKey(w))),{PlayArea.Right/2-150,PlayArea.Bottom/2-128+(v-1)*Increment[3],PlayArea.Right/2+286,PlayArea.Bottom/2+150},"left",2,0x5cd7f4)
		end
	end
end

function camenu:CustomOptions()
local claw = GetClaw()
local alt,f1 = cagetters:GetVKCode("alt"), cagetters:GetVKCode("f1")
local mouse1 = cagetters:GetVKCode("mouse1")

local screenx,screeny = cagetters:GetScreen()
local PlayArea = cagetters:GetPlayArea()

local red,green,blue = caoperations:HexToRGB(Color)

	if keyPressed and not GetVKInput(f1) and not GetVKInput(mouse1) then
		keyPressed = false
	end
	
	GraphicsCategory = {"Show enemy health: ","Show enemy health details: ","Darkness effect: ","Lighting: ","Force resolution: ","Color: "}
	GraphicsInitRect = {PlayArea.Right/2-150,PlayArea.Bottom/2-108,PlayArea.Right/2+286,PlayArea.Bottom/2+200}
	GraphicsEntries = {Show, ShowHealthDetails, Darkness, Lighting, Resolution, "\nRed: "..red.."\nGreen: "..green.."\nBlue: "..blue}	
	
	DifficultyCategory = {"Easy","Normal","Hard","Very Hard","Revengeance","Mpcultist"}
	DifficultyInitRect = {PlayArea.Right/2-150,PlayArea.Bottom/2-108,PlayArea.Right/2+281,PlayArea.Bottom/2+100}
	DifficultyEntries = Difficulty	
	
	ControlsCategory = {}
	ControlsCategory[1] = {"Move Left","Move Right","Move Up","Move Down","Jump","Primary Attack","Secondary Attack","Switch Weapon","Lift","Pistol","Magic","Dynamite","Special","Next Page"}
	ControlsCategory[2] = {"Adrenaline","Rage","Help Prompt","Heal","Eat","Drink","Fill Empty Glasses","Buff","Cycle Paladin","Inventory","Toggle Powerup Backward","Trigger Powerup","Toggle Powerup Forward","Prev Page"}
	ControlsInitRect = {PlayArea.Right/2-150,PlayArea.Bottom/2-128,PlayArea.Right/2+286,PlayArea.Bottom/2+150}
	Increment = {30,30,20}
	
--use menu
	if MenuOpened then
		--get mouse pos
		ffi.C.ShowCursor(true)
		local x,y = GetCursorPos().x,GetCursorPos().y
		
		--write on screen the options
		if not options then
			controlsPage = 1
			options = true
			caoperations:AddFont(cagetters:GetFontCount()+1,20,"Verdana Bold")
			caoperations:AddFont(cagetters:GetFontCount()+1,20,"Verdana Bold",0,0,0,true)
			normalFont,underlineFont = cagetters:GetFontCount()-1,cagetters:GetFontCount()

			caoperations:AddFont(cagetters:GetFontCount()+1,18,"Arial Bold",0,0,0,true)
			normalGraphicsFont,underlineGraphicsFont = 2,cagetters:GetFontCount()
			
			caoperations:AddText("Graphics",{PlayArea.Right/2-280,PlayArea.Bottom/2-108,PlayArea.Right/2-173,PlayArea.Bottom/2},"center",underlineFont,0x5cd7f4)
			caoperations:AddText("Difficulty",{PlayArea.Right/2-280,PlayArea.Bottom/2-68,PlayArea.Right/2-173,PlayArea.Bottom/2},"center",normalFont,0x5cd7f4)
			caoperations:AddText("Controls",{PlayArea.Right/2-280,PlayArea.Bottom/2-28,PlayArea.Right/2-173,PlayArea.Bottom/2},"center",normalFont,0x5cd7f4)
			caoperations:AddText("Exit",{PlayArea.Right/2-280,PlayArea.Bottom/2+80,PlayArea.Right/2-173,PlayArea.Bottom/2+100},"center",normalFont,0x5cd7f4)
			
			clickBox = {
				{PlayArea.Right/2-280,PlayArea.Bottom/2-108,PlayArea.Right/2-161,PlayArea.Bottom/2-98},
				{PlayArea.Right/2-280,PlayArea.Bottom/2-68,PlayArea.Right/2-161,PlayArea.Bottom/2-58},
				{PlayArea.Right/2-280,PlayArea.Bottom/2-28,PlayArea.Right/2-161,PlayArea.Bottom/2-18},
				{PlayArea.Right/2-265,PlayArea.Bottom/2+80,PlayArea.Right/2-176,PlayArea.Bottom/2+90}
			}
			optionDefaults = {
				{"Graphics",PlayArea.Right/2-280,PlayArea.Bottom/2-108,PlayArea.Right/2-173,PlayArea.Bottom/2},
				{"Difficulty",PlayArea.Right/2-280,PlayArea.Bottom/2-68,PlayArea.Right/2-173,PlayArea.Bottom/2},
				{"Controls",PlayArea.Right/2-280,PlayArea.Bottom/2-28,PlayArea.Right/2-173,PlayArea.Bottom/2},
				{"Exit",PlayArea.Right/2-280,PlayArea.Bottom/2+80,PlayArea.Right/2-173,PlayArea.Bottom/2+100}
			}
			fontType = {Graphics = underlineFont, Difficulty = normalFont, Controls = normalFont, Exit = normalFont}
			GraphicsFont = {normalGraphicsFont,normalGraphicsFont,normalGraphicsFont,normalGraphicsFont,normalGraphicsFont}
			DifficultyFont = {normalGraphicsFont,normalGraphicsFont,normalGraphicsFont,normalGraphicsFont,normalGraphicsFont,normalGraphicsFont}
			ControlsFont = {}
			for i=1,14 do ControlsFont[i] = normalGraphicsFont end
			
			--show graphics menu upon opening
			keepFont = 1
			camenu:ClearOptionsOnScreen()
			camenu:ShowGraphicsSettings()
			GraphicsMenu = true
		end
		
		--create box
		local box = ffi.C.CreateRectRgn(PlayArea.Right/2-288,PlayArea.Bottom/2-136,PlayArea.Right/2+288,PlayArea.Bottom/2+136)
		ffi.C.FillRgn(hdc, box, tools.stocka)
		
		ffi.C.DeleteObject(box)
		box = nil	
		
		--create vertical bar
		local verticalBar = ffi.C.CreateRectRgn(PlayArea.Right/2-172,PlayArea.Bottom/2-136,PlayArea.Right/2-166,PlayArea.Bottom/2+136)
		ffi.C.FillRgn(hdc, verticalBar, tools.stockc)
		
		ffi.C.DeleteObject(verticalBar)
		verticalBar = nil

		--check mouse pos
		for i=1,4 do
			if caoperations:RectsOverlap({x-16,y-16,x,y},clickBox[i]) and fontType[ optionDefaults[i][1] ] == normalFont then
				PlaySound("GAME_CLICK")
				fontType[ optionDefaults[i][1] ] = underlineFont
				local rect = {optionDefaults[i][2],optionDefaults[i][3],optionDefaults[i][4],optionDefaults[i][5]}
				caoperations:ModifyText(optionDefaults[i][1],optionDefaults[i][1],rect,"center",underlineFont,0x5cd7f4)
			end		
			
			if not caoperations:RectsOverlap({x-16,y-16,x,y},clickBox[i]) and fontType[ optionDefaults[i][1] ] == underlineFont and keepFont ~= i then
				fontType[ optionDefaults[i][1] ] = normalFont
				local rect = {optionDefaults[i][2],optionDefaults[i][3],optionDefaults[i][4],optionDefaults[i][5]}
				caoperations:ModifyText(optionDefaults[i][1],optionDefaults[i][1],rect,"center",normalFont,0x5cd7f4)
			end
			
			--select option
			if caoperations:RectsOverlap({x-16,y-16,x,y},clickBox[i]) and fontType[ optionDefaults[i][1] ] == underlineFont and GetVKInput(mouse1) and not keyPressed then
				if keepFont~=0 then caoperations:ModifyText(optionDefaults[keepFont][1],optionDefaults[keepFont][1],nil,nil,normalFont,nil) end
				keepFont = i
				keyPressed = true
				PlaySound("GAME_SELECT")
				if optionDefaults[i][1]=="Exit" then
					camenu:CloseMenu()
				elseif optionDefaults[i][1]=="Graphics" then
					camenu:ClearOptionsOnScreen()
					camenu:ShowGraphicsSettings()
					GraphicsMenu = true
				elseif optionDefaults[i][1]=="Difficulty" then
					camenu:ClearOptionsOnScreen()
					camenu:ShowDifficultySettings()		
					DifficultyMenu = true
				elseif optionDefaults[i][1]=="Controls" then
					camenu:ClearOptionsOnScreen()
					camenu:ShowControlsSettings()
					ControlsMenu = true
				end
			end
		end
		
		--GraphicsMenu
		if GraphicsMenu then
			camenu:GraphicsMenu(x,y)
		end		
		
		--DifficultyMenu
		if DifficultyMenu then
			camenu:DifficultyMenu(x,y)
		end		

		--ControlsMenu
		if ControlsMenu then
			camenu:ControlsMenu(x,y)
		end
		
		--delete menu
		if GetVKInput(alt) and GetVKInput(f1) and not keyPressed then
			camenu:CloseMenu()
		end
		
		--update text pos after res change
		if _ResChange and _ResChange~=PlayArea.Right then
			_ResChange = PlayArea.Right
			camenu:UpdateTextPos()
		end
	end

--create menu
	if not MenuOpened and GetVKInput(alt) and GetVKInput(f1) and not keyPressed then
		keyPressed = true
		MenuOpened = true
	end	
end


return camenu