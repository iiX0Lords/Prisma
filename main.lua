local StarterGui = game:GetService("StarterGui")

local Prisma = {}
Prisma.commands = {}
Prisma.version = "<!#FV> 1.0.0 </#FV>"
Prisma.version = string.sub(Prisma.version,8,13)

Prisma.ui = {
    Text = Drawing.new("Text"),
    Background = Drawing.new("Square"),
}
--8.3
Prisma.ui.Background.Filled = true
Prisma.ui.Background.Color = Color3.fromRGB(38,38,38)
Prisma.ui.Background.Size = Vector2.new(85, 15)
Prisma.ui.Background.Visible = false
Prisma.ui.Background.Position = Vector2.new(960, 540)

Prisma.ui.Text.Color = Color3.fromRGB(255, 255, 255)
Prisma.ui.Text.ZIndex = 99
Prisma.ui.Text.Visible = false
Prisma.ui.Text.Position = Vector2.new(960, 540)

local Plr = game.Players.LocalPlayer
local Mouse = Plr:GetMouse()

function Prisma:isValidCommand(String,send)
	for _,v in pairs(Prisma.commands) do
		if v.Command == String or v.Alias == String then
			if send then
				return v
			else
				return true
			end
		end
	end
end

function Prisma:parseText(txt)
    if txt ~= " " and string.len(txt) ~= 0 then
		local text = string.lower(txt)
		if text == "" then return end

		local args = {}

		for Argument in string.gmatch(text,"[^%s]+") do
			table.insert(args,Argument)
		end

		if Prisma:isValidCommand(args[1]) then
			local commandT = Prisma:isValidCommand(args[1],true)

			if commandT.SendFull then
				local asub = nil

				if args[1] == commandT.Command then
					asub = string.len(commandT.Command) + 2
				elseif args[1] == commandT.Alias then
					asub = string.len(commandT.Alias) + 2
				end

				local fstring = string.sub(text,asub,100)
				commandT.CallBack(fstring,args[2],args[3])
			else
				commandT.CallBack(args[2],args[3],args[4])
			end

		end
	end
end

function Prisma:addCMD(command,alias,callback,sendfull)
	local fc = callback
	if callback == nil or callback == "" or type(callback) == "string" then
		fc = sendfull
	end

	table.insert(Prisma.commands,{
		Command = command,
		Alias = alias,
		CallBack = fc,
		SendFull = sendfull,
	})
end

function Prisma:findPlr(args)
	for _, v in pairs(game.Players:GetChildren()) do
        local name = string.lower(v.Name)
        local displayName = memory_read("string", v.Address + 0x110)
        if displayName ~= nil then
            displayName = string.lower(displayName)
        else
            displayName = name
        end
        if string.find(name, string.lower(args)) or string.find(displayName, string.lower(args)) then
            return v
        end
    end
end


local Keycodes = {
    Mouse = {
        LBUTTON = 0x01,
        RBUTTON = 0x02,
        CANCEL = 0x03,
        MBUTTON = 0x04,
        XBUTTON1 = 0x05,
        XBUTTON2 = 0x06,
    },

    Control = {
        BACK = 0x08,
        TAB = 0x09,
        CLEAR = 0x0C,
        RETURN = 0x0D,
        SHIFT = 0x10,
        CONTROL = 0x11,
        MENU = 0x12,
        PAUSE = 0x13,
        CAPITAL = 0x14,
        ESCAPE = 0x1B,
        SPACE = 0x20,
        PRIOR = 0x21,
        NEXT = 0x22,
        END = 0x23,
        HOME = 0x24,
        LEFT = 0x25,
        UP = 0x26,
        RIGHT = 0x27,
        DOWN = 0x28,
        SELECT = 0x29,
        PRINT = 0x2A,
        EXECUTE = 0x2B,
        SNAPSHOT = 0x2C,
        INSERT = 0x2D,
        DELETE = 0x2E,
        HELP = 0x2F,
    },

    Numbers = {
        KEY_0 = 0x30,
        KEY_1 = 0x31,
        KEY_2 = 0x32,
        KEY_3 = 0x33,
        KEY_4 = 0x34,
        KEY_5 = 0x35,
        KEY_6 = 0x36,
        KEY_7 = 0x37,
        KEY_8 = 0x38,
        KEY_9 = 0x39,
    },

    Letters = {
        A = 0x41,
        B = 0x42,
        C = 0x43,
        D = 0x44,
        E = 0x45,
        F = 0x46,
        G = 0x47,
        H = 0x48,
        I = 0x49,
        J = 0x4A,
        K = 0x4B,
        L = 0x4C,
        M = 0x4D,
        N = 0x4E,
        O = 0x4F,
        P = 0x50,
        Q = 0x51,
        R = 0x52,
        S = 0x53,
        T = 0x54,
        U = 0x55,
        V = 0x56,
        W = 0x57,
        X = 0x58,
        Y = 0x59,
        Z = 0x5A,
    },

    Windows = {
        LWIN = 0x5B,
        RWIN = 0x5C,
        APPS = 0x5D,
        SLEEP = 0x5F,
    },

    Numpad = {
        NUMPAD0 = 0x60,
        NUMPAD1 = 0x61,
        NUMPAD2 = 0x62,
        NUMPAD3 = 0x63,
        NUMPAD4 = 0x64,
        NUMPAD5 = 0x65,
        NUMPAD6 = 0x66,
        NUMPAD7 = 0x67,
        NUMPAD8 = 0x68,
        NUMPAD9 = 0x69,
        MULTIPLY = 0x6A,
        ADD = 0x6B,
        SEPARATOR = 0x6C,
        SUBTRACT = 0x6D,
        DECIMAL = 0x6E,
        DIVIDE = 0x6F,
    },

    FunctionKeys = {
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
        F12 = 0x7B,
        F13 = 0x7C,
        F14 = 0x7D,
        F15 = 0x7E,
        F16 = 0x7F,
        F17 = 0x80,
        F18 = 0x81,
        F19 = 0x82,
        F20 = 0x83,
        F21 = 0x84,
        F22 = 0x85,
        F23 = 0x86,
        F24 = 0x87,
    },

    LockKeys = {
        NUMLOCK = 0x90,
        SCROLL = 0x91,
    },

    Modifiers = {
        LSHIFT = 0xA0,
        RSHIFT = 0xA1,
        LCONTROL = 0xA2,
        RCONTROL = 0xA3,
        LMENU = 0xA4,
        RMENU = 0xA5,
    },

    Browser = {
        BROWSER_BACK = 0xA6,
        BROWSER_FORWARD = 0xA7,
        BROWSER_REFRESH = 0xA8,
        BROWSER_STOP = 0xA9,
        BROWSER_SEARCH = 0xAA,
        BROWSER_FAVORITES = 0xAB,
        BROWSER_HOME = 0xAC,
    },

    Media = {
        VOLUME_MUTE = 0xAD,
        VOLUME_DOWN = 0xAE,
        VOLUME_UP = 0xAF,
        MEDIA_NEXT_TRACK = 0xB0,
        MEDIA_PREV_TRACK = 0xB1,
        MEDIA_STOP = 0xB2,
        MEDIA_PLAY_PAUSE = 0xB3,
        LAUNCH_MAIL = 0xB4,
        LAUNCH_MEDIA_SELECT = 0xB5,
        LAUNCH_APP1 = 0xB6,
        LAUNCH_APP2 = 0xB7,
    },

    OEM = {
        OEM_1 = 0xBA,
        OEM_PLUS = 0xBB,
        OEM_COMMA = 0xBC,
        OEM_MINUS = 0xBD,
        OEM_PERIOD = 0xBE,
        OEM_2 = 0xBF,
        OEM_3 = 0xC0,
        OEM_4 = 0xDB,
        OEM_5 = 0xDC,
        OEM_6 = 0xDD,
        OEM_7 = 0xDE,
        OEM_8 = 0xDF,
        OEM_102 = 0xE2,
    },

    IME = {
        KANA = 0x15,
        HANGUEL = 0x15,
        HANGUL = 0x15,
        IME_ON = 0x16,
        JUNJA = 0x17,
        FINAL = 0x18,
        HANJA = 0x19,
        KANJI = 0x19,
        IME_OFF = 0x1A,
        CONVERT = 0x1C,
        NONCONVERT = 0x1D,
        ACCEPT = 0x1E,
        MODECHANGE = 0x1F,
    },

    Special = {
        PROCESSKEY = 0xE5,
        PACKET = 0xE7,
        ATTN = 0xF6,
        CRSEL = 0xF7,
        EXSEL = 0xF8,
        EREOF = 0xF9,
        PLAY = 0xFA,
        ZOOM = 0xFB,
        NONAME = 0xFC,
        PA1 = 0xFD,
        OEM_CLEAR = 0xFE,
    }
}

function GetPressedKeys()
    local pressed = {}
    for _, keycodeTable in pairs(Keycodes) do
        for name, keycode in pairs(keycodeTable) do
            if iskeypressed(keycode) then
                pressed[name] = keycode
            end
        end
    end
    return pressed
end

local Loops = {}
function CreateLoop(callback)
    table.insert(Loops, callback)
end

function Character()
    return Plr.Character
end


local CurrentlyDown = {}
local Binds = {}
function isKeyDown(keycode)
    return table.find(CurrentlyDown, keycode)
end
function addBindFunction(keycode, callback)
    table.insert(Binds, {
        Keycode = keycode,
        Callback = callback
    })
end
CreateLoop(function()
    for name, keycode in pairs(GetPressedKeys()) do
        if not table.find(CurrentlyDown, keycode) then
            table.insert(CurrentlyDown, keycode)
            for _, bind in pairs(Binds) do
                if bind.Keycode == keycode then
                    bind.Callback(true)
                end
            end
        end
    end
    for i, keycode in pairs(CurrentlyDown) do
        if not iskeypressed(keycode) then
            table.remove(CurrentlyDown, i)
            for _, bind in pairs(Binds) do
                if bind.Keycode == keycode then
                    bind.Callback(false)
                end
            end
        end
    end
end)

local Frozen = nil
local Middle = {
    X = 960,
    Y = 540
}
local PressedString = ""
local CapturingInput = false

for name, keycode in pairs(Keycodes.Letters) do
    addBindFunction(keycode, function(active)
        if active and CapturingInput then
            PressedString = PressedString..string.lower(name)
        end
    end)
end
for name, keycode in pairs(Keycodes.Numbers) do
    addBindFunction(keycode, function(active)
        if active and CapturingInput then
            local number = string.sub(name, 5)
            PressedString = PressedString..number
        end
    end)
end
addBindFunction(Keycodes.Control.BACK, function(active)
    if active then
        PressedString = string.sub(PressedString, 1, string.len(PressedString) - 1)
    end
end)
addBindFunction(Keycodes.Control.SPACE, function(active)
    if active then
        PressedString = PressedString.." "
    end
end)


addBindFunction(Keycodes.Modifiers.RMENU, function(active)
    if not active then return end
    if not CapturingInput then
        if PressedString == "" then
            CapturingInput = true
        end
    else
        CapturingInput = false
    end
    PressedString = ""
end)
addBindFunction(Keycodes.Control.RETURN, function(active)
    if not active then return end
    if not CapturingInput then return end
    CapturingInput = false
    Frozen = nil
    print(PressedString)
    Prisma:parseText(PressedString)
end)

CreateLoop(function()
    Prisma.ui.Text.Visible = CapturingInput
    Prisma.ui.Background.Visible = CapturingInput

    Prisma.ui.Text.Text = PressedString

    Prisma.ui.Text.Position = Vector2.new(Middle.X - (Prisma.ui.Background.Size.X / 2), Middle.Y)
    Prisma.ui.Background.Position = Vector2.new(Middle.X - (Prisma.ui.Background.Size.X / 2), Middle.Y)

    if CapturingInput then
        local char = Character()
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        if Frozen == nil then
            Frozen = root.Position
        else
            root.Position = Frozen
        end

        local textCount = string.len(PressedString) - 10
        textCount = math.clamp(textCount, 1, math.huge)
        Prisma.ui.Background.Size = Vector2.new(80 + (8.3 * textCount), 15)
    end
end)

Prisma:addCMD("tp", "goto", function(player)
    local target = Prisma:findPlr(player)
    if target then
        local char = Character()
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            if target.Character then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    root.Position = targetRoot.Position
                end
            end
        end
    end
end)

while true do
    for _,func in pairs(Loops) do
        func()
    end
end