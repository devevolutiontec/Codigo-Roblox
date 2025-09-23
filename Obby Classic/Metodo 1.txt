-- Metodo 1
-- Función que se ejecutará cada vez que algo toque la trampa
script.Parent.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	
	if hit and character and humanoid then
		hit.Parent.Humanoid.Health = 0
	end
end)