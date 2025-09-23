-- Metodo 2
-- Referencia a la parte que actuará como trampa (donde está insertado este Script)
local trapPart = script.Parent

-- Función que se ejecutará cada vez que algo toque la trampa
local function onTouch(otherPart)
	-- Verificamos si el objeto que tocó pertenece a un personaje
	local character = otherPart.Parent
	if not character then
		return -- Si no tiene parent, salimos
	end

	-- Intentamos encontrar el Humanoid dentro del "character"
	local humanoid = character:FindFirstChild("Humanoid")

	-- Validación: solo eliminamos si efectivamente es un humanoid
	if humanoid then
		-- Eliminamos al jugador estableciendo su salud en 0
		humanoid.Health = 0
	end
end

-- Conectar el evento Touched de la parte con la función
trapPart.Touched:Connect(onTouch)