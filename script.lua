local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService('ReplicatedStorage')
local workspace = game:GetService('Workspace')
local runService = game:GetService('RunService')

-- Auto Sell
spawn(function()
    while wait(5) do
        replicatedStorage.Events.Sell:FireServer()
    end
end)

-- Auto Equip Best Pets
spawn(function()
    while wait(10) do
        replicatedStorage.Events.EquipBest:FireServer()
    end
end)

-- Auto Use Golden Orbs
spawn(function()
    while wait(1) do
        for _, orb in pairs(workspace.GoldenOrbs:GetChildren()) do
            if orb:IsA('Part') and orb:FindFirstChild('TouchInterest') then
                firetouchinterest(player.Character.HumanoidRootPart, orb, 0)
                firetouchinterest(player.Character.HumanoidRootPart, orb, 1)
            end
        end
    end
end)

-- Auto Use Mystery Boxes
spawn(function()
    while wait(5) do
        replicatedStorage.Events.OpenMysteryBox:FireServer()
    end
end)

-- Egg Lag (Reduces Lag when opening Eggs)
spawn(function()
    while wait(2) do
        replicatedStorage.Events.ReduceEggLag:FireServer()
    end
end)

-- Rift Luck Filter
spawn(function()
    while wait(5) do
        replicatedStorage.Events.ApplyRiftLuck:FireServer()
    end
end)

-- Auto Use Potions
spawn(function()
    while wait(5) do
        replicatedStorage.Events.UsePotions:FireServer()
    end
end)

-- Auto Mastery
spawn(function()
    while wait(10) do
        replicatedStorage.Events.CompleteMastery:FireServer()
    end
end)

-- Pet Spawner
local UIS = game:GetService('UserInputService')
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.P and not gameProcessed then
        local petName = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('PetInputBox').Text
        replicatedStorage.Events.SpawnPet:FireServer(petName)
    end
end)

-- Create GUI for Pet Spawner
local ScreenGui = Instance.new('ScreenGui')
local TextBox = Instance.new('TextBox')

ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
TextBox.Parent = ScreenGui

TextBox.Size = UDim2.new(0, 200, 0, 50)
TextBox.Position = UDim2.new(0.5, -100, 0.5, -25)
TextBox.PlaceholderText = "Enter Pet Name"
TextBox.Text = ""
TextBox.Name = "PetInputBox"
TextBox.TextScaled = true
TextBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.ClearTextOnFocus = false
