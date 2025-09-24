-- Metodo 4
-- Servicio que permite trabajar con tags (CollectionService)
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

-- Constante: nombre del tag usado para identificar las trampas
local TRAP_TAG = "TrapPart"

-- Función que se ejecuta cuando algo toca una trampa
local function handleTrapTouch(hitPart: BasePart)
	-- Validamos que la parte y su parent existan
	if not hitPart or not hitPart.Parent then return end

	-- Verificamos si el objeto que tocó tiene un Humanoid (posible Character)
	local humanoid = hitPart.Parent:FindFirstChild("Humanoid")	
	if not humanoid then return end -- No tiene humanoid, no hacemos nada

	-- Confirmamos si pertenece a un jugador (para no afectar NPCs)
	local player = Players:GetPlayerFromCharacter(hitPart.Parent)
	if not player then return end  -- Es un NPC u otro objeto con Humanoid

	-- Si llegamos aquí, es un jugador humano => lo matamos salud en 0
	humanoid.Health = 0
end

-- Configura una part como trampa
local function setupTrap(trapPart: Instance)
	-- Validamos que sea un BasePart
	if not trapPart:IsA("BasePart") then return	end

	-- Conectamos el evento Touched de esta trampa con la función handleTrapTouch
	trapPart.Touched:Connect(handleTrapTouch)
end

-- Configurar trampas existentes al iniciar
for _, trap in CollectionService:GetTagged(TRAP_TAG) do
	setupTrap(trap)
end

-- Configurar nuevas trampas que se agreguen dinámicamente
CollectionService:GetInstanceAddedSignal(TRAP_TAG):Connect(setupTrap)