-- Servicio de Roblox para gestionar jugadores
local players = game:GetService("Players")
-- Carpeta donde están todos los checkpoints dentro del Workspace
local checkPointsFolder =  workspace:WaitForChild("Checkpoints")
-- Tabla para guardar los checkpoints organizados por índice
local checkpointParts = {}

-- 🔹 Recorremos cada objeto en la carpeta de checkpoints
for _, part in ipairs(checkPointsFolder:GetChildren()) do
	if part:IsA("BasePart") and part.Name:match("^Checkpoint_%d+$") then
		-- Extraemos el número del nombre (ejemplo: "Checkpoint_5" → 5)
		local checkpointIndex  = tonumber(part.Name:match("%d+"))
		
		-- Guardamos la referencia en la tabla para acceso rápido
		checkpointParts[checkpointIndex ] = part
		
		-- Evento cuando un jugador toca este checkpoint
		part.Touched:Connect(function(hit)
			-- Validamos que el objeto tocado pertenezca a un jugador
			local player = game.Players:GetPlayerFromCharacter(hit.Parent)
			if not player then return end

			local playerHRP = player.Character:FindFirstChild("HumanoidRootPart")
			if not playerHRP then return end
			
			-- Buscamos las estadísticas de progreso del jugador
			local leaderstats = player:FindFirstChild("leaderstats")
			if not leaderstats then return end
			
			local checkpointStat = leaderstats:FindFirstChild("Checkpoint")
			local coinStat = leaderstats:FindFirstChild("Coins") 
						
			if not checkpointStat then return end

			-- Comparamos si este checkpoint es mayor al último guardado
			if checkpointIndex > checkpointStat.Value then
				checkpointStat.Value = checkpointIndex
			end
		end)	
	end
end

-- 🔹 Función para configurar a un jugador cuando entra al juego
local function onPlayerAdded(player: Player)
	-- Creamos la carpeta leaderstats (necesaria para mostrar valores en la tabla de Roblox)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	-- Monedas iniciales
	local coinStat = Instance.new("IntValue")
	coinStat.Name = "Coins"
	coinStat.Value = 0
	coinStat.Parent = leaderstats

	-- Checkpoint inicial
	local checkpointStat = Instance.new("IntValue", leaderstats)
	checkpointStat.Name = "Checkpoint"
	checkpointStat.Value = 1

	local function spawnAtCheckpoint()
		local character = player.Character or player.CharacterAdded.Wait()
		character:WaitForChild("HumanoidRootPart")
		
		-- Obtener el índice del checkpoint guardado
		local index = player.leaderstats.Checkpoint.Value
		local part = checkpointParts[index]
		
		-- Reaparecer 5 studs arriba del checkpoint para evitar bugs
		if part then
			character:SetPrimaryPartCFrame(part.CFrame + Vector3.new(0, 5, 0))
		end		
	end	
	
	-- Función cuando el jugador muere
	local function onCharacterDied()
		task.wait()
		player:LoadCharacter() -- Recargar personaje automáticamente
	end	
	
	-- Configuración cada vez que aparece el personaje
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")		
		-- Conectamos evento de muerte
		humanoid.Died:Connect(onCharacterDied)	
		
		-- Reposicionar en el checkpoint guardado
		task.wait()
		spawnAtCheckpoint()
	end)
end

-- 🔹 Función llamada cuando un jugador se desconecta
local function onPlayerRemoving(player: Player)
	-- Aquí se podrían guardar estadísticas en DataStore
end

-- 🔹 Inicializar el sistema
local function initialize()
	players.PlayerAdded:Connect(onPlayerAdded)
	players.PlayerRemoving:Connect(onPlayerRemoving)
end

initialize()
