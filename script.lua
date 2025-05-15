local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService('ReplicatedStorage')
local workspace = game:GetService('Workspace')
local runService = game:GetService('RunService')

-- GUI Elements
local ScreenGui = Instance.new('ScreenGui')
local MainFrame = Instance.new('Frame')
local UIListLayout = Instance.new('UIListLayout')

ScreenGui.Name = 'BGSI_Control_Panel'
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Size = UDim2.new(0, 200, 0, 400)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.Visible = true

UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local toggles = {}

function createToggle(name, callback)
    local button = Instance.new('TextButton')
    button.Parent = MainFrame
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Text = name
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        button.BackgroundColor3 = toggles[name] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        callback(toggles[name])
    end)
end

-- Toggle Functions
createToggle('Auto Sell', function(state)
    spawn(function()
        while state do
            wait(5)
            replicatedStorage.Events.Sell:FireServer()
        end
    end)
end)

createToggle('Auto Equip Best Pets', function(state)
    spawn(function()
        while state do
            wait(10)
            replicatedStorage.Events.EquipBest:FireServer()
        end
    end)
end)

createToggle('Auto Use Golden Orbs', function(state)
    spawn(function()
        while state do
            wait(1)
            for _, orb in pairs(workspace.GoldenOrbs:GetChildren()) do
                if orb:IsA('Part') and orb:FindFirstChild('TouchInterest') then
                    firetouchinterest(player.Character.HumanoidRootPart, orb, 0)
                    firetouchinterest(player.Character.HumanoidRootPart, orb, 1)
                end
            end
        end
    end)
end)

createToggle('Auto Use Mystery Boxes', function(state)
    spawn(function()
        while state do
            wait(5)
            replicatedStorage.Events.OpenMysteryBox:FireServer()
        end
    end)
end)

createToggle('Egg Lag', function(state)
    spawn(function()
        while state do
            wait(2)
            replicatedStorage.Events.ReduceEggLag:FireServer()
        end
    end)
end)

createToggle('Rift Luck Filter', function(state)
    spawn(function()
        while state do
            wait(5)
            replicatedStorage.Events.ApplyRiftLuck:FireServer()
        end
    end)
end)

createToggle('Auto Use Potions', function(state)
    spawn(function()
        while state do
            wait(5)
            replicatedStorage.Events.UsePotions:FireServer()
        end
    end)
end)

createToggle('Auto Mastery', function(state)
    spawn(function()
        while state do
            wait(10)
            replicatedStorage.Events.CompleteMastery:FireServer()
        end
    end)
end)

-- Pet Spawner
createToggle('Pet Spawner', function(state)
    if state then
        local petName = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('PetInputBox').Text
        replicatedStorage.Events.SpawnPet:FireServer(petName)
    end
end)
