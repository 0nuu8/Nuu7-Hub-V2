local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local GUI_NAME = "NUU7_HUB"
local oldGui = PlayerGui:FindFirstChild(GUI_NAME)
if oldGui then
	oldGui:Destroy()
end
if shared.NUU7Hub and type(shared.NUU7Hub.Destroy) == "function" then
	pcall(shared.NUU7Hub.Destroy)
end

----------------------------------------------------------------
-- CONFIGURACIÓN CENTRAL
----------------------------------------------------------------
local Config = {
	HubName = "NUU7 HUB",
	LogoImage = "rbxassetid://92548753285325", -- Logo genérico por defecto
	AccentColor = Color3.fromRGB(90, 170, 255),
	DefaultPage = "NuShoot",
	ToggleKey = Enum.KeyCode.RightControl,
	ShowPlayerProfile = true,
	EnableAnimations = true,
	ShowFPS = true,
	AllowEnvironmentPreview = true,
	FPSUpdateInterval = 0.5,

	Window = {
		Width = 580,
		Height = 340,
		MarginX = 24,
		MarginY = 24,
		SidebarWidth = 150,
		SidebarCompactWidth = 56,
		CompactBelow = 520,
	},

	Pages = {
		{ Id = "NuShoot", Title = "NuShoot", Icon = "", Description = "Modo de disparo, detección y FOV." },
		{ Id = "ESP", Title = "ESP", Icon = "", Description = "Representación visual de objetivos y colores." },
		{ Id = "Hitbox", Title = "Hitbox", Icon = "", Description = "Detección, FOV y partes del cuerpo." },
		{ Id = "Settings", Title = "Settings", Icon = "", Description = "Temas, entorno e interfaz." },
		{ Id = "Avatar", Title = "Avatar", Icon = "", Description = "Personaliza tu tarjeta de perfil." },
	},

	BodyParts = {
		{ Name = "Head" },
		{ Name = "HumanoidRootPart" },
		{ Name = "Torso" },
		{ Name = "UpperTorso" },
		{ Name = "LowerTorso" },
		{ Name = "Left Arm" },
		{ Name = "Right Arm" },
		{ Name = "Left Leg" },
		{ Name = "Right Leg" },
		{ Name = "LeftUpperArm" },
		{ Name = "LeftLowerArm" },
		{ Name = "LeftHand" },
		{ Name = "RightUpperArm" },
		{ Name = "RightLowerArm" },
		{ Name = "RightHand" },
		{ Name = "LeftUpperLeg" },
		{ Name = "LeftLowerLeg" },
		{ Name = "LeftFoot" },
		{ Name = "RightUpperLeg" },
		{ Name = "RightLowerLeg" },
		{ Name = "RightFoot" },
	},
}

----------------------------------------------------------------
-- TEMA
----------------------------------------------------------------
local Theme = {
	Background = Color3.fromHex("08090B"),
	Surface = Color3.fromHex("111318"),
	SurfaceSecondary = Color3.fromHex("17191F"),
	SurfaceHover = Color3.fromHex("1D2028"),
	Border = Color3.new(1, 1, 1),
	BorderTransparency = 0.92,
	PrimaryText = Color3.fromHex("F5F5F7"),
	SecondaryText = Color3.fromHex("A1A1AA"),
	Accent = Config.AccentColor,
	Success = Color3.fromRGB(80, 210, 120),
	Danger = Color3.fromRGB(255, 90, 90),
	ToggleOff = Color3.fromHex("2A2D36"),
	TrackBar = Color3.fromHex("2A2D36"),
	Knob = Color3.fromHex("F5F5F7"),

	FontRegular = Enum.Font.Gotham,
	FontMedium = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,

	CornerLarge = 14,
	CornerMedium = 10,
	CornerSmall = 6,
}

local ThemePresets = {
	Default = {
		Label = "Default",
		Accent = Color3.fromRGB(90, 170, 255),
		Preview = { Color3.fromRGB(8, 9, 11), Color3.fromRGB(23, 25, 31), Color3.fromRGB(90, 170, 255) },
		Lighting = nil,
	},
	Tokoyami = {
		Label = "Tokoyami",
		Accent = Color3.fromRGB(255, 150, 80),
		Preview = { Color3.fromRGB(40, 22, 18), Color3.fromRGB(255, 150, 80), Color3.fromRGB(255, 210, 160) },
		Lighting = {
			ClockTime = 18,
			Ambient = Color3.fromRGB(120, 85, 70),
			OutdoorAmbient = Color3.fromRGB(150, 105, 80),
			FogColor = Color3.fromRGB(255, 170, 120),
			FogStart = 40,
			FogEnd = 450,
		},
	},
	Night = {
		Label = "Night",
		Accent = Color3.fromRGB(110, 120, 255),
		Preview = { Color3.fromRGB(6, 8, 24), Color3.fromRGB(110, 120, 255), Color3.fromRGB(0, 255, 220) },
		Lighting = {
			ClockTime = 0,
			Ambient = Color3.fromRGB(30, 35, 70),
			OutdoorAmbient = Color3.fromRGB(25, 30, 60),
			FogColor = Color3.fromRGB(10, 12, 35),
			FogStart = 80,
			FogEnd = 900,
		},
	},
	Pink = {
		Label = "Pink",
		Accent = Color3.fromRGB(255, 90, 200),
		Preview = { Color3.fromRGB(30, 10, 40), Color3.fromRGB(255, 90, 200), Color3.fromRGB(150, 90, 255) },
		Lighting = {
			ClockTime = 19,
			Ambient = Color3.fromRGB(110, 60, 130),
			OutdoorAmbient = Color3.fromRGB(140, 70, 150),
			FogColor = Color3.fromRGB(190, 80, 200),
			FogStart = 60,
			FogEnd = 700,
		},
	},
}

----------------------------------------------------------------
-- UTILIDADES
----------------------------------------------------------------
local Utils = {}

function Utils.Clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

function Utils.Snap(value, step, min)
	local snapped = min + math.floor((value - min) / step + 0.5) * step
	return math.floor(snapped * 1000000 + 0.5) / 1000000
end

function Utils.DeepCopy(value)
	if type(value) ~= "table" then
		return value
	end
	local copy = {}
	for k, v in pairs(value) do
		copy[k] = Utils.DeepCopy(v)
	end
	return copy
end

function Utils.SafeCall(fn, ...)
	if type(fn) ~= "function" then
		return false
	end
	local ok, err = pcall(fn, ...)
	if not ok then
		warn("[NUU7 HUB] Error controlado: " .. tostring(err))
	end
	return ok
end

function Utils.Require(options, key, expectedType, caller)
	if type(options) ~= "table" then
		error(("[NUU7 HUB] %s: se esperaba una tabla de opciones"):format(caller or "?"), 3)
	end
	if typeof(options[key]) ~= expectedType then
		error(("[NUU7 HUB] %s: '%s' debe ser de tipo %s"):format(caller or "?", key, expectedType), 3)
	end
end

function Utils.GetViewport()
	local camera = workspace.CurrentCamera
	if camera then
		return camera.ViewportSize
	end
	return Vector2.new(1280, 720)
end

function Utils.GetAvailableBodyParts(model)
	local result = {}
	for _, def in ipairs(Config.BodyParts) do
		if not model then
			table.insert(result, def.Name)
		else
			local part = model:FindFirstChild(def.Name)
			if part and part:IsA("BasePart") then
				table.insert(result, def.Name)
			end
		end
	end
	if #result == 0 then
		for _, def in ipairs(Config.BodyParts) do
			table.insert(result, def.Name)
		end
	end
	return result
end

function Utils.ColorToHex(color)
	return string.format(
		"#%02X%02X%02X",
		math.floor(color.R * 255 + 0.5),
		math.floor(color.G * 255 + 0.5),
		math.floor(color.B * 255 + 0.5)
	)
end

function Utils.New(className, props, children)
	local instance = Instance.new(className)
	local parent = nil
	if props then
		for k, v in pairs(props) do
			if k == "Parent" then
				parent = v
			else
				instance[k] = v
			end
		end
	end
	if children then
		for _, child in ipairs(children) do
			child.Parent = instance
		end
	end
	if parent then
		instance.Parent = parent
	end
	return instance
end

function Utils.Corner(parent, radius)
	return Utils.New("UICorner", { CornerRadius = UDim.new(0, radius or Theme.CornerMedium), Parent = parent })
end

function Utils.Stroke(parent, transparency, thickness, color)
	return Utils.New("UIStroke", {
		Color = color or Theme.Border,
		Transparency = transparency or Theme.BorderTransparency,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

function Utils.Padding(parent, left, top, right, bottom)
	return Utils.New("UIPadding", {
		PaddingLeft = UDim.new(0, left or 0),
		PaddingTop = UDim.new(0, top or left or 0),
		PaddingRight = UDim.new(0, right or left or 0),
		PaddingBottom = UDim.new(0, bottom or top or left or 0),
		Parent = parent,
	})
end

function Utils.List(parent, padding, direction, horizontalAlignment, verticalAlignment)
	return Utils.New("UIListLayout", {
		Padding = UDim.new(0, padding or 0),
		FillDirection = direction or Enum.FillDirection.Vertical,
		HorizontalAlignment = horizontalAlignment or Enum.HorizontalAlignment.Left,
		VerticalAlignment = verticalAlignment or Enum.VerticalAlignment.Top,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parent,
	})
end

function Utils.Label(props)
	return Utils.New("TextLabel", {
		Name = props.Name or "Label",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = props.Font or Theme.FontRegular,
		Text = props.Text or "",
		TextColor3 = props.Color or Theme.PrimaryText,
		TextSize = props.Size or 13,
		TextXAlignment = props.AlignX or Enum.TextXAlignment.Left,
		TextYAlignment = props.AlignY or Enum.TextYAlignment.Center,
		TextTruncate = props.Truncate or Enum.TextTruncate.None,
		TextWrapped = props.Wrapped or false,
		AutomaticSize = props.AutoSize or Enum.AutomaticSize.None,
		Size = props.Frame or UDim2.new(1, 0, 0, 16),
		Position = props.Position or UDim2.new(0, 0, 0, 0),
		AnchorPoint = props.AnchorPoint or Vector2.new(0, 0),
		LayoutOrder = props.LayoutOrder or 0,
		Parent = props.Parent,
	})
end

----------------------------------------------------------------
-- MAID (LIMPIEZA DE CONEXIONES E INSTANCIAS)
----------------------------------------------------------------
local Maid = {}
Maid.__index = Maid

function Maid.new()
	return setmetatable({ _tasks = {} }, Maid)
end

function Maid:Give(task)
	table.insert(self._tasks, task)
	return task
end

function Maid:Clean()
	local tasks = self._tasks
	self._tasks = {}
	for i = #tasks, 1, -1 do
		local item = tasks[i]
		local kind = typeof(item)
		if kind == "RBXScriptConnection" then
			item:Disconnect()
		elseif kind == "Instance" then
			item:Destroy()
		elseif kind == "function" then
			pcall(item)
		elseif kind == "table" then
			if type(item.Disconnect) == "function" then
				pcall(item.Disconnect, item)
			elseif type(item.Clean) == "function" then
				pcall(item.Clean, item)
			elseif type(item.Destroy) == "function" then
				pcall(item.Destroy, item)
			end
		end
	end
end

local RootMaid = Maid.new()

----------------------------------------------------------------
-- ESTADO ÚNICO (SETTINGS) Y STORE
----------------------------------------------------------------
local Defaults = {
	-- Configuración de la mecánica de juego
	NuShoot = false,
	ClickShot = false,
	DetectionPoints = 10,
	FOVEnabled = false,
	FOVSize = 200,
	ESPEnabled = false,
	AllyESP = false,
	OutlineColor = Color3.fromRGB(0, 255, 255),
	AllyOutlineColor = Color3.fromRGB(90, 220, 100),
	SelectedBodyParts = {},
	GameTime = 14,
	CurrentTheme = "Default",

	-- Preferencias visuales
	AnimationsEnabled = Config.EnableAnimations,
	ShowProfile = Config.ShowPlayerProfile,
	ShowFPS = Config.ShowFPS,
	AccentColor = Config.AccentColor,
	AvatarShape = "Circle",
	AvatarSize = 64,
}

local Limits = {
	DetectionPoints = { Min = 1, Max = 50, Step = 1 },
	FOVSize = { Min = 100, Max = 500, Step = 1 },
	GameTime = { Min = 0, Max = 24, Step = 1 },
	AvatarSize = { Min = 40, Max = 96, Step = 1 },
}

local VisualKeys = {
	"AnimationsEnabled",
	"ShowProfile",
	"ShowFPS",
	"AccentColor",
	"AvatarShape",
	"AvatarSize",
}

local Settings = Utils.DeepCopy(Defaults)

-- Estado de la interfaz (separado de las preferencias)
local UIState = {
	CurrentPage = Config.DefaultPage,
	Minimized = false,
	Open = true,
	Destroyed = false,
}

local Store = {}
local listeners = {}
local allListeners = {}

local function fireChange(key, value)
	local bucket = listeners[key]
	if bucket then
		local snapshot = table.clone(bucket)
		for _, fn in ipairs(snapshot) do
			if table.find(bucket, fn) then
			(Utils.SafeCall)(fn, Utils.DeepCopy(value))
			end
		end
	end
	local snapshotAll = table.clone(allListeners)
	for _, fn in ipairs(snapshotAll) do
		if table.find(allListeners, fn) then
			(Utils.SafeCall)(fn, key, Utils.DeepCopy(value))
		end
	end
end

local function makeConnection(bucket, fn)
	local connected = true
	return {
		Disconnect = function()
			if not connected then
				return
			end
			connected = false
			local index = table.find(bucket, fn)
			if index then
				table.remove(bucket, index)
			end
		end,
	}
end

function Store.Get(key)
	return Utils.DeepCopy(Settings[key])
end

function Store.Set(key, value)
	local default = Defaults[key]
	if default == nil then
		warn("[NUU7 HUB] Clave de configuración desconocida: " .. tostring(key))
		return false
	end
	if typeof(value) ~= typeof(default) then
		warn(("[NUU7 HUB] Tipo inválido para '%s'"):format(tostring(key)))
		return false
	end
	local limit = Limits[key]
	if limit then
		value = Utils.Clamp(value, limit.Min, limit.Max)
		if limit.Step then
			value = Utils.Clamp(Utils.Snap(value, limit.Step, limit.Min), limit.Min, limit.Max)
		end
	end
	if typeof(value) == "table" then
		value = Utils.DeepCopy(value)
	elseif Settings[key] == value then
		return false
	end
	Settings[key] = value
	fireChange(key, value)
	return true
end

function Store.Bind(key, fn, maid)
	if Defaults[key] == nil then
		error("[NUU7 HUB] Bind: clave desconocida '" .. tostring(key) .. "'", 2)
	end
	listeners[key] = listeners[key] or {}
	table.insert(listeners[key], fn)
	local connection = makeConnection(listeners[key], fn)
	if maid then
		maid:Give(connection)
	end
	(Utils.SafeCall)(fn, Utils.DeepCopy(Settings[key]))
	return connection
end

function Store.BindAll(fn, maid)
	table.insert(allListeners, fn)
	local connection = makeConnection(allListeners, fn)
	if maid then
		maid:Give(connection)
	end
	return connection
end

function Store.ResetKeys(keys)
	for _, key in ipairs(keys) do
		local default = Defaults[key]
		if default ~= nil then
			if typeof(default) == "table" then
				Settings[key] = Utils.DeepCopy(default)
				fireChange(key, Settings[key])
			else
				Store.Set(key, default)
			end
		end
	end
end

function Store.ResetAll()
	local keys = {}
	for key in pairs(Defaults) do
		table.insert(keys, key)
	end
	Store.ResetKeys(keys)
end

function Store.ResetVisual()
	Store.ResetKeys(VisualKeys)
end

----------------------------------------------------------------
-- SISTEMA DE ANIMACIÓN
----------------------------------------------------------------
local Anim = {}

Anim.Infos = {
	Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Normal = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Slow = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
}

local activeTweens = setmetatable({}, { __mode = "k" })

function Anim.Tween(instance, props, speed)
	if not instance then
		return nil
	end
	activeTweens[instance] = activeTweens[instance] or {}
	local registry = activeTweens[instance]

	if not Settings.AnimationsEnabled then
		for property, value in pairs(props) do
			local running = registry[property]
			if running then
				running:Cancel()
				registry[property] = nil
			end
			instance[property] = value
		end
		return nil
	end

	local info = Anim.Infos[speed or "Normal"] or Anim.Infos.Normal
	local lastTween = nil
	for property, value in pairs(props) do
		local running = registry[property]
		if running then
			running:Cancel()
		end
		local tween = TweenService:Create(instance, info, { [property] = value })
		registry[property] = tween
		tween.Completed:Once(function()
			if registry[property] == tween then
				registry[property] = nil
			end
		end)
		tween:Play()
		lastTween = tween
	end
	return lastTween
end

function Anim.Stop(instance)
	local registry = activeTweens[instance]
	if registry then
		for property, tween in pairs(registry) do
			tween:Cancel()
			registry[property] = nil
		end
	end
end

----------------------------------------------------------------
-- TABLA DE INTERFAZ
----------------------------------------------------------------
local UI = {
	Refs = {},
	Pages = {},
	SidebarButtons = {},
	Thumbs = {},
	ToastCounter = 0,
	Compact = false,
}

----------------------------------------------------------------
-- COMPONENTES BASE
----------------------------------------------------------------
Store.Bind("AccentColor", function(color)
	Theme.Accent = color
end, RootMaid)

function UI.OnAccent(maid, fn)
	return Store.Bind("AccentColor", function()
		fn(Theme.Accent)
	end, maid)
end

local function nextOrder(parent)
	local n = (parent:GetAttribute("NextOrder") or 0) + 1
	parent:SetAttribute("NextOrder", n)
	return n
end
UI.NextOrder = nextOrder

function UI.AttachButtonFx(button, maid, baseColor, hoverColor, onState)
	local scale = Utils.New("UIScale", { Parent = button })
	local hovering = false
	local pressed = false
	local touchOnly = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

	local function refresh()
		if baseColor and hoverColor then
			(Anim.Tween)(button, { BackgroundColor3 = (hovering or pressed) and hoverColor or baseColor }, "Fast")
		end
		if onState then
			(Utils.SafeCall)(onState, hovering, pressed)
		end
	end

	local function release()
		pressed = false
		if touchOnly then
			hovering = false
		end
		(Anim.Tween)(scale, { Scale = 1 }, "Fast")
		refresh()
	end

	maid:Give(button.MouseEnter:Connect(function()
		hovering = true
		refresh()
	end))
	maid:Give(button.MouseLeave:Connect(function()
		hovering = false
		release()
	end))
	maid:Give(button.MouseButton1Down:Connect(function()
		pressed = true
		(Anim.Tween)(scale, { Scale = 0.97 }, "Fast")
		refresh()
	end))
	maid:Give(button.InputEnded:Connect(function(input)
		local t = input.UserInputType
		if t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch then
			release()
		end
	end))
	return scale
end

function UI.CreateSection(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateSection")
	Utils.Require(opts, "Title", "string", "CreateSection")
	local section = Utils.New("Frame", {
		Name = "Section_" .. opts.Title,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = nextOrder(opts.Parent),
		Parent = opts.Parent,
	})
	Utils.List(section, 8)
	Utils.Label({
		Parent = section,
		Name = "Title",
		Text = opts.Title,
		Font = Theme.FontBold,
		Size = 11,
		Color = Theme.SecondaryText,
		Frame = UDim2.new(1, 0, 0, 16),
		LayoutOrder = -2,
	})
	Utils.New("Frame", {
		Name = "Divider",
		BackgroundColor3 = Theme.Border,
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		LayoutOrder = -1,
		Parent = section,
	})
	return section
end

function UI.CreateCard(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateCard")
	local maid = opts.Maid or RootMaid
	local clickable = opts.Clickable == true
	local rightWidth = opts.RightWidth or 0

	local card = Utils.New(clickable and "TextButton" or "Frame", {
		Name = "Card",
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = nextOrder(opts.Parent),
		Parent = opts.Parent,
	})
	if clickable then
		card.AutoButtonColor = false
		card.Text = ""
	end
	Utils.Corner(card, Theme.CornerMedium)
	local stroke = Utils.Stroke(card)
	Utils.Padding(card, 12, 10, 12, 10)
	Utils.List(card, 10)

	local header = Utils.New("Frame", {
		Name = "Header",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		Parent = card,
	})
	Utils.New("UISizeConstraint", { MinSize = Vector2.new(0, 34), Parent = header })

	local gap = rightWidth > 0 and (rightWidth + 12) or 0
	local textColumn = Utils.New("Frame", {
		Name = "Text",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, -gap, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = header,
	})
	Utils.List(textColumn, 2)

	Utils.Label({
		Parent = textColumn,
		Name = "Title",
		Text = opts.Title or "",
		Font = Theme.FontMedium,
		Size = 13,
		Color = Theme.PrimaryText,
		Frame = UDim2.new(1, 0, 0, 0),
		AutoSize = Enum.AutomaticSize.Y,
		Wrapped = true,
		LayoutOrder = 1,
	})
	if opts.Description and opts.Description ~= "" then
		Utils.Label({
			Parent = textColumn,
			Name = "Description",
			Text = opts.Description,
			Font = Theme.FontRegular,
			Size = 11,
			Color = Theme.SecondaryText,
			Frame = UDim2.new(1, 0, 0, 0),
			AutoSize = Enum.AutomaticSize.Y,
			Wrapped = true,
			LayoutOrder = 2,
		})
	end

	local right = Utils.New("Frame", {
		Name = "Right",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.new(0, rightWidth, 0, 34),
		Parent = header,
	})

	if clickable then
		UI.AttachButtonFx(card, maid, Theme.Surface, Theme.SurfaceHover)
	end

	return card, right, stroke
end

function UI.CreateToggle(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateToggle")
	Utils.Require(opts, "Title", "string", "CreateToggle")
	if opts.Key ~= nil and Defaults[opts.Key] == nil then
		error("[NUU7 HUB] CreateToggle: clave desconocida '" .. tostring(opts.Key) .. "'", 2)
	end
	local maid = opts.Maid or RootMaid

	local card, right = UI.CreateCard({
		Parent = opts.Parent,
		Title = opts.Title,
		Description = opts.Description,
		RightWidth = 46,
		Clickable = true,
		Maid = maid,
	})

	local track = Utils.New("Frame", {
		Name = "Track",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(44, 24),
		BackgroundColor3 = Theme.ToggleOff,
		BorderSizePixel = 0,
		Parent = right,
	})
	Utils.Corner(track, 12)
	local knob = Utils.New("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.fromOffset(18, 18),
		BackgroundColor3 = Theme.Knob,
		BorderSizePixel = 0,
		Parent = track,
	})
	Utils.Corner(knob, 9)

	local value = false
	local initialized = false

	local function render(v, animate)
		local position = UDim2.new(0, v and 23 or 3, 0.5, 0)
		local color = v and Theme.Accent or Theme.ToggleOff
		if animate then
			(Anim.Tween)(knob, { Position = position }, "Normal")
			(Anim.Tween)(track, { BackgroundColor3 = color }, "Normal")
		else
			Anim.Stop(knob)
			Anim.Stop(track)
			knob.Position = position
			track.BackgroundColor3 = color
		end
	end

	if opts.Key then
		Store.Bind(opts.Key, function(v)
			local changed = (v ~= value)
			value = v
			render(v, initialized and changed)
		end, maid)
	else
		value = opts.Default == true
		render(value, false)
	end
	initialized = true

	UI.OnAccent(maid, function()
		render(value, false)
	end)

	maid:Give(card.Activated:Connect(function()
		local newValue = not value
		if opts.Key then
			Store.Set(opts.Key, newValue)
		else
			value = newValue
			render(newValue, true)
		end
		(Utils.SafeCall)(opts.Callback, newValue)
	end))

	local api = { Instance = card }
	function api.Get()
		return value
	end
	function api.Set(v)
		v = v == true
		if opts.Key then
			Store.Set(opts.Key, v)
		else
			value = v
			render(v, true)
		end
	end
	return api
end

function UI.CreateTrack(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateTrack")
	Utils.Require(opts, "Min", "number", "CreateTrack")
	Utils.Require(opts, "Max", "number", "CreateTrack")
	local maid = opts.Maid or RootMaid
	local min, max = opts.Min, opts.Max
	local step = opts.Step or 1

	local hit = Utils.New("Frame", {
		Name = "SliderTrack",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true,
		Size = UDim2.new(1, 0, 0, 24),
		LayoutOrder = opts.LayoutOrder or 2,
		Parent = opts.Parent,
	})
	local bar = Utils.New("Frame", {
		Name = "Bar",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 0, 4),
		BackgroundColor3 = Theme.TrackBar,
		BorderSizePixel = 0,
		Parent = hit,
	})
	Utils.Corner(bar, 2)
	local fill = Utils.New("Frame", {
		Name = "Fill",
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Parent = bar,
	})
	Utils.Corner(fill, 2)
	local knob = Utils.New("Frame", {
		Name = "Knob",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = Theme.Knob,
		BorderSizePixel = 0,
		Parent = hit,
	})
	Utils.Corner(knob, 9)

	local value = min
	local dragging = false

	local function render(v, animate)
		local alpha = (max > min) and ((v - min) / (max - min)) or 0
		if animate then
			(Anim.Tween)(fill, { Size = UDim2.new(alpha, 0, 1, 0) }, "Fast")
			(Anim.Tween)(knob, { Position = UDim2.new(alpha, 0, 0.5, 0) }, "Fast")
		else
			Anim.Stop(fill)
			Anim.Stop(knob)
			fill.Size = UDim2.new(alpha, 0, 1, 0)
			knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		end
	end

	UI.OnAccent(maid, function(color)
		fill.BackgroundColor3 = color
	end)

	local moveConn, endConn, scroller

	local function stopDrag(silent)
		dragging = false
		if moveConn then
			moveConn:Disconnect()
			moveConn = nil
		end
		if endConn then
			endConn:Disconnect()
			endConn = nil
		end
		if scroller then
			scroller.ScrollingEnabled = true
			scroller = nil
		end
		if not silent then
			(Anim.Tween)(knob, { Size = UDim2.fromOffset(14, 14) }, "Fast")
		end
	end

	local function fromX(x)
		local width = hit.AbsoluteSize.X
		if width <= 0 then
			return
		end
		local alpha = Utils.Clamp((x - hit.AbsolutePosition.X) / width, 0, 1)
		local v = Utils.Clamp(Utils.Snap(min + alpha * (max - min), step, min), min, max)
		if v ~= value then
			value = v
			render(v, false)
			(Utils.SafeCall)(opts.OnChanged, v)
		end
	end

	maid:Give(hit.InputBegan:Connect(function(input)
		local t = input.UserInputType
		if t ~= Enum.UserInputType.MouseButton1 and t ~= Enum.UserInputType.Touch then
			return
		end
		stopDrag(true)
		dragging = true
		scroller = hit:FindFirstAncestorOfClass("ScrollingFrame")
		if scroller then
			scroller.ScrollingEnabled = false
		end
		(Anim.Tween)(knob, { Size = UDim2.fromOffset(18, 18) }, "Fast")
		fromX(input.Position.X)

		moveConn = UserInputService.InputChanged:Connect(function(changed)
			local ct = changed.UserInputType
			if ct == Enum.UserInputType.MouseMovement or ct == Enum.UserInputType.Touch then
				fromX(changed.Position.X)
			end
		end)
		endConn = UserInputService.InputEnded:Connect(function(ended)
			if ended == input or (t == Enum.UserInputType.MouseButton1 and ended.UserInputType == t) then
				stopDrag(false)
			end
		end)
	end))
	maid:Give(function()
		stopDrag(true)
	end)

	local api = { Instance = hit }
	function api.Get()
		return value
	end
	function api.Set(v, instant)
		v = Utils.Clamp(Utils.Snap(Utils.Clamp(v, min, max), step, min), min, max)
		value = v
		render(v, (not dragging) and not instant)
	end
	api.Set(opts.Default or min, true)
	return api
end

function UI.CreateSlider(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateSlider")
	Utils.Require(opts, "Title", "string", "CreateSlider")
	if opts.Key ~= nil and Defaults[opts.Key] == nil then
		error("[NUU7 HUB] CreateSlider: clave desconocida '" .. tostring(opts.Key) .. "'", 2)
	end
	local limit = opts.Key and Limits[opts.Key] or nil
	local min = opts.Min or (limit and limit.Min)
	local max = opts.Max or (limit and limit.Max)
	local step = opts.Step or (limit and limit.Step) or 1
	if typeof(min) ~= "number" or typeof(max) ~= "number" or max <= min then
		error("[NUU7 HUB] CreateSlider: rango inválido", 2)
	end
	local maid = opts.Maid or RootMaid

	local card, right = UI.CreateCard({
		Parent = opts.Parent,
		Title = opts.Title,
		Description = opts.Description,
		RightWidth = 48,
		Maid = maid,
	})
	local valueLabel = Utils.Label({
		Parent = right,
		Name = "Value",
		Text = "",
		Font = Theme.FontMedium,
		Size = 12,
		Color = Theme.SecondaryText,
		AlignX = Enum.TextXAlignment.Right,
		Frame = UDim2.new(1, 0, 0, 18),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
	})

	local function show(v)
		if opts.Format then
			valueLabel.Text = tostring(opts.Format(v))
		else
			valueLabel.Text = tostring(v)
		end
	end

	local track
	local initialized = false
	track = UI.CreateTrack({
		Parent = card,
		Min = min,
		Max = max,
		Step = step,
		Default = opts.Default,
		Maid = maid,
		LayoutOrder = 2,
		OnChanged = function(v)
			show(v)
			if opts.Key then
				Store.Set(opts.Key, v)
			end
			(Utils.SafeCall)(opts.Callback, v)
		end,
	})

	if opts.Key then
		Store.Bind(opts.Key, function(v)
			track.Set(v, not initialized)
			show(track.Get())
		end, maid)
	else
		track.Set(opts.Default or min, true)
		show(track.Get())
	end
	initialized = true

	local api = { Instance = card }
	function api.Get()
		return track.Get()
	end
	function api.Set(v)
		if opts.Key then
			Store.Set(opts.Key, v)
		else
			track.Set(v)
			show(track.Get())
		end
	end
	return api
end

function UI.CreateButton(opts)
	Utils.Require(opts, "Parent", "Instance", "CreateButton")
	Utils.Require(opts, "Title", "string", "CreateButton")
	local maid = opts.Maid or RootMaid
	local card, right = UI.CreateCard({
		Parent = opts.Parent,
		Title = opts.Title,
		Description = opts.Description,
		RightWidth = 24,
		Clickable = true,
		Maid = maid,
	})
	Utils.Label({
		Parent = right,
		Name = "Chevron",
		Text = opts.Text or "\u{203A}",
		Font = Theme.FontMedium,
		Size = 20,
		Color = Theme.SecondaryText,
		AlignX = Enum.TextXAlignment.Right,
		Frame = UDim2.new(1, 0, 0, 34),
	})
	maid:Give(card.Activated:Connect(function()
		(Utils.SafeCall)(opts.Callback)
	end))
	return { Instance = card }
end

----------------------------------------------------------------
-- COMPONENTES AVANZADOS
----------------------------------------------------------------
function UI.CreatePillButton(opts)
	Utils.Require(opts, "Parent", "Instance", "CreatePillButton")
	Utils.Require(opts, "Text", "string", "CreatePillButton")
	local maid = opts.Maid or RootMaid
	local base = opts.Primary and Theme.Accent or Theme.SurfaceSecondary
	local hover = opts.Primary and Theme.Accent:Lerp(Color3.new(1, 1, 1), 0.15) or Theme.SurfaceHover
	local button = Utils.New("TextButton", {
		Name = "Pill_" .. opts.Text,
		AutoButtonColor = false,
		BackgroundColor3 = base,
		BorderSizePixel = 0,
		Text = opts.Text,
		Font = Theme.FontMedium,
		TextSize = 12,
		TextColor3 = opts.Primary and Color3.fromRGB(10, 12, 16) or Theme.PrimaryText,
		Size = opts.Size or UDim2.fromOffset(100, 34),
		Position = opts.Position or UDim2.new(),
		AnchorPoint = opts.AnchorPoint or Vector2.new(0, 0),
		LayoutOrder = opts.LayoutOrder or 0,
		Parent = opts.Parent,
	})
	Utils.Corner(button, 8)
	Utils.Stroke(button)
	UI.AttachButtonFx(button, maid, base, hover)
	maid:Give(button.Activated:Connect(function()
		(Utils.SafeCall)(opts.Callback)
	end))
	return button
end

function UI.CreateModal(opts)
	local overlay = UI.Refs.Overlay
	if not overlay then
		error("[NUU7 HUB] CreateModal: la capa de ventanas no existe", 2)
	end
	local maid = Maid.new()
	RootMaid:Give(maid)
	local viewport = Utils.GetViewport()
	local width = math.min(opts.Width or 360, viewport.X - 24)
	local height = math.min(opts.Height or 300, viewport.Y - 24)
	local closed = false

	local backdrop = Utils.New("TextButton", {
		Name = "Backdrop",
		AutoButtonColor = false,
		Text = "",
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Parent = overlay,
	})
	maid:Give(backdrop)

	local panel = Utils.New("CanvasGroup", {
		Name = "Panel",
		Active = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(width, height),
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Parent = backdrop,
	})
	Utils.Corner(panel, Theme.CornerLarge)
	Utils.Stroke(panel, 0.85)
	local scale = Utils.New("UIScale", { Scale = 0.96, Parent = panel })

	Utils.Label({
		Parent = panel,
		Name = "Title",
		Text = opts.Title or "",
		Font = Theme.FontBold,
		Size = 14,
		Color = Theme.PrimaryText,
		Frame = UDim2.new(1, -64, 0, 44),
		Position = UDim2.fromOffset(16, 0),
		Truncate = Enum.TextTruncate.AtEnd,
	})
	local closeButton = Utils.New("TextButton", {
		Name = "Close",
		AutoButtonColor = false,
		BackgroundColor3 = Theme.SurfaceSecondary,
		BorderSizePixel = 0,
		Text = "X",
		Font = Theme.FontBold,
		TextSize = 13,
		TextColor3 = Theme.PrimaryText,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0, 22),
		Size = UDim2.fromOffset(30, 30),
		Parent = panel,
	})
	Utils.Corner(closeButton, 8)
	UI.AttachButtonFx(closeButton, maid, Theme.SurfaceSecondary, Theme.SurfaceHover)
	Utils.New("Frame", {
		Name = "Divider",
		BackgroundColor3 = Theme.Border,
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 44),
		Size = UDim2.new(1, 0, 0, 1),
		Parent = panel,
	})
	local body = Utils.New("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 45),
		Size = UDim2.new(1, 0, 1, -45),
		Parent = panel,
	})

	local modal = { Maid = maid, Panel = panel, Body = body }

	function modal.Close()
		if closed then
			return
		end
		closed = true
		(Anim.Tween)(backdrop, { BackgroundTransparency = 1 }, "Fast")
		(Anim.Tween)(panel, { GroupTransparency = 1 }, "Fast")
		(Anim.Tween)(scale, { Scale = 0.96 }, "Fast")
		(Utils.SafeCall)(opts.OnClose)
		task.delay(Settings.AnimationsEnabled and 0.15 or 0, function()
			maid:Clean()
		end)
	end

	maid:Give(closeButton.Activated:Connect(modal.Close))
	maid:Give(backdrop.Activated:Connect(modal.Close))

	(Anim.Tween)(backdrop, { BackgroundTransparency = 0.45 }, "Normal")
	(Anim.Tween)(panel, { GroupTransparency = 0 }, "Normal")
	(Anim.Tween)(scale, { Scale = 1 }, "Normal")

	return modal
end

function UI.Confirm(opts)
	local modal = UI.CreateModal({ Title = opts.Title or "Confirmar", Width = 320, Height = 190 })
	Utils.Label({
		Parent = modal.Body,
		Name = "Message",
		Text = opts.Message or "",
		Size = 12,
		Color = Theme.SecondaryText,
		Wrapped = true,
		AlignY = Enum.TextYAlignment.Top,
		Frame = UDim2.new(1, -32, 0, 60),
		Position = UDim2.fromOffset(16, 14),
	})
	UI.CreatePillButton({
		Parent = modal.Body,
		Text = opts.CancelText or "Cancelar",
		Size = UDim2.fromOffset(100, 34),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -126, 1, -14),
		Maid = modal.Maid,
		Callback = modal.Close,
	})
	UI.CreatePillButton({
		Parent = modal.Body,
		Text = opts.ConfirmText or "Confirmar",
		Primary = true,
		Size = UDim2.fromOffset(100, 34),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -14),
		Maid = modal.Maid,
		Callback = function()
			modal.Close()
			(Utils.SafeCall)(opts.OnConfirm)
		end,
	})
	return modal
end

function UI.CreateNotification(opts)
	local container = UI.Refs.Toasts
	if not container or UIState.Destroyed then
		return nil
	end
	local colors = {
		Info = Theme.Accent,
		Success = Theme.Success,
		Warning = Color3.fromRGB(255, 190, 70),
		Error = Theme.Danger,
	}
	local color = colors[opts.Type or "Info"] or Theme.Accent

	while #UI.Toasts >= 3 do
		local oldest = table.remove(UI.Toasts, 1)
		if oldest and oldest.Parent then
			oldest:Destroy()
		end
	end

	UI.ToastCounter = UI.ToastCounter + 1
	local toast = Utils.New("CanvasGroup", {
		Name = "Toast",
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		GroupTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = UI.ToastCounter,
		Parent = container,
	})
	Utils.Corner(toast, Theme.CornerMedium)
	Utils.Stroke(toast, 0.5, 1, color)
	Utils.Padding(toast, 12, 10, 12, 10)
	Utils.List(toast, 2)
	Utils.Label({
		Parent = toast,
		Name = "Title",
		Text = opts.Title or Config.HubName,
		Font = Theme.FontBold,
		Size = 12,
		Color = Theme.PrimaryText,
		Frame = UDim2.new(1, 0, 0, 0),
		AutoSize = Enum.AutomaticSize.Y,
		Wrapped = true,
		LayoutOrder = 1,
	})
	if opts.Message and opts.Message ~= "" then
		Utils.Label({
			Parent = toast,
			Name = "Message",
			Text = opts.Message,
			Size = 11,
			Color = Theme.SecondaryText,
			Frame = UDim2.new(1, 0, 0, 0),
			AutoSize = Enum.AutomaticSize.Y,
			Wrapped = true,
			LayoutOrder = 2,
		})
	end
	table.insert(UI.Toasts, toast)
	(Anim.Tween)(toast, { GroupTransparency = 0 }, "Normal")

	task.delay(opts.Duration or 3, function()
		if UIState.Destroyed or not toast.Parent then
			return
		end
		(Anim.Tween)(toast, { GroupTransparency = 1 }, "Normal")
		task.delay(Settings.AnimationsEnabled and 0.25 or 0, function()
			local index = table.find(UI.Toasts, toast)
			if index then
				table.remove(UI.Toasts, index)
			end
			if toast.Parent then
				toast:Destroy()
			end
		end)
	end)
	return toast
end

function UI.OpenColorPanel(opts)
	local modal = UI.CreateModal({
		Title = opts.Title or "Seleccionar color",
		Width = 330,
		Height = 310,
		OnClose = opts.OnClose,
	})
	local maid, body = modal.Maid, modal.Body
	local start = opts.Color or Color3.new(1, 1, 1)
	local channels = {
		R = math.floor(start.R * 255 + 0.5),
		G = math.floor(start.G * 255 + 0.5),
		B = math.floor(start.B * 255 + 0.5),
	}

	local preview = Utils.New("Frame", {
		Name = "Preview",
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(16, 12),
		Size = UDim2.new(1, -32, 0, 36),
		Parent = body,
	})
	Utils.Corner(preview, 8)
	Utils.Stroke(preview, 0.8)
	local hexLabel = Utils.Label({
		Parent = preview,
		Name = "Hex",
		Font = Theme.FontBold,
		Size = 12,
		AlignX = Enum.TextXAlignment.Center,
		Frame = UDim2.fromScale(1, 1),
	})

	local function current()
		return Color3.fromRGB(channels.R, channels.G, channels.B)
	end
	local function refresh()
		local color = current()
		preview.BackgroundColor3 = color
		hexLabel.Text = Utils.ColorToHex(color)
		local luminance = 0.299 * color.R + 0.587 * color.G + 0.114 * color.B
		hexLabel.TextColor3 = luminance > 0.6 and Color3.fromRGB(10, 12, 16) or Color3.new(1, 1, 1)
	end

	local tracks, valueLabels = {}, {}
	for index, name in ipairs({ "R", "G", "B" }) do
		local row = Utils.New("Frame", {
			Name = "Row_" .. name,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(16, 60 + (index - 1) * 34),
			Size = UDim2.new(1, -32, 0, 24),
			Parent = body,
		})
		Utils.Label({
			Parent = row,
			Text = name,
			Font = Theme.FontBold,
			Size = 12,
			Color = Theme.SecondaryText,
			Frame = UDim2.new(0, 16, 1, 0),
		})
		local holder = Utils.New("Frame", {
			Name = "Holder",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(22, 0),
			Size = UDim2.new(1, -64, 1, 0),
			Parent = row,
		})
		local valueLabel = Utils.Label({
			Parent = row,
			Name = "Value",
			Font = Theme.FontMedium,
			Size = 12,
			Color = Theme.SecondaryText,
			AlignX = Enum.TextXAlignment.Right,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			Frame = UDim2.new(0, 34, 1, 0),
		})
		valueLabels[name] = valueLabel
		tracks[name] = UI.CreateTrack({
			Parent = holder,
			Min = 0,
			Max = 255,
			Step = 1,
			Default = channels[name],
			Maid = maid,
			OnChanged = function(v)
				channels[name] = v
				valueLabel.Text = tostring(v)
				refresh()
			end,
		})
		valueLabel.Text = tostring(channels[name])
	end
	refresh()

	local presets = {
		Color3.fromRGB(0, 255, 255),
		Color3.fromRGB(90, 220, 100),
		Color3.fromRGB(90, 170, 255),
		Color3.fromRGB(150, 90, 255),
		Color3.fromRGB(255, 90, 200),
		Color3.fromRGB(255, 90, 90),
		Color3.fromRGB(255, 170, 60),
		Color3.fromRGB(255, 255, 255),
	}
	local presetRow = Utils.New("Frame", {
		Name = "Presets",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(16, 170),
		Size = UDim2.new(1, -32, 0, 28),
		Parent = body,
	})
	Utils.List(presetRow, 6, Enum.FillDirection.Horizontal)
	for index, color in ipairs(presets) do
		local swatch = Utils.New("TextButton", {
			Name = "Preset" .. index,
			AutoButtonColor = false,
			Text = "",
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(28, 28),
			LayoutOrder = index,
			Parent = presetRow,
		})
		Utils.Corner(swatch, 14)
		Utils.Stroke(swatch, 0.75)
		maid:Give(swatch.Activated:Connect(function()
			channels.R = math.floor(color.R * 255 + 0.5)
			channels.G = math.floor(color.G * 255 + 0.5)
			channels.B = math.floor(color.B * 255 + 0.5)
			for name, track in pairs(tracks) do
				track.Set(channels[name])
				valueLabels[name].Text = tostring(channels[name])
			end
			refresh()
		end))
	end

	UI.CreatePillButton({
		Parent = body,
		Text = "Cancelar",
		Size = UDim2.fromOffset(100, 34),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -126, 1, -14),
		Maid = maid,
		Callback = modal.Close,
	})
	UI.CreatePillButton({
		Parent = body,
		Text = "Confirmar",
		Primary = true,
		Size = UDim2.fromOffset(100, 34),
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -14),
		Maid = maid,
		Callback = function()
			modal.Close()
			(Utils.SafeCall)(opts.OnConfirm, current())
		end,
	})
	return modal
end

----------------------------------------------------------------
-- LÓGICA PRINCIPAL DEL HUB (Construcción de la Interfaz)
----------------------------------------------------------------

local function createHub()
	local screenGui = Utils.New("ScreenGui", {
		Name = GUI_NAME,
		DisplayOrder = 1000,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	})
	RootMaid:Give(screenGui)

	local frame = Utils.New("Frame", {
		Name = "MainFrame",
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(Config.Window.Width, Config.Window.Height),
		Position = UDim2.fromOffset(Config.Window.MarginX, Config.Window.MarginY),
		AnchorPoint = Vector2.new(0, 0),
		Parent = screenGui,
	})
	Utils.Corner(frame, Theme.CornerLarge)
	Utils.Stroke(frame, 0.85)
	
	-- Fondo semi-transparente opcional si se desea
	-- local bg = Utils.New("UIGradient", { Rotation = 90, Color = ColorSequence.new(Theme.Background, Theme.Surface), Parent = frame })

	local sidebar = Utils.New("Frame", {
		Name = "Sidebar",
		BackgroundColor3 = Theme.Surface,
		BorderSizePixel = 0,
		Size = UDim2.new(0, Config.Window.SidebarWidth, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Parent = frame,
	})
	Utils.Corner(sidebar, Theme.CornerLarge) -- Corner solo en el lado izquierdo superior/inferior? No, es un rectángulo interno.
	-- Para efecto visual real, podemos poner un borde derecho
	
	local contentArea = Utils.New("Frame", {
		Name = "ContentArea",
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, Config.Window.SidebarWidth, 0, 0),
		Parent = frame,
	})
	
	local listLayout = Utils.List(contentArea, 16, Enum.FillDirection.Vertical)
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	listLayout.Padding = UDim.new(0, 16)

	-- Overlay para modales
	local overlay = Utils.New("Frame", {
		Name = "Overlay",
		BackgroundColor3 = Color3.fromRGB(0,0,0),
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = true,
		Parent = screenGui,
	})
	UI.Refs.Overlay = overlay

	-- Toast Container
	local toastsContainer = Utils.New("Frame", {
		Name = "ToastsContainer",
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(1, -300, 0, 20),
		AnchorPoint = Vector2.new(1, 0),
		Parent = screenGui,
	})
	local toastList = Utils.List(toastsContainer, 10)
	toastList.FillDirection = Enum.FillDirection.Vertical
	toastList.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UI.Refs.Toasts = toastsContainer
	UI.Toasts = {}

	-- Sidebar Content
	local sidebarLogo = Utils.New("ImageLabel", {
		Image = Config.LogoImage,
		ImageRectOffset = Vector2.new(0,0),
		ImageRectSize = Vector2.new(0,0),
		ScaleType = Enum.ScaleType.Stretch,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 16),
		Size = UDim2.fromOffset(40, 40),
		Parent = sidebar,
	})
	Utils.Corner(sidebarLogo, 10)
	sidebarLogo.BackgroundTransparency = 0.5

	local sidebarTitle = Utils.Label({
		Parent = sidebar,
		Text = Config.HubName,
		Font = Theme.FontBold,
		Size = 14,
		Color = Theme.PrimaryText,
		Frame = UDim2.new(1, -20, 0, 20),
		Position = UDim2.new(0, 20, 0, 64),
		LayoutOrder = 1,
	})

	local sidebarPagesContainer = Utils.New("Frame", {
		Name = "PagesContainer",
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -20, 1, -100),
		Position = UDim2.new(0, 10, 0, 90),
		Parent = sidebar,
	})
	Utils.List(sidebarPagesContainer, 8)

	local buttons = {}
	
	-- Generar botones de navegación
	for _, pageData in ipairs(Config.Pages) do
		local btn = Utils.New("TextButton", {
			Name = "Btn_" .. pageData.Id,
			AutoButtonColor = false,
			Text = pageData.Title,
			Font = Theme.FontMedium,
			TextSize = 13,
			TextColor3 = Theme.PrimaryText,
			BackgroundColor3 = Theme.Surface,
			Size = UDim2.new(1, -10, 0, 36),
			LayoutOrder = #buttons + 1,
			Parent = sidebarPagesContainer,
		})
		Utils.Corner(btn, 8)
		
		-- Estilo activo/inactivo
		local isActive = pageData.Id == Config.DefaultPage
		
		btn.MouseEnter:Connect(function()
			if not isActive then
				(Anim.Tween)(btn, { BackgroundColor3 = Theme.SurfaceHover }, "Fast")
			end
		end)
		btn.MouseLeave:Connect(function()
			if not isActive then
				(Anim.Tween)(btn, { BackgroundColor3 = Theme.Surface }, "Fast")
			end
		end)
		
		btn.Activated:Connect(function()
			-- Cambiar página
			UIState.CurrentPage = pageData.Id
			
			-- Actualizar estilo botones
			for _, b in ipairs(buttons) do
				(Anim.Tween)(b.Button, { BackgroundColor3 = Theme.Surface }, "Fast")
				(Anim.Tween)(b.Label, { TextColor3 = Theme.PrimaryText }, "Fast")
			end
			
			-- Activar actual
			(Anim.Tween)(btn, { BackgroundColor3 = Theme.SurfaceHover }, "Fast")
			(Anim.Tween)(btnLabel, { TextColor3 = Theme.Accent }, "Fast")
			
			-- Renderizar contenido
			renderPageContent(pageData.Id)
		end)
		
		table.insert(buttons, { Button = btn, Label = btn })
		UI.SidebarButtons[pageData.Id] = btn
	end

	-- Área de Contenido Dinámico
	local contentContainer = Utils.New("Frame", {
		Name = "ContentContainer",
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -24, 1, -24),
		Position = UDim2.fromOffset(12, 12),
		Parent = contentArea,
	})
	Utils.List(contentContainer, 12)

	local fpsLabel = Utils.Label({
		Parent = contentArea,
		Text = "FPS: --",
		Font = Theme.FontBold,
		Size = 11,
		Color = Theme.Accent,
		Frame = UDim2.new(1, 0, 0, 16),
		Position = UDim2.new(1, -10, 1, -10),
		AnchorPoint = Vector2.new(1, 1),
	})

	-- Variables para almacenar los elementos creados dinámicamente
	local pageContentCache = {}

	function renderPageContent(pageId)
		-- Limpiar contenido anterior
		for _, child in pairs(contentContainer:GetChildren()) do
			if child:IsA("Frame") or child:IsA("ScrollingFrame") then
				child:Destroy()
			end
		end

		local pageData = Config.Pages[Config.Pages[pageId]] -- Simple lookup

		if pageId == "NuShoot" then
			local scroll = Utils.New("ScrollingFrame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = Theme.SurfaceSecondary,
				Parent = contentContainer,
			})
			Utils.List(scroll, 12)
			
			UI.CreateToggle({ Parent = scroll, Title = "Habilitar NuShoot", Key = "NuShoot", Maid = RootMaid })
			UI.CreateToggle({ Parent = scroll, Title = "Click Shot", Key = "ClickShot", Maid = RootMaid })
			UI.CreateSlider({ Parent = scroll, Title = "Puntos de Detección", Key = "DetectionPoints", Min = 1, Max = 50, Default = 10, Maid = RootMaid })
			UI.CreateToggle({ Parent = scroll, Title = "Habilitar FOV", Key = "FOVEnabled", Maid = RootMaid })
			UI.CreateSlider({ Parent = scroll, Title = "Tamaño FOV", Key = "FOVSize", Min = 100, Max = 500, Default = 200, Maid = RootMaid })
			pageContentCache[pageId] = scroll

		elseif pageId == "ESP" then
			local scroll = Utils.New("ScrollingFrame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = Theme.SurfaceSecondary,
				Parent = contentContainer,
			})
			Utils.List(scroll, 12)

			UI.CreateToggle({ Parent = scroll, Title = "Habilitar ESP", Key = "ESPEnabled", Maid = RootMaid })
			UI.CreateToggle({ Parent = scroll, Title = "Ver Aliados", Key = "AllyESP", Maid = RootMaid })
			
			-- Selector de color simple (placeholder functionality)
			local colorBtn = UI.CreateButton({
				Parent = scroll,
				Title = "Color Outline",
				Maid = RootMaid,
				Callback = function()
					UI.OpenColorPanel({
						Title = "Color Outline",
						Color = Settings.OutlineColor,
						OnConfirm = function(newColor)
							Store.Set("OutlineColor", newColor)
						end
					})
				end
			})

			UI.CreateButton({ Parent = scroll, Title = "Color Aliado", Maid = RootMaid, Callback = function()
				UI.OpenColorPanel({ Title = "Color Aliado", Color = Settings.AllyOutlineColor, OnConfirm = function(c) Store.Set("AllyOutlineColor", c) end })
			end})
			
			pageContentCache[pageId] = scroll

		elseif pageId == "Settings" then
			local scroll = Utils.New("ScrollingFrame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = Theme.SurfaceSecondary,
				Parent = contentContainer,
			})
			Utils.List(scroll, 12)

			UI.CreateSection({ Parent = scroll, Title = "Apariencia" })
			UI.CreateToggle({ Parent = scroll, Title = "Animaciones", Key = "AnimationsEnabled", Maid = RootMaid })
			UI.CreateToggle({ Parent = scroll, Title = "Mostrar Perfil", Key = "ShowProfile", Maid = RootMaid })
			UI.CreateToggle({ Parent = scroll, Title = "Mostrar FPS", Key = "ShowFPS", Maid = RootMaid })
			
			UI.CreateSection({ Parent = scroll, Title = "Entorno" })
			UI.CreateSlider({ Parent = scroll, Title = "Hora del Juego", Key = "GameTime", Min = 0, Max = 24, Default = 14, Format = function(v) return string.format("%.1f", v) .. ":00" end, Maid = RootMaid })
			
			-- Selector de Tema
			local themeBtn = UI.CreateButton({
				Parent = scroll,
				Title = "Cambiar Tema",
				Maid = RootMaid,
				Callback = function()
					-- Simulación simple de cambio de tema (en un hub real sería un dropdown o modal complejo)
					local themes = {"Default", "Tokoyami", "Night", "Pink"}
					local currentIndex = table.find(themes, Settings.CurrentTheme) or 1
					local nextIndex = (currentIndex % #themes) + 1
					local themeName = themes[nextIndex]
					
					local preset = ThemePresets[themeName]
					if preset then
						Store.Set("CurrentTheme", themeName)
						Store.Set("AccentColor", preset.Accent)
						
						if preset.Lighting then
							Lighting.ClockTime = preset.Lighting.ClockTime
							Lighting.Ambient = preset.Lighting.Ambient
							Lighting.OutdoorAmbient = preset.Lighting.OutdoorAmbient
							Lighting.FogColor = preset.Lighting.FogColor
							Lighting.FogStart = preset.Lighting.FogStart
							Lighting.FogEnd = preset.Lighting.FogEnd
						else
							-- Reset lighting defaults if needed
						end
						
						UI.CreateNotification({ Type = "Success", Message = "Tema cambiado a " .. themeName })
					end
				end
			})
			
			pageContentCache[pageId] = scroll

		elseif pageId == "Avatar" then
			local scroll = Utils.New("ScrollingFrame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ScrollBarThickness = 4,
				ScrollBarImageColor3 = Theme.SurfaceSecondary,
				Parent = contentContainer,
			})
			Utils.List(scroll, 12)
			
			Utils.Label({ Parent = scroll, Text = "Personalización de Avatar", Font = Theme.FontBold, Size = 14, Frame = UDim2.new(1,0,0,30), LayoutOrder = -1 })
			
			UI.CreateSlider({ Parent = scroll, Title = "Tamaño Avatar", Key = "AvatarSize", Min = 40, Max = 96, Default = 64, Maid = RootMaid })
			
			pageContentCache[pageId] = scroll
		end
	end

	-- Render inicial
	renderPageContent(Config.DefaultPage)

	-- Toggle Visibility
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Config.ToggleKey then
			UIState.Open = not UIState.Open
			if UIState.Open then
				(Anim.Tween)(frame, { Size = UDim2.fromOffset(Config.Window.Width, Config.Window.Height) }, "Normal")
				frame.Visible = true
			else
				(Anim.Tween)(frame, { Size = UDim2.fromOffset(0, 0) }, "Normal")
				task.wait(0.2)
				frame.Visible = false
			end
		end
	end)

	-- FPS Loop
	local fps = 0
	local frames = 0
	local lastTime = tick()
	
	RunService.RenderStepped:Connect(function()
		local now = tick()
		local delta = now - lastTime
		lastTime = now
		
		frames += 1
		if delta >= 0.5 then
			fps = math.round(frames / delta)
			fpsLabel.Text = "FPS: " .. tostring(fps)
			frames = 0
		end
	end)

	-- Dragging Logic (Simplificada para robustez)
	local dragging = false
	local dragInput, mousePos, framePos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			mousePos = input.Position
			framePos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			frame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
		end
	end)

	return screenGui
end

-- Iniciar el Hub
local hubGui = createHub()
shared.NUU7Hub = { Destroy = function() if hubGui then hubGui:Destroy() end end }
