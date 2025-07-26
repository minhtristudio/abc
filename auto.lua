--// UI Giao diện di động
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local SaveButton = Instance.new("TextButton")
local UICorner1 = Instance.new("UICorner")
local UICorner2 = Instance.new("UICorner")
local UICorner3 = Instance.new("UICorner")

-- Đảm bảo script chạy trong PlayerGui hoặc CoreGui
ScreenGui.Name = "TeleportGui"
ScreenGui.ResetOnSpawn = false
pcall(function()
    ScreenGui.Parent = game.CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- UI Frame
Frame.Size = UDim2.new(0, 160, 0, 80)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui
UICorner1.CornerRadius = UDim.new(0, 12)
UICorner1.Parent = Frame

-- Toggle Button
ToggleButton.Size = UDim2.new(0, 140, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
ToggleButton.Text = "🟢 ON"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16
ToggleButton.Parent = Frame
UICorner2.Parent = ToggleButton

-- Save Button
SaveButton.Size = UDim2.new(0, 140, 0, 30)
SaveButton.Position = UDim2.new(0, 10, 0, 45)
SaveButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
SaveButton.Text = "💾 SAVE POS"
SaveButton.TextColor3 = Color3.new(1, 1, 1)
SaveButton.Font = Enum.Font.SourceSansBold
SaveButton.TextSize = 16
SaveButton.Parent = Frame
UICorner3.Parent = SaveButton

--// Biến điều khiển
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local runService = game:GetService("RunService")
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
local savedPos = rootPart.Position
local toggle = true
local elevatorIndex = 54

-- Dịch ra - vào
local insideOffset = Vector3.new(0, 2, 0)
local outsideOffset = Vector3.new(0, 5, 0)

-- SAVE Button
SaveButton.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        savedPos = player.Character.HumanoidRootPart.Position
        print("💾 Saved Position:", savedPos)
    end
end)

-- TOGGLE Button
ToggleButton.MouseButton1Click:Connect(function()
    toggle = not toggle
    ToggleButton.Text = toggle and "🟢 ON" or "🔴 OFF"
end)

-- Teleport loop (nhấp ra - vào)
task.spawn(function()
    while true do
        task.wait(1)
        if toggle then
            local elevatorFolder = workspace:FindFirstChild("Map")
                and workspace.Map:FindFirstChild("World")
                and workspace.Map.World:FindFirstChild("Elevators")
            if elevatorFolder then
                local elevators = elevatorFolder:GetChildren()
                local target = elevators[elevatorIndex]
                if target and target:FindFirstChild("Hitbox") then
                    -- Di chuyển hitbox đến vị trí đã lưu
                    target.Hitbox.CFrame = CFrame.new(savedPos)

                    -- Dịch chuyển người chơi ra - vào để kích hoạt va chạm
                    character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        rootPart = character.HumanoidRootPart
                        rootPart.CFrame = CFrame.new(savedPos + outsideOffset)
                        task.wait(0.1)
                        rootPart.CFrame = CFrame.new(savedPos + insideOffset)
                    end
                end
            end
        end
    end
end)
