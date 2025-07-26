--// UI Library cho mobile executor
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local SaveButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

-- Cho phép GUI hiển thị trên mobile
ScreenGui.Parent = game.CoreGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Size = UDim2.new(0, 160, 0, 80)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

ToggleButton.Size = UDim2.new(0, 140, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
ToggleButton.Text = "🟢 ON"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Parent = Frame

SaveButton.Size = UDim2.new(0, 140, 0, 30)
SaveButton.Position = UDim2.new(0, 10, 0, 45)
SaveButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
SaveButton.Text = "💾 SAVE POS"
SaveButton.TextColor3 = Color3.new(1, 1, 1)
SaveButton.Parent = Frame

--// Variables
local runService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local savedPos = rootPart.Position
local toggle = true
local elevatorIndex = 54

--// Save button
SaveButton.MouseButton1Click:Connect(function()
	savedPos = rootPart.Position
	print("Saved Position:", savedPos)
end)

--// Toggle button
ToggleButton.MouseButton1Click:Connect(function()
	toggle = not toggle
	ToggleButton.Text = toggle and "🟢 ON" or "🔴 OFF"
end)

--// Teleport loop
task.spawn(function()
	while true do
		task.wait(0.1)
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
					-- Dịch chuyển người chơi vào Hitbox
					character = player.Character
					if character and character:FindFirstChild("HumanoidRootPart") then
						rootPart = character.HumanoidRootPart
						rootPart.CFrame = CFrame.new(savedPos + Vector3.new(0, 2, 0)) -- đảm bảo nằm trong Hitbox
					end
				end
			end
		end
	end
end)
