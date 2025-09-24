-- Metodo 3
local trapPart = script.Parent
local Players = game:GetService("Players")

-- Función que se ejecutará cada vez que algo toque la trampa
local function onTouch(otherPart)
	-- Verificamos si el objeto que tocó pertenece a un modelo (Character)
	local character = otherPart.Parent
	if not character then return end -- Si no hay parent, salimos

	-- Intentamos encontrar el Humanoid dentro del "character"
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end -- Si no tiene humanoid, salimos

	-- Verificamos si este "character" pertenece a un jugador real
	local player = Players:GetPlayerFromCharacter(character)
	if not player then return end -- No es un jugador, probablemente un NPC

	-- Si llegamos aquí, es un jugador humano => lo matamos salud en 0
	humanoid.Health = 0
end

-- Conectar el evento Touched de la parte con la función onTouch
trapPart.Touched:Connect(onTouch)