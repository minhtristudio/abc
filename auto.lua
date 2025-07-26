-- các phần UI giữ nguyên như script trước...

--// Biến điều khiển
local runService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local savedPos = rootPart.Position
local toggle = true
local elevatorIndex = 54

local insideOffset = Vector3.new(0, 2, 0)
local outsideOffset = Vector3.new(0, 5, 0)

--// SAVE button
SaveButton.MouseButton1Click:Connect(function()
	savedPos = rootPart.Position
	print("Saved Position:", savedPos)
end)

--// TOGGLE button
ToggleButton.MouseButton1Click:Connect(function()
	toggle = not toggle
	ToggleButton.Text = toggle and "🟢 ON" or "🔴 OFF"
end)

--// Teleport "nhấp nhả"
task.spawn(function()
	while true do
		task.wait(1) -- cách nhau 1 giây
		if toggle then
			local elevator = workspace:FindFirstChild("Map")
				and workspace.Map:FindFirstChild("World")
				and workspace.Map.World:FindFirstChild("Elevators")
			if elevator then
				local targets = elevator:GetChildren()
				local target = targets[elevatorIndex]
				if target and target:FindFirstChild("Hitbox") then
					-- Di chuyển Hitbox đến vị trí đã lưu
					target.Hitbox.CFrame = CFrame.new(savedPos)

					character = player.Character
					if character and character:FindFirstChild("HumanoidRootPart") then
						rootPart = character.HumanoidRootPart

						-- bước 1: đưa ra ngoài 1 tí
						rootPart.CFrame = CFrame.new(savedPos + outsideOffset)
						task.wait(0.1)

						-- bước 2: đưa lại vào trong Hitbox
						rootPart.CFrame = CFrame.new(savedPos + insideOffset)
					end
				end
			end
		end
	end
end)
