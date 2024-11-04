
if _G.prisma.Loaded == true then
	return
elseif _G.prisma.Loaded == false or _G.prisma.Loaded == nil then
	if not game:IsLoaded() then game.Loaded:Wait() end
end

function getVersion()
    _G.prismaReturn = true
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/iiX0Lords/Prisma/refs/heads/main/main.lua"))()
end


if _G.prisma.version ~= getVersion() then
    print("[PRISMA] - Loading Local Version")
    _G.prismaYielding = false
    else
    print("[PRISMA] - Loading Web Version")
    _G.prismaReturn = false
    _G.prismaYielding = "End"
    loadstring(game:HttpGet("https://raw.githubusercontent.com/iiX0Lords/Prisma/refs/heads/main/main.lua"))()
    _G.prismaYielding = false
end