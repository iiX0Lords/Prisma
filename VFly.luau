
local ToggleKey = _G.VFlyToggle or Enum.KeyCode.Y

loadstring(game:HttpGet("https://raw.githubusercontent.com/iiX0Lords/Prisma/refs/heads/matchaluavm/utils.luau"))(); local Utils = _G.Utils
local Offsets = Utils.Offsets

if not Utils.IsUnsafe() then
    Utils.Notify("Please Allow Unsafe LuaU Execution", 10)
    error("Please Allow Unsafe LuaU Execution")
    return
end

local Plr = game.Players.LocalPlayer
local Mouse = Plr:GetMouse()
local Uis = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local SeatPart = nil
local Speed = 100
local Movement = {
    F = 0,
    R = 0,
    U = 0,
}
local CamState = {
    Yaw = 0,
    Pitch = 0,
    Offset = Vector3.new(0, 5, 25)
}
local Enabled = true
local WasJustSitting = false

function GetSeat(humanoid : Humanoid)
    if not humanoid then return end
    local seatpart = memory_read("uintptr_t", humanoid.Address + Offsets.SeatPart)
    if seatpart == 0 then return end
    return seatpart
end

function CalculateBasis(yaw, pitch)
    local bx = math.sin(yaw) * math.cos(pitch)
    local by = math.sin(pitch)
    local bz = math.cos(yaw) * math.cos(pitch)
    local back = Vector3.new(bx, by, bz)

    local worldUp = Vector3.new(0, 1, 0)
    local right = Utils.Math.Unit(Utils.Math.Cross(worldUp, back))

    local up = Utils.Math.Unit(Utils.Math.Cross(back, right))

    local forward = Vector3.new(-back.X, -back.Y, -back.Z)

    return right, up, forward, back
end

function GetVehicleSeat()
    local character = Plr.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local vehicle = GetSeat(humanoid)
    if not vehicle then return end

    local vehicleSeat = nil

    for _, instance : Instance in pairs(workspace:GetDescendants()) do
        if instance.Address == vehicle then
            vehicleSeat = instance
        end
    end

    return vehicleSeat
end

function UpdateVelocity()
    if not Enabled then return end
    if not SeatPart then return end
    local right, up, forward, back = CalculateBasis(CamState.Yaw, CamState.Pitch)
    local moveVector = 
        forward * Movement.F +
        right * Movement.R +
        up * (Movement.U or 0)
    SeatPart.AssemblyLinearVelocity = moveVector * Speed
end

Uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if input.KeyCode == ToggleKey then
        Enabled = not Enabled
        Utils.Notify(`Enabled: {Enabled}`, 1)
        return
    end

    if not Enabled then return end

    if input.KeyCode == Enum.KeyCode.W then Movement.F = 1 end
    if input.KeyCode == Enum.KeyCode.S then Movement.F = -1 end
    if input.KeyCode == Enum.KeyCode.A then Movement.R = -1 end
    if input.KeyCode == Enum.KeyCode.D then Movement.R = 1 end
    if input.KeyCode == Enum.KeyCode.Q then Speed += 20 Utils.Notify(`Speed: {Speed}`, 1) end
    if input.KeyCode == Enum.KeyCode.E then Speed -= 20 Utils.Notify(`Speed: {Speed}`, 1) end
    if input.KeyCode == Enum.KeyCode.O then CamState.Offset += Vector3.new(0, 0, 5) end
    if input.KeyCode == Enum.KeyCode.I then CamState.Offset -= Vector3.new(0, 0, 5) end
end)

Uis.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then Movement.F = 0 end
    if input.KeyCode == Enum.KeyCode.S then Movement.F = 0 end
    if input.KeyCode == Enum.KeyCode.A then Movement.R = 0 end
    if input.KeyCode == Enum.KeyCode.D then Movement.R = 0 end
end)

function Setup()
    local character = Plr.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local seat = GetSeat(humanoid)
    if not seat then
        SeatPart = nil
        WasJustSitting = false
        return
    end

    if SeatPart then
        if SeatPart.Address ~= seat then
            SeatPart = GetVehicleSeat()
        end
    else
        SeatPart = GetVehicleSeat()
    end

    if Enabled then
        WasJustSitting = true
    end
end

local ViewportSize = Camera.ViewportSize
local LastPos = Vector2.new(ViewportSize.X / 2, ViewportSize.Y / 2)
function UpdateCamera()
    if not SeatPart then return end
    if not Enabled then
        if not WasJustSitting then
            return
        end
    end

    local right, up, forward, back = CalculateBasis(CamState.Yaw, CamState.Pitch)

    local targetPos = SeatPart.Position
        + (up * CamState.Offset.Y)
        + (back * CamState.Offset.Z)
        + (right * CamState.Offset.X)

    Utils.Camera.SetRotation(right, up, forward)
    Utils.Camera.SetPosition(targetPos)

    if Plr.Character and Plr.Character:FindFirstChild("HumanoidRootPart") then
        memory_write("uintptr_t", Camera.Address + Offsets.CameraSubject, Plr.Character.HumanoidRootPart.Address)
    end
end

function MouseFunctions()
    if not SeatPart then return end
    if not isrbxactive() then return end
    if not Enabled then
        if not WasJustSitting then
            return
        end
    end

    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local delta = mousePos - LastPos

    if Utils.Math.Length(delta) > 1000 then
        delta = Vector2.new(0, 0)
    end

    LastPos = mousePos
    local sensitivity = 0.005
    
    CamState.Yaw = CamState.Yaw - (delta.X * sensitivity)
    CamState.Pitch = CamState.Pitch - (-delta.Y * sensitivity)
    
    CamState.Pitch = math.clamp(CamState.Pitch, -1.4, 1.4)

    local offset = 10
    if Mouse.X > (ViewportSize.X - offset) then
        mousemoveabs(0, Mouse.Y)
    end
    if Mouse.Y > (ViewportSize.Y - offset) then
        mousemoveabs(Mouse.X, 0)
    end

    if Mouse.X < offset then
        mousemoveabs(ViewportSize.X, Mouse.Y)
    end
    if Mouse.Y < offset then
        mousemoveabs(Mouse.X, ViewportSize.Y)
    end
end

while true do

    Setup()

    MouseFunctions()
    UpdateCamera()
    UpdateVelocity()

    task.wait()
end