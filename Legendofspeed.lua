-- Legends of Speed Script: Auto Orb Steps & Auto EXP Orbs with Custom Pepe Menu
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Cài đặt
local AUTO_STEPS_ORBS = false
local AUTO_EXP_ORBS = false
local SUCK_SPEED = 0.05

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 0, 30)
TitleLabel.Position = UDim2.new(0, 10, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🄷🅈🄱🄴🅁🄷🅄🄱"
TitleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -40, 0, 5)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.Text = "X"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Parent = MainFrame

-- Tạo Pepe mini menu
local PepeScreenGui = Instance.new("ScreenGui")
PepeScreenGui.Name = "PepeMiniMenu"
PepeScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
PepeScreenGui.Enabled = false
PepeScreenGui.ResetOnSpawn = false

local PepeFrame = Instance.new("Frame")
PepeFrame.Size = UDim2.new(0, 50, 0, 50)
PepeFrame.Position = UDim2.new(0, 50, 0, 50)
PepeFrame.BackgroundTransparency = 1
PepeFrame.Parent = PepeScreenGui

local PepeImage = Instance.new("ImageLabel")
PepeImage.Size = UDim2.new(1, 0, 1, 0)
PepeImage.BackgroundTransparency = 1
PepeImage.Image = "rbxassetid://698916642" -- ID của hình Pepe the Frog
PepeImage.Parent = PepeFrame

-- Hiệu ứng viền cầu vồng cho MainFrame
local function RainbowBorder()
    spawn(function()
        while true do
            for i = 0, 1, 0.01 do
                local hue = i
                local color = Color3.fromHSV(hue, 1, 1)
                MainFrame.BorderColor3 = color
                MainFrame.BorderSizePixel = 2
                wait(0.05)
            end
        end
    end)
end
RainbowBorder()

-- Biến để theo dõi trạng thái kéo thả
local isDragging = false
local lastInputPosition = Vector2.new(0, 0)

-- Hàm xử lý kéo thả Pepe mini menu
local function MakePepeMiniMenuDraggable()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if PepeScreenGui.Enabled and not gameProcessed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            local inputPos = input.Position
            local guiPos = PepeFrame.Position
            local guiAbsolutePos = Vector2.new(guiPos.X.Offset, guiPos.Y.Offset)
            local guiSize = PepeFrame.AbsoluteSize
            if inputPos.X >= guiAbsolutePos.X and inputPos.X <= guiAbsolutePos.X + guiSize.X and
               inputPos.Y >= guiAbsolutePos.Y and inputPos.Y <= guiAbsolutePos.Y + guiSize.Y then
                isDragging = true
                lastInputPosition = inputPos
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - lastInputPosition
            local currentPos = PepeFrame.Position
            PepeFrame.Position = UDim2.new(0, currentPos.X.Offset + delta.X, 0, currentPos.Y.Offset + delta.Y)
            lastInputPosition = input.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
end
MakePepeMiniMenuDraggable()

-- Xử lý nút thu nhỏ
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    PepeScreenGui.Enabled = true
end)

PepeImage.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        MainFrame.Visible = true
        PepeScreenGui.Enabled = false
    end
end)

-- Hàm tạo nút toggle
local function createToggleButton(name, positionY, toggleVar, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 360, 0, 40)
    button.Position = UDim2.new(0, 20, 0, positionY)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = name .. ": " .. (toggleVar and "ON" or "OFF")
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Parent = MainFrame
    
    button.MouseButton1Click:Connect(function()
        toggleVar = not toggleVar
        button.Text = name .. ": " .. (toggleVar and "ON" or "OFF")
        button.BackgroundColor3 = toggleVar and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
        callback(toggleVar)
    end)
    return toggleVar
end

-- Hút Steps Orbs (Blue, Red, Orange)
local function autoCollectStepsOrbs(toggle)
    if toggle then
        spawn(function()
            while AUTO_STEPS_ORBS do
                for _, v in pairs(Workspace.orbFolder:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name == "Blue Orb" or v.Name == "Red Orb" or v.Name == "Orange Orb") then
                        v.Transparency = 1
                        v.Position = HumanoidRootPart.Position
                    end
                end
                wait(SUCK_SPEED)
            end
        end)
    end
end

-- Hút EXP Orbs (Yellow Orbs)
local function autoCollectEXPOrbs(toggle)
    if toggle then
        spawn(function()
            while AUTO_EXP_ORBS do
                for _, v in pairs(Workspace.orbFolder:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name == "Yellow Orb" then
                        v.Transparency = 1
                        v.Position = HumanoidRootPart.Position
                    end
                end
                wait(SUCK_SPEED)
            end
        end)
    end
end

-- Tạo nút toggle
AUTO_STEPS_ORBS = createToggleButton("Auto Steps Orbs (Blue, Red, Orange)", 50, AUTO_STEPS_ORBS, function(toggle)
    AUTO_STEPS_ORBS = toggle
    autoCollectStepsOrbs(toggle)
end)

AUTO_EXP_ORBS = createToggleButton("Auto EXP Orbs (Yellow)", 100, AUTO_EXP_ORBS, function(toggle)
    AUTO_EXP_ORBS = toggle
    autoCollectEXPOrbs(toggle)
end)

-- Kết nối khi nhân vật tái sinh
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    if AUTO_STEPS_ORBS then
        autoCollectStepsOrbs(true)
    end
    if AUTO_EXP_ORBS then
        autoCollectEXPOrbs(true)
    end
end)

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Thông báo khi tải script
print("🄷🅈🄱🄴🅁🄷🅄🄱 Loaded! Use the menu to toggle features.")
