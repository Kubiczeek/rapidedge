-- Buse BS100
-- Script Created by nejhransvete


--//Services\\--
local TweenService = game:GetService("TweenService")

--//Variables\\--

--Getting all necessary directories
local srcDirectory = script.Parent
local PPModel = srcDirectory:WaitForChild("PP")
local panelyModel = srcDirectory:WaitForChild("Panely")
local configurationFolder = srcDirectory:WaitForChild("Configuration")
local configModule = configurationFolder:WaitForChild("Config")
local panelyModule = configurationFolder:WaitForChild("PanelData")
local configData = require(configModule)
local panelyData = require(panelyModule)

local ValuesFolder = panelyModel:WaitForChild("Values")
local LinkaValue = ValuesFolder:WaitForChild("Linka")
local KurzValue = ValuesFolder:WaitForChild("Kurz")
local CilValue = ValuesFolder:WaitForChild("CilNum")
local ZonaValue = ValuesFolder:WaitForChild("Zona")
local SmerValue = ValuesFolder:WaitForChild("Smer")

local SurfaceGui = PPModel:WaitForChild("Display"):WaitForChild("SurfaceGui")

local BeepSound = PPModel.Main.Pip

local state = 0
--1 = mainmenu
local input = ""

--//Functions\\--
local function removeWhiteSpaces(str : string) : string
	return string.gsub(tostring(str), "%s+", "")
end

local function setLine(int: number)
	for _, v : Instance in pairs(panelyModel:GetDescendants()) do
		if v.Name == "Num" and v:IsA("TextLabel") then
			v.Text = tostring(int)
		end
	end
	if removeWhiteSpaces(int) ~= "" then
		SurfaceGui.MainMenu.Linka.Text = "L"..int
	else
		SurfaceGui.MainMenu.Linka.Text = "Lprázd"
	end
end

local function setDestination(obj : table, isItLine : boolean, lineNumber, dirNumber)
	isItLine = isItLine or false
	lineNumber = lineNumber or nil
	dirNumber = dirNumber or nil
	if not isItLine then
		local buseInfo = obj.info[1]
		local frontInfo = obj.info[2]
		local sideInfo = obj.info[3]
		panelyModel.Predek.SurfaceGui.Text.Text = frontInfo
		panelyModel.Bok.SurfaceGui.Text.Text = sideInfo
		SurfaceGui.MainMenu.CilText.Text = buseInfo
		SurfaceGui.MainMenu.CilNum.Text = obj.id
	end
end

local function appendNumber(int : number)
	BeepSound:Play()
	local integer = tostring(int)
	input = input .. integer
	input = string.sub(input, 2)
end

local function findCilObject(id : string)
	for _, object in pairs(panelyData.cil) do
		if removeWhiteSpaces(object.id) == removeWhiteSpaces(id) then
			return object
		end
	end
	return {["info"] = {"Cprázd"}}
end

local function findRefCilBySmerAndLine(linka : number, smer : number)
	local line = panelyData.linka[linka] or {["smer"] = "-1"}
	for i, v in line do
		if v.smer == tonumber(smer) then
			return v.refCil
		end
	end
	return nil
end

local function startBuse()
	state = -1
	BeepSound:Play()
	PPModel.Display.Material = Enum.Material.Neon
	local loadingTable = SurfaceGui:FindFirstChild("Loading"):GetChildren()
	for _, textElement : TextLabel in pairs(loadingTable) do
		textElement.Visible = true
	end
	task.wait(3.4)
	for _, textElement : TextLabel in pairs(loadingTable) do
		textElement.Visible = false
	end
	task.wait(0.25)
	for _, textElement : TextLabel in pairs(SurfaceGui:FindFirstChild("MainMenu"):GetChildren()) do
		textElement.Visible = true
	end
	state = 1
end

local function setNum1()
	BeepSound:Play()
	local linka = SurfaceGui:FindFirstChild("Header").Linka
	local kurz = SurfaceGui:FindFirstChild("Header").Kurz
	local tempLinka
	input = "   "
	state = 2
	linka.Visible = true
	repeat
		linka.Text = "Linka: >"..input.."<"
		task.wait()
		if state == 1 then
			return
		end
	until state == 3
	linka.Visible = false
	tempLinka = input
	input = "     "
	kurz.Visible = true
	repeat
		kurz.Text = "Kurz: >"..input.."<"
		task.wait()
		if state == 1 then
			return
		end
	until state == 4
	KurzValue.Value = input
	LinkaValue.Value = tempLinka
	kurz.Visible = false
	input = ""
	state = 1
end

local function setNum2()
	BeepSound:Play()
	local cil = SurfaceGui:FindFirstChild("Header").Cil
	input = "   "
	state = 5
	cil.Visible = true
	local savedCilText = SurfaceGui.MainMenu.CilText.Text
	local savedCilNum = SurfaceGui.MainMenu.CilNum.Text
	repeat
		cil.Text = "Cil: >"..input.."<"
		task.wait()
		local obj = findCilObject(input)
		SurfaceGui.MainMenu.CilText.Text = obj.info[1]
		SurfaceGui.MainMenu.CilNum.Text = tonumber(input) or "000"
		if state == 1 then
			SurfaceGui.MainMenu.CilText.Text = savedCilText
			SurfaceGui.MainMenu.CilNum.Text = savedCilNum
			return
		end
	until state == 6
	CilValue.Value = input
	cil.Visible = false
	input = ""
	state = 1
end

local function setNum5()
	BeepSound:Play()
	local pasmo = SurfaceGui:FindFirstChild("Header").Pasmo
	input = "   "
	state = 7
	pasmo.Visible = true
	repeat
		pasmo.Text = "Zóna: >"..input.."<"
		task.wait()
		if state == 1 then
			return
		end
	until state == 8
	ZonaValue.Value = input
	pasmo.Visible = false
	input = ""
	state = 1
end

local function setNum6()
	BeepSound:Play()
	local smer = SurfaceGui:FindFirstChild("Header").Smer
	input = "  "
	state = 9
	smer.Visible = true
	local savedCilText = SurfaceGui.MainMenu.CilText.Text
	local savedCilNum = SurfaceGui.MainMenu.CilNum.Text
	repeat
		smer.Text = "Směr: >"..input.."<"
		task.wait()
		local cil = findRefCilBySmerAndLine(LinkaValue.Value, input)
		local obj = findCilObject(cil)
		SurfaceGui.MainMenu.CilText.Text = obj.info[1]
		SurfaceGui.MainMenu.CilNum.Text = cil or "000"
		if state == 1 then
			SurfaceGui.MainMenu.CilText.Text = savedCilText
			SurfaceGui.MainMenu.CilNum.Text = savedCilNum
			return
		end
	until state == 10
	SmerValue.Value = input
	smer.Visible = false
	input = ""
	state = 1
end

local function incrementInput()
	local inputLength = string.len(input)
	local inputInt = tonumber(input) or 0
	if inputInt >= 999 then
		input = "999"
	else
		input = tostring(inputInt + 1)
		if string.len(input) ~= inputLength then
			input = string.rep(" ", inputLength - string.len(input))..input
		end
	end
end

local function decrementInput()
	local inputLength = string.len(input)
	local inputInt = tonumber(input) or 0
	if inputInt <= 0 then
		input = "  0"
	else
		input = tostring(inputInt - 1)
		if string.len(input) ~= inputLength then
			input = string.rep(" ", inputLength - string.len(input))..input
		end
	end
end

local function turnOffSystem()
	BeepSound:Play()
	local turnOff = SurfaceGui:FindFirstChild("Header").Emergency
	turnOff.Visible = true
	state = 1000
	repeat
		task.wait()
		if state == 1 then
			return
		end
	until state == 1001
	turnOff.Visible = false
	for _, textElement : TextLabel in pairs(SurfaceGui:FindFirstChild("MainMenu"):GetChildren()) do
		textElement.Visible = false
	end
	PPModel.Display.Material = Enum.Material.SmoothPlastic
	state = 0
end

--//Events\\--
PPModel.Buttons.Potvrz.ClickDetector.MouseClick:Connect(function()
	if state > 1 then
		BeepSound:Play()
		state = state + 1
	end
end)

PPModel.Buttons.Zrus.ClickDetector.MouseClick:Connect(function()
	if state > 1 then
		BeepSound:Play()
		for _, textElement : TextLabel in pairs(SurfaceGui:FindFirstChild("Header"):GetChildren()) do
			textElement.Visible = false
		end
		input = ""
		state = 1
	end
end)

PPModel.Buttons.Num0.ClickDetector.MouseClick:Connect(function()
	if state == 0 then
		startBuse()
	elseif state > 1 then
		appendNumber(0)
	end
end)

PPModel.Buttons.Num1.ClickDetector.MouseClick:Connect(function()
	if state == 1 then
		setNum1()
	elseif state > 1 then
		appendNumber(1)
	end
end)

PPModel.Buttons.Num2.ClickDetector.MouseClick:Connect(function()
	if state == 1 then
		setNum2()
	elseif state > 1 then
		appendNumber(2)
	end
end)

PPModel.Buttons.Num3.ClickDetector.MouseClick:Connect(function()
	if state > 1 then
		appendNumber(3)
	end
end)

PPModel.Buttons.Num4.ClickDetector.MouseClick:Connect(function()
	if state > 1 then	
		appendNumber(4)
	end
end)

PPModel.Buttons.Num5.ClickDetector.MouseClick:Connect(function()
	if state == 1 then
		setNum5()
	elseif state > 1 then
		appendNumber(5)
	end
end)

PPModel.Buttons.Num6.ClickDetector.MouseClick:Connect(function()
	if state == 1 then
		setNum6()
	elseif state > 1 then
		appendNumber(6)	
	end
end)

PPModel.Buttons.Num7.ClickDetector.MouseClick:Connect(function()
	if state > 1 then
		appendNumber(7)
	end
end)

PPModel.Buttons.Num8.ClickDetector.MouseClick:Connect(function()
	if state > 1 then
		appendNumber(8)
	end
end)

PPModel.Buttons.Num9.ClickDetector.MouseClick:Connect(function()
	if state > 1 then
		appendNumber(9)
	end
end)

PPModel.Buttons.Emerg.ClickDetector.MouseClick:Connect(function()
	if state == 1 then
		turnOffSystem()
	end
end)

PPModel.Buttons.Up.ClickDetector.MouseClick:Connect(function()
	if state > 1 then
		BeepSound:Play()
		incrementInput()
	end
end)

PPModel.Buttons.Down.ClickDetector.MouseClick:Connect(function()
	if state > 1 then
		BeepSound:Play()
		decrementInput()
	end
end)

LinkaValue:GetPropertyChangedSignal("Value"):Connect(function()
	setLine(LinkaValue.Value)
end)

CilValue:GetPropertyChangedSignal("Value"):Connect(function()
	if CilValue.Value ~= "nil" then
		SmerValue.Value = "nil"
		setDestination(findCilObject(CilValue.Value))
	end
end)

ZonaValue:GetPropertyChangedSignal("Value"):Connect(function()
	SurfaceGui.MainMenu.Zona.Text = "Z"..ZonaValue.Value
end)

SmerValue:GetPropertyChangedSignal("Value"):Connect(function()
	if SmerValue.Value ~= "nil" then
		CilValue.Value = "nil"
		local cil = findRefCilBySmerAndLine(LinkaValue.Value, SmerValue.Value)
		setDestination(findCilObject(cil))
	end
end)

--//Initialize\\--
