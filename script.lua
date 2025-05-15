local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService('ReplicatedStorage')
local workspace = game:GetService('Workspace')
local runService = game:GetService('RunService')

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/siradaniy/robloxscripts/main/ui_library.lua'))()
local window = library:CreateWindow('BGSI Control Panel')

local toggles = {
    autoSell = false,
    equipBest = false,
    goldenOrbs = false,
    mysteryBoxes = false,
    eggLag = false,
    riftLuck = false,
    usePotions = false,
    mastery = false
}

window:Toggle('Auto Sell', function(state)
    toggles.autoSell = state
end)

window:Toggle('Auto Equip Best Pets', function(state)
    toggles.equipBest = state
end)

window:Toggle('Auto Use Golden Orbs', function(state)
    toggles.goldenOrbs = state
end)

window:Toggle('Auto Use Mystery Boxes', function(state)
    toggles.mysteryBoxes = state
end)

window:Toggle('Egg Lag', function(state)
    toggles.eggLag = state
end)

window:Toggle('Rift Luck Filter', function(state)
    toggles.riftLuck = state
end)

window:Toggle('Auto Use Potions', function(state)
    toggles.usePotions = state
end)

window:Toggle('Auto Mastery', function(state)
    toggles.mastery = state
end)

-- Background Loops
spawn(function()
    while wait(1) do
        if toggles.autoSell then
            replicatedStorage.Events.Sell:FireServer()
        end
        if toggles.equipBest then
            replicatedStorage.Events.EquipBest:FireServer()
        end
        if toggles.goldenOrbs then
            for _, orb in pairs(workspace.GoldenOrbs:GetChildren()) do
                if orb:IsA('Part') and orb:FindFirstChild('TouchInterest') then
                    firetouchinterest(player.Character.HumanoidRootPart, orb, 0)
                    firetouchinterest(player.Character.HumanoidRootPart, orb, 1)
                end
            end
        end
        if toggles.mysteryBoxes then
            replicatedStorage.Events.OpenMysteryBox:FireServer()
        end
        if toggles.eggLag then
            replicatedStorage.Events.ReduceEggLag:FireServer()
        end
        if toggles.riftLuck then
            replicatedStorage.Events.ApplyRiftLuck:FireServer()
        end
        if toggles.usePotions then
            replicatedStorage.Events.UsePotions:FireServer()
        end
        if toggles.mastery then
            replicatedStorage.Events.CompleteMastery:FireServer()
        end
    end
end)
