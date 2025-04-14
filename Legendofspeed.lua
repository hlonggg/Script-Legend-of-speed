-- Legends of Speed Script: Cryo-Hub Features with Hyper Hub GUI (Đã thêm Invisible Orbs)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Cài đặt
local AUTO_ALL_ORBS = false
local AUTO_BLUE_ORBS = false
local AUTO_RED_ORBS = false
local AUTO_ORANGE_ORBS = false
local AUTO_YELLOW_ORBS = false
local AUTO_HOOPS = false
local AUTO_REBIRTH = false
local INVISIBLE_ORBS = false -- Thêm toggle cho Invisible Orbs
local SUCK_SPEED = 0.05

-- Phạm vi các đảo (tọa độ X, Y, Z) - Giữ lại để dùng cho Blue/Red/Orange/Yellow Orbs
local IslandRanges = {
    BeginnerIsland = {
        Min = Vector3.new(-2000, 0, -2000),
        Max = Vector3.new(2000, 1000, 2000),
    },
    SpaceIsland = {
        Min = Vector3.new(48000, 0, 48000),
        Max = Vector3.new(52000, 1000, 52000),
    },
    DesertIsland = {
        Min = Vector3.new(98000, 0, 98000),
        Max = Vector3.new(102000, 1000, 102000),
    },
}

-- Hàm kiểm tra xem một điểm có nằm trong phạm vi đảo không
local function IsInRange(position, island)
    local min = island.Min
    local max = island.Max
    return position.X >= min.X and position.X <= max.X and
           position.Y >= min.Y and position.Y <= max.Y and
           position.Z >= min.Z and position.Z <= max.Z
end

-- Hàm xác định đảo hiện tại của nhân vật
local function GetCurrentIsland()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    local position = LocalPlayer.Character.HumanoidRootPart.Position
    for islandName, range in pairs(IslandRanges) do
        if IsInRange(position, range) then
            return range
        end
    end
    return nil
end

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 40)
Topbar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Topbar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 0, 30)
TitleLabel.Position = UDim2.new(0, 10, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🄷🅈🄱🄴🅇🄷🅄🄱"
TitleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
TitleLabel.TextSize = 20
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = Topbar

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -40, 0, 5)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.Text = "X"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16
ToggleButton.Parent = Topbar

-- Folder Container
local FolderContainer = Instance.new("Frame")
FolderContainer.Size = UDim2.new(0, 140, 0, 340)
FolderContainer.Position = UDim2.new(0, 10, 0, 50)
FolderContainer.BackgroundTransparency = 1
FolderContainer.Parent = MainFrame

local FolderList = Instance.new("UIListLayout")
FolderList.Parent = FolderContainer
FolderList.HorizontalAlignment = Enum.HorizontalAlignment.Center
FolderList.SortOrder = Enum.SortOrder.LayoutOrder
FolderList.Padding = UDim.new(0, 5)

-- Container cho các phần tử
local Container = Instance.new("Frame")
Container.Size = UDim2.new(0, 340, 0, 340)
Container.Position = UDim2.new(0, 150, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Danh sách các Elements Frame
local ElementsFrames = {}

-- Pepe Mini Menu
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
PepeImage.Image = "rbxassetid://698916642"
PepeImage.Parent = PepeFrame

-- Hiệu ứng viền cầu vồng
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

-- Kéo thả Pepe Mini Menu
local isDraggingPepe = false
local lastInputPosition = Vector2.new(0, 0)

local function MakePepeMiniMenuDraggable()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if PepeScreenGui.Enabled and not gameProcessed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            local inputPos = input.Position
            local guiPos = PepeFrame.Position
            local guiAbsolutePos = Vector2.new(guiPos.X.Offset, guiPos.Y.Offset)
            local guiSize = PepeFrame.AbsoluteSize
            if inputPos.X >= guiAbsolutePos.X and inputPos.X <= guiAbsolutePos.X + guiSize.X and
               inputPos.Y >= guiAbsolutePos.Y and inputPos.Y <= guiAbsolutePos.Y + guiSize.Y then
                isDraggingPepe = true
                lastInputPosition = inputPos
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(input, gameProcessed)
        if isDraggingPepe and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - lastInputPosition
            local currentPos = PepeFrame.Position
            PepeFrame.Position = UDim2.new(0, currentPos.X.Offset + delta.X, 0, currentPos.Y.Offset + delta.Y)
            lastInputPosition = input.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDraggingPepe = false
        end
    end)
end
MakePepeMiniMenuDraggable()

-- Kéo thả MainFrame
local isDraggingMain = false
local dragStart = Vector2.new(0, 0)
local startPos = MainFrame.Position

Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingMain = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

Topbar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDraggingMain = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingMain and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        MainFrame.Position = position
    end
end)

-- Xử lý thu nhỏ và mở GUI
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

-- Hàm tạo folder
local function createFolder(name)
    local FolderButton = Instance.new("TextButton")
    FolderButton.Size = UDim2.new(1, -10, 0, 30)
    FolderButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    FolderButton.Text = name
    FolderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FolderButton.TextSize = 16
    FolderButton.Font = Enum.Font.SourceSans
    FolderButton.AutoButtonColor = false
    FolderButton.Parent = FolderContainer

    local ElementsFrame = Instance.new("Frame")
    ElementsFrame.Size = UDim2.new(1, 0, 1, 0)
    ElementsFrame.BackgroundTransparency = 1
    ElementsFrame.Visible = false
    ElementsFrame.Parent = Container

    local ElementsList = Instance.new("UIListLayout")
    ElementsList.Parent = ElementsFrame
    ElementsList.SortOrder = Enum.SortOrder.LayoutOrder
    ElementsList.Padding = UDim.new(0, 5)

    ElementsFrames[name] = ElementsFrame

    FolderButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(ElementsFrames) do
            frame.Visible = false
        end
        ElementsFrame.Visible = true
        for _, button in pairs(FolderContainer:GetChildren()) do
            if button:IsA("TextButton") then
                button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            end
        end
        FolderButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    return ElementsFrame
end

-- Tạo các folder
local MainFolder = createFolder("Main")
local MiscFolder = createFolder("Misc")

-- Hàm tạo nút toggle
local function createToggleButton(name, positionY, toggleVar, callback, folder)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 320, 0, 40)
    button.Position = UDim2.new(0, 10, 0, positionY)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Text = name .. ": " .. (toggleVar and "ON" or "OFF")
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Parent = folder
    
    button.MouseButton1Click:Connect(function()
        toggleVar = not toggleVar
        button.Text = name .. ": " .. (toggleVar and "ON" or "OFF")
        button.BackgroundColor3 = toggleVar and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
        callback(toggleVar)
    end)
    return toggleVar
end

-- Hàm tạo slider
local function createSlider(name, positionY, min, max, default, callback, folder)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0, 320, 0, 40)
    sliderFrame.Position = UDim2.new(0, 10, 0, positionY)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderFrame.Parent = folder

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 40)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 16
    label.Parent = sliderFrame

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 100, 0, 20)
    sliderButton.Position = UDim2.new(0, 210, 0, 10)
    sliderButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sliderButton.Text = ""
    sliderButton.Parent = sliderFrame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    fill.BorderSizePixel = 0
    fill.Parent = sliderButton

    local dragging = false
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position.X
            local buttonPos = sliderButton.AbsolutePosition.X
            local buttonSize = sliderButton.AbsoluteSize.X
            local percent = math.clamp((mousePos - buttonPos) / buttonSize, 0, 1)
            local value = min + (max - min) * percent
            value = math.floor(value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = name .. ": " .. value
            callback(value)
        end
    end)

    callback(default)
end

-- Hút tất cả orbs (toàn map, thu thập nhiều orbs cùng lúc)
local function autoCollectAllOrbs(toggle)
    if toggle then
        spawn(function()
            while AUTO_ALL_ORBS do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local orbsToCollect = {}
                    for _, v in pairs(Workspace.orbFolder:GetDescendants()) do
                        if v:IsA("BasePart") then
                            table.insert(orbsToCollect, v)
                        end
                    end
                    for _, orb in ipairs(orbsToCollect) do
                        orb.Position = LocalPlayer.Character.HumanoidRootPart.Position
                    end
                end
                wait(SUCK_SPEED)
            end
        end)
    end
end

-- Hút Blue Orbs (phạm vi đảo, thu thập nhiều orbs cùng lúc)
local function autoCollectBlueOrbs(toggle)
    if toggle then
        spawn(function()
            while AUTO_BLUE_ORBS do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local currentIsland = GetCurrentIsland()
                    if currentIsland then
                        local orbsToCollect = {}
                        for _, v in pairs(Workspace.orbFolder:GetDescendants()) do
                            if v:IsA("BasePart") and v.Parent.Name == "blueOrbs" and IsInRange(v.Position, currentIsland) then
                                table.insert(orbsToCollect, v)
                            end
                        end
                        for _, orb in ipairs(orbsToCollect) do
                            orb.Position = LocalPlayer.Character.HumanoidRootPart.Position
                        end
                    end
                end
                wait(SUCK_SPEED)
            end
        end)
    end
end

-- Hút Red Orbs (phạm vi đảo, thu thập nhiều orbs cùng lúc)
local function autoCollectRedOrbs(toggle)
    if toggle then
        spawn(function()
            while AUTO_RED_ORBS do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local currentIsland = GetCurrentIsland()
                    if currentIsland then
                        local orbsToCollect = {}
                        for _, v in pairs(Workspace.orbFolder:GetDescendants()) do
                            if v:IsA("BasePart") and v.Parent.Name == "redOrbs" and IsInRange(v.Position, currentIsland) then
                                table.insert(orbsToCollect, v)
                            end
                        end
                        for _, orb in ipairs(orbsToCollect) do
                            orb.Position = LocalPlayer.Character.HumanoidRootPart.Position
                        end
                    end
                end
                wait(SUCK_SPEED)
            end
        end)
    end
end

-- Hút Orange Orbs (phạm vi đảo, thu thập nhiều orbs cùng lúc)
local function autoCollectOrangeOrbs(toggle)
    if toggle then
        spawn(function()
            while AUTO_ORANGE_ORBS do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local currentIsland = GetCurrentIsland()
                    if currentIsland then
                        local orbsToCollect = {}
                        for _, v in pairs(Workspace.orbFolder:GetDescendants()) do
                            if v:IsA("BasePart") and v.Parent.Name == "orangeOrbs" and IsInRange(v.Position, currentIsland) then
                                table.insert(orbsToCollect, v)
                            end
                        end
                        for _, orb in ipairs(orbsToCollect) do
                            orb.Position = LocalPlayer.Character.HumanoidRootPart.Position
                        end
                    end
                end
                wait(SUCK_SPEED)
            end
        end)
    end
end

-- Hút Yellow Orbs (EXP Orbs) (phạm vi đảo, thu thập nhiều orbs cùng lúc)
local function autoCollectYellowOrbs(toggle)
    if toggle then
        spawn(function()
            while AUTO_YELLOW_ORBS do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local currentIsland = GetCurrentIsland()
                    if currentIsland then
                        local orbsToCollect = {}
                        for _, v in pairs(Workspace.orbFolder:GetDescendants()) do
                            if v:IsA("BasePart") and v.Parent.Name == "yellowOrbs" and IsInRange(v.Position, currentIsland) then
                                table.insert(orbsToCollect, v)
                            end
                        end
                        for _, orb in ipairs(orbsToCollect) do
                            orb.Position = LocalPlayer.Character.HumanoidRootPart.Position
                        end
                    end
                end
                wait(SUCK_SPEED)
            end
        end)
    end
end

-- Hút Hoops (giữ nguyên)
local function autoCollectHoops(toggle)
    if toggle then
        spawn(function()
            while AUTO_HOOPS do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    for _, v in pairs(Workspace.Hoops:GetDescendants()) do
                        if v:IsA("BasePart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            wait(SUCK_SPEED)
                        end
                    end
                end
                wait(SUCK_SPEED)
            end
        end)
    end
end

-- Auto Rebirth (giữ nguyên)
local function autoRebirth(toggle)
    if toggle then
        spawn(function()
            while AUTO_REBIRTH do
                ReplicatedStorage.Rebirth:InvokeServer()
                wait(1)
            end
        end)
    end
end

-- Làm tất cả orbs vô hình (toàn map)
local function toggleInvisibleOrbs(toggle)
    INVISIBLE_ORBS = toggle
    if toggle then
        for _, v in pairs(Workspace.orbFolder:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency = 1 -- Làm orbs vô hình
            end
        end
        -- Vòng lặp để đảm bảo orbs mới sinh ra cũng vô hình
        spawn(function()
            while INVISIBLE_ORBS do
                for _, v in pairs(Workspace.orbFolder:GetDescendants()) do
                    if v:IsA("BasePart") and v.Transparency ~= 1 then
                        v.Transparency = 1
                    end
                end
                wait(0.1)
            end
        end)
    else
        -- Khôi phục orbs về trạng thái hữu hình
        for _, v in pairs(Workspace.orbFolder:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency = 0
            end
        end
    end
end

-- Điều chỉnh Walkspeed
local function setWalkspeed(value)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end

-- Tạo các toggle và slider
AUTO_ALL_ORBS = createToggleButton("Auto All Orbs", 0, AUTO_ALL_ORBS, function(toggle)
    AUTO_ALL_ORBS = toggle
    autoCollectAllOrbs(toggle)
end, MainFolder)

AUTO_BLUE_ORBS = createToggleButton("Auto Blue Orbs", 40, AUTO_BLUE_ORBS, function(toggle)
    AUTO_BLUE_ORBS = toggle
    autoCollectBlueOrbs(toggle)
end, MainFolder)

AUTO_RED_ORBS = createToggleButton("Auto Red Orbs", 80, AUTO_RED_ORBS, function(toggle)
    AUTO_RED_ORBS = toggle
    autoCollectRedOrbs(toggle)
end, MainFolder)

AUTO_ORANGE_ORBS = createToggleButton("Auto Orange Orbs", 120, AUTO_ORANGE_ORBS, function(toggle)
    AUTO_ORANGE_ORBS = toggle
    autoCollectOrangeOrbs(toggle)
end, MainFolder)

AUTO_YELLOW_ORBS = createToggleButton("Auto EXP Orbs (Yellow)", 160, AUTO_YELLOW_ORBS, function(toggle)
    AUTO_YELLOW_ORBS = toggle
    autoCollectYellowOrbs(toggle)
end, MainFolder)

AUTO_HOOPS = createToggleButton("Auto Collect Hoops", 200, AUTO_HOOPS, function(toggle)
    AUTO_HOOPS = toggle
    autoCollectHoops(toggle)
end, MainFolder)

AUTO_REBIRTH = createToggleButton("Auto Rebirth", 240, AUTO_REBIRTH, function(toggle)
    AUTO_REBIRTH = toggle
    autoRebirth(toggle)
end, MainFolder)

-- Thêm toggle Invisible Orbs
AUTO_INVISIBLE_ORBS = createToggleButton("Invisible Orbs", 280, INVISIBLE_ORBS, function(toggle)
    INVISIBLE_ORBS = toggle
    toggleInvisibleOrbs(toggle)
end, MainFolder)

createSlider("Walkspeed", 0, 16, 250, 16, function(value)
    setWalkspeed(value)
end, MiscFolder)

-- Hiển thị folder "Main" mặc định
ElementsFrames["Main"].Visible = true
FolderContainer:GetChildren()[1].BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Kết nối khi nhân vật tái sinh
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    HumanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")
    Humanoid.WalkSpeed = 16
    if AUTO_ALL_ORBS then autoCollectAllOrbs(true) end
    if AUTO_BLUE_ORBS then autoCollectBlueOrbs(true) end
    if AUTO_RED_ORBS then autoCollectRedOrbs(true) end
    if AUTO_ORANGE_ORBS then autoCollectOrangeOrbs(true) end
    if AUTO_YELLOW_ORBS then autoCollectYellowOrbs(true) end
    if AUTO_HOOPS then autoCollectHoops(true) end
    if AUTO_REBIRTH then autoRebirth(true) end
    if INVISIBLE_ORBS then toggleInvisibleOrbs(true) end
end)

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Thông báo khi tải script
print("🄷🅈🄱🄴🅇🄷🅄🄱 Loaded! Use the menu to toggle features.")
