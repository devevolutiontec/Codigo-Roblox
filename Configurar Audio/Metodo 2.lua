local Carpeta = game.Workspace.Canciones
local Primera = Carpeta:WaitForChild("Nombre Audio 1")
local Segunda = Carpeta:WaitForChild("Nombre Audio 2")

local function playPrimera()
	Primera:Play()
end

local function playSegunda()
	Segunda:Play()
end

Primera:Play()
Primera.Ended:Connect(playSegunda)
Segunda.Ended:Connect(playPrimera)