
local Utils = {}
_G.Utils = Utils

function Utils.FetchOffsets()
    local httpService = game:GetService("HttpService")
    local url = "https://offsets.ntgetwritewatch.workers.dev/offsets.json"
    local response = game:HttpGet(url)
    local offsets = httpService:JSONDecode(response)
    return offsets or {}
end

local Offsets = {
    SeatPart = 0x120,
    Name = 0xB0,
    CameraRotation = 0xF8,
    CameraSubject = 0xE8,
    Rotation = 0xC8,
    CameraPos = 0x11C,
    Position = 0xE4,
    Primitive = 0x148
}

for key, value in pairs(Utils.FetchOffsets()) do
    Offsets[key] = value
end

function Utils.IsUnsafe()
    local success = pcall(function()
        memory_read("string", workspace.Address + Offsets.Name)
    end)
    return success
end

function Utils.ViewportSize()
    local camera = workspace.CurrentCamera
    if not camera then return end
    return camera.ViewportSize
end

Utils.Math = {}
function Utils.Math.MultiplyVector(a, b)
    if not a or not b then return end
    if typeof(a) == "Vector3" and typeof(b) == "Vector3" then
        return Vector3.new(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
    elseif typeof(a) == "Vector2" and typeof(b) == "Vector2" then
        return Vector2.new(a.X * b.X, a.Y * b.Y)
    end
end
function Utils.Math.Cross(a, b)
    if not a or not b then return end
    if typeof(a) == "Vector3" and typeof(b) == "Vector3" then
        return Vector3.new(
            a.Y * b.Z - a.Z * b.Y,
            a.Z * b.X - a.X * b.Z,
            a.X * b.Y - a.Y * b.X
        )
    elseif typeof(a) == "Vector2" and typeof(b) == "Vector2" then
        return Vector2.new(a.X * b.Y - a.Y * b.X, a.Y * b.X - a.X * b.Y)
    end
end
function Utils.Math.Unit(v)
    if not v then return end
    if typeof(v) == "Vector3" then
        local mag = math.sqrt(v.X*v.X + v.Y*v.Y + v.Z*v.Z)
        if mag == 0 then
            return Vector3.new(0, 0, 0)
        end
        return Vector3.new(v.X / mag, v.Y / mag, v.Z / mag)
    elseif typeof(v) == "Vector2" then
        local mag = math.sqrt(v.X*v.X + v.Y*v.Y)
        if mag == 0 then
            return Vector2.new(0, 0)
        end
        return Vector2.new(v.X / mag, v.Y / mag)
    end
end
function Utils.Math.Length(vector)
    if not vector then return end
    if typeof(vector) == "Vector3" then
        return math.sqrt(vector.X*vector.X + vector.Y*vector.Y + vector.Z*vector.Z)
    elseif typeof(vector) == "Vector2" then
        return math.sqrt(vector.X*vector.X + vector.Y*vector.Y)
    end
end

Utils.Camera = {}
function Utils.Camera.LookDirection()
    local camera = workspace.CurrentCamera
    if not camera and not camera.Address then return end

    local address = camera.Address
    local r = Offsets.CameraRotation
    local r02 = memory_read("float", address + r + 0x8)
    local r12 = memory_read("float", address + r + 0x14)
    local r22 = memory_read("float", address + r + 0x20)
    return Vector3.new(-r02, -r12, -r22)
end
function Utils.Camera.SetRotation(right, up, forward)
    local camera = workspace.CurrentCamera
    if not camera or not camera.Address then return end
    local addr = camera.Address + Offsets.CameraRotation

    local back = Vector3.new(-forward.X, -forward.Y, -forward.Z)

    memory_write("float", addr + 0x0, right.X)
    memory_write("float", addr + 0x4, up.X)
    memory_write("float", addr + 0x8, back.X)

    memory_write("float", addr + 0xC, right.Y)
    memory_write("float", addr + 0x10, up.Y)
    memory_write("float", addr + 0x14, back.Y)

    memory_write("float", addr + 0x18, right.Z)
    memory_write("float", addr + 0x1C, up.Z)
    memory_write("float", addr + 0x20, back.Z)
end
function Utils.Camera.SetPosition(position)
    local camera = workspace.CurrentCamera
    if not camera or not camera.Address then return end
    local addr = camera.Address + Offsets.CameraPos
    memory_write("float", addr + 0x0, position.X)
    memory_write("float", addr + 0x4, position.Y)
    memory_write("float", addr + 0x8, position.Z)
end

return Utils