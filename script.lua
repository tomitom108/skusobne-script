local success, WindUI = pcall(function()
    print("Attempting to load WindUI...")
    local result = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    print("WindUI loaded successfully.")
    return result
end)

if not success or not WindUI then
    warn("Failed to load WindUI: " .. tostring(WindUI))
    game:GetService("Players").LocalPlayer:Kick("Failed to load UI library. Please check your network or the script URL.")
    return
end

print("Script running on client at: " .. os.date("%H:%M:%S %d/%m/%Y"))

local isMobile = (game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled)
local windowSize = isMobile and UDim2.fromOffset(350, 400) or UDim2.fromOffset(580, 460)
local sidebarWidth = 200

local success, Window = pcall(function()
    return WindUI:CreateWindow({
        Title = "Grow a Garden Script Hub - discord.gg/BgESyY5vQr",
        Icon = "flower-2",
        Author = "by InfernoLum",
        Folder = "",
        Size = windowSize,
        Transparent = false,
        Theme = "Dark",
        SideBarWidth = sidebarWidth,
        Background = "",
        User = {
            Enabled = true,
            Anonymous = true,
            Callback = function() print("User callback triggered") end,
        },
    })
end)

if not success or not Window then
    warn("Failed to create Window: " .. tostring(Window))
    return
end
print("Window created successfully.")

local Tabs = {
    VisualTab = Window:Tab({ Title = "Visual", Icon = "eye" }),
    SpawnerTab = Window:Tab({ Title = "Spawners", Icon = "sprout" }),
    DupeTab = Window:Tab({ Title = "Dupe", Icon = "zap" }),
    CommunityTab = Window:Tab({ Title = "Discord", Icon = "globe" }),
    SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" }),
}

-- Visual Tab (Unchanged)
Tabs.VisualTab:Paragraph({
    Title = "Visuals",
    Desc = "Manage your in-game visuals and economy",
    Image = "eye"
})

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local moneyLabel = localPlayer.PlayerGui:WaitForChild("Sheckles_UI"):WaitForChild("Money")
local leaderstats = localPlayer:FindFirstChild("leaderstats")

local inputMoney = "99999999999999"

Tabs.VisualTab:Input({
    Title = "Set Money Amount",
    Desc = "Enter a number (e.g. 1000000)",
    Value = inputMoney,
    Placeholder = "Enter numeric amount",
    Callback = function(value)
        inputMoney = value
        print("Money input set to: " .. value)
    end,
})

Tabs.VisualTab:Button({
    Title = "Apply Money",
    Callback = function()
        print("Applying money: " .. inputMoney)
        moneyLabel.Text = inputMoney
        local numValue = tonumber(inputMoney)
        if numValue and leaderstats and leaderstats:FindFirstChild("Sheckles") then
            leaderstats.Sheckles.Value = numValue
            WindUI:Notify({
                Title = "Success",
                Content = "Money set to " .. inputMoney,
                Icon = "check",
                Duration = 5,
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Failed to set money. Check leaderstats.",
                Icon = "alert-circle",
                Duration = 5,
            })
        end
    end,
})

Tabs.VisualTab:Section({ Title = "Sheckles", Desc = "Your sheckles" })

local playerGui = localPlayer:WaitForChild("PlayerGui")
local shecklesUI = playerGui:WaitForChild("Sheckles_UI")
local textLabel = shecklesUI:WaitForChild("TextLabel")
local inputText = "9999999999"

local function formatNumber(num)
    local formatted = tostring(num)
    formatted = formatted:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    if formatted:sub(1,1) == "," then
        formatted = formatted:sub(2)
    end
    return formatted
end

Tabs.VisualTab:Input({
    Title = "Set Money Amount (Smooth)",
    Desc = "Enter a numeric amount",
    Value = inputText,
    Placeholder = "e.g. 1000000",
    Callback = function(value)
        inputText = value
        print("Smooth money input set to: " .. value)
    end,
})

Tabs.VisualTab:Button({
    Title = "Apply Money (Smooth)",
    Callback = function()
        local target = tonumber(inputText)
        if not target then
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a valid number.",
                Icon = "alert-circle",
                Duration = 5,
            })
            return
        end

        local shecklesStat = leaderstats and leaderstats.Sheckles
        if not shecklesStat then
            WindUI:Notify({
                Title = "Error",
                Content = "Sheckles stat not found.",
                Icon = "alert-circle",
                Duration = 5,
            })
            return
        end

        print("Applying smooth money: " .. target)
        local current = shecklesStat.Value
        local step = (target - current) / 50
        for i = 1, 50 do
            current = current + step
            shecklesStat.Value = math.floor(current)
            textLabel.Text = formatNumber(math.floor(current)) .. " ¢"
            task.wait(0.02)
        end

        shecklesStat.Value = target
        textLabel.Text = formatNumber(target) .. " ¢"
        WindUI:Notify({
            Title = "Success",
            Content = "Money smoothly set to " .. target,
            Icon = "check",
            Duration = 5,
        })
    end,
})

Tabs.VisualTab:Section({ Title = "NPC Money", Desc = "Your sheckles" })

local sellAmount = "999999"
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNewIndex = mt.__newindex
local hookEnabled = false

local function enableHook()
    hookEnabled = true
    print("NPC sell hook enabled")
end

local function disableHook()
    hookEnabled = false
    print("NPC sell hook disabled")
end

mt.__newindex = newcclosure(function(t, k, v)
    if hookEnabled and typeof(t) == "Instance" and t:IsA("TextLabel") and k == "Text" then
        if typeof(v) == "string" and v:match("Here is") and v:match("¢") then
            v = ("Here is <font color='#FFFF00'>%s¢</font>"):format(sellAmount)
        end
    end
    return oldNewIndex(t, k, v)
end)
setreadonly(mt, true)

Tabs.VisualTab:Input({
    Title = "Sell Amount",
    Default = sellAmount,
    PlaceholderText = "Enter amount (numbers only)",
    Callback = function(input)
        if input:match("^%d+$") then
            sellAmount = input
            print("Sell amount set to: " .. input)
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a valid number.",
                Icon = "alert-circle",
                Duration = 5,
            })
        end
    end
})

Tabs.VisualTab:Button({
    Title = "Activate Sell",
    Callback = function()
        print("Activating NPC sell")
        local ProximityPrompt = workspace.NPCS:FindFirstChild("Steven", true)
            and workspace.NPCS.Steven.HumanoidRootPart:FindFirstChild("ProximityPrompt")
            and workspace.NPCS.Steven.HumanoidRootPart.ProximityPrompt:FindFirstChild("SellNPC")

        if ProximityPrompt then
            enableHook()
            ProximityPrompt:InputHoldBegin()
            ProximityPrompt:InputHoldEnd()
            disableHook()
            WindUI:Notify({
                Title = "Success",
                Content = "NPC sell activated for " .. sellAmount .. "¢",
                Icon = "check",
                Duration = 5,
            })
        else
            WindUI:Notify({
                Title = "Error",
                Content = "NPC or ProximityPrompt not found.",
                Icon = "alert-circle",
                Duration = 5,
            })
        end
    end
})

Tabs.VisualTab:Section({ Title = "Steal Item", Desc = "" })

local seedName = ""

Tabs.VisualTab:Input({
    Title = "Seed Name",
    Default = "",
    PlaceholderText = "Type seed name here",
    Callback = function(text)
        seedName = text:match("^%s*(.-)%s*$")
        print("Steal seed name set to: " .. seedName)
    end
})

Tabs.VisualTab:Button({
    Title = "Steal Person's Inventory",
    Callback = function()
        if not seedName or seedName == "" then
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a seed name first.",
                Icon = "alert-circle",
                Duration = 5,
            })
            return
        end

        print("Attempting to steal seed: " .. seedName)
        local found = false
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player:FindFirstChild("Backpack") then
                for _, item in pairs(player.Backpack:GetChildren()) do
                    if item.Name:lower() == seedName:lower() then
                        item:Clone().Parent = game.Players.LocalPlayer.Backpack
                        found = true
                        break
                    end
                end
            end
            if found then break end
        end

        if found then
            WindUI:Notify({
                Title = "Success",
                Content = "Player's seed sent to your backpack!",
                Icon = "check",
                Duration = 5,
            })
        else
            WindUI:Notify({
                Title = "Not Found",
                Content = "Could not find seed with that name.",
                Icon = "alert-circle",
                Duration = 5,
            })
        end
    end
})

Tabs.VisualTab:Button({
    Title = "Steal All Player Items",
    Callback = function()
        print("Stealing all player items")
        for _, v in pairs(game.Players:GetChildren()) do
            if v ~= game.Players.LocalPlayer and v.Backpack then
                for _, b in pairs(v.Backpack:GetChildren()) do
                    b:Clone().Parent = game.Players.LocalPlayer.Backpack
                    task.wait()
                end
            end
        end
        WindUI:Notify({
            Title = "Success",
            Content = "All player items cloned to your backpack!",
            Icon = "check",
            Duration = 5,
        })
    end
})

-- Spawners Tab
Tabs.SpawnerTab:Section({ Title = "Seed Spawner", Desc = "Spawn seeds for your garden" })

local seed = ""
local seedQuantity = "1"
local seeds = {
    "Carrot", "Tomato", "Strawberry", "Blueberry", "Corn", "Pumpkin", "Watermelon", "Apple", "Coconut",
    "Dragon Fruit", "Super", "Bamboo", "Raspberry", "Pineapple", "Peach", "Cactus", "Grape", "Pear",
    "Eggplant", "Purple Cabbage", "Lemon", "Chocolate Carrot", "Easter Egg", "Orange Tulip", "Pink Tulip",
    "Crocus", "Daffodil", "Cherry Blossom", "Red Lollipop", "Blue Lollipop", "Candy Sunflower", "Banana",
    "Passionfruit", "Cursed Fruit", "Lotus", "Papaya", "Soul Fruit", "Mega Mushroom", "Mango",
    "Venus Fly Trap", "Cranberry", "Durian", "Succulent", "Candy Blossom", "Mushroom", "Nightshade",
    "Avocado", "Pepper", "Moon Blossom", "Moonglow", "Starfruit", "Moonflower", "Mint", "Glowshroom",
    "Cacao", "Beanstalk", "Crimson Vine", "Moon Melon", "Blood Banana", "Moon Mango", "Celestiberry"
}

Tabs.SpawnerTab:Dropdown({
    Title = "Select Seed",
    Desc = "Choose a seed to spawn",
    Values = seeds,
    Default = "",
    Callback = function(value)
        seed = value
        print("Selected seed: " .. value)
    end
})

Tabs.SpawnerTab:Input({
    Title = "Seed Quantity",
    Desc = "Number of seeds to spawn",
    Value = seedQuantity,
    Placeholder = "e.g. 1",
    Callback = function(value)
        if value:match("^%d+$") then
            seedQuantity = value
            print("Seed quantity set to: " .. value)
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a valid number.",
                Icon = "alert-circle",
                Duration = 5,
            })
        end
    end,
})

Tabs.SpawnerTab:Button({
    Title = "Spawn Seed",
    Callback = function()
        if seed == "" then
            WindUI:Notify({
                Title = "Error",
                Content = "Please select a seed.",
                Icon = "alert-circle",
                Duration = 5,
            })
            return
        end

        local qty = tonumber(seedQuantity) or 1
        if qty <= 0 then
            WindUI:Notify({
                Title = "Error",
                Content = "Quantity must be greater than 0.",
                Icon = "alert-circle",
                Duration = 5,
            })
            return
        end

        print("Spawning seed: " .. seed .. " x" .. qty)
        local seedModels = game:GetService("ReplicatedStorage"):FindFirstChild("Seed_Models")
        if not seedModels then
            WindUI:Notify({
                Title = "Error",
                Content = "Seed_Models not found in ReplicatedStorage.",
                Icon = "alert-circle",
                Duration = 5,
            })
            return
        end

        local found = false
        local model
        for _, v in pairs(seedModels:GetChildren()) do
            if tostring(v.Name):lower() == seed:lower() then
                model = v
                found = true
                break
            end
        end

        if not found then
            WindUI:Notify({
                Title = "Error",
                Content = "Seed '" .. seed .. "' not found in Seed_Models.",
                Icon = "alert-circle",
                Duration = 5,
            })
            return
        end

        local backpack = game.Players.LocalPlayer.Backpack
        local existingTool = nil
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:match(seed .. " Seed %[X%d+]$") then
                existingTool = tool
                break
            end
        end

        if existingTool then
            local currentQty = tonumber(existingTool.Name:match("%[X(%d+)]$")) or 0
            local newQty = currentQty + qty
            existingTool.Name = seed .. " Seed [X" .. newQty .. "]"
            WindUI:Notify({
                Title = "Success",
                Content = "Updated " .. seed .. " Seed to [X" .. newQty .. "]",
                Icon = "check",
                Duration = 5,
            })
        else
            local tool = Instance.new("Tool")
            tool.Name = seed .. " Seed [X" .. qty .. "]"
            tool.GripPos = Vector3.new(0.2, -0.45, 0.23)
            tool.Parent = backpack

            local handle = model:Clone()
            handle.Name = "Handle"
            handle.Parent = tool

            WindUI:Notify({
                Title = "Success",
                Content = "Spawned " .. seed .. " Seed [X" .. qty .. "]",
                Icon = "check",
                Duration = 5,
            })
        end
    end
})

Tabs.SpawnerTab:Section({ Title = "Pet Spawner", Desc = "Spawn pets for your garden" })

local pet = ""
local petQuantity = "1"
local petWeight = ""
local pets = {
    "Queen Bee", "Red Fox", "Dragonfly", "Raccoon", "Golden Bee", "Mole", "Cow", "Chicken Zombie",
    "Sea Otter", "Silver Monkey", "Squirrel", "Polar Bear", "Praying Mantis", "Bee", "Red Giant Ant",
    "Blood Owl", "Blood Kiwi", "Blood Hedgehog", "Moon Cat", "Snail"
}

Tabs.SpawnerTab:Dropdown({
    Title = "Select Pet",
    Desc = "Choose a pet to spawn",
    Values = pets,
    Default = "",
    Callback = function(value)
        pet = value
        print("Selected pet: " .. value)
    end
})

Tabs.SpawnerTab:Input({
    Title = "Pet Quantity",
    Desc = "Number of pets to spawn",
    Value = petQuantity,
    Placeholder = "e.g. 1",
    Callback = function(value)
        if value:match("^%d+$") then
            petQuantity = value
            print("Pet quantity set to: " .. value)
        else
            WindUI:Notify({
                Title = "Error",
                Content = "Please enter a valid number.",
                Icon = "alert-circle",
                Duration = 5,
            })
        end
    end,
})

Tabs.SpawnerTab:Input({
    Title = "Pet Weight (KG)",
    Desc = "Enter weight (optional, random if blank)",
    Value = petWeight,
    Placeholder = "e.g. 4",
    Callback = function(value)
        petWeight = value
        print("Pet weight set to: " .. (value == "" and "random" or value))
    end,
})

Tabs.SpawnerTab:Button({
    Title = "Spawn Pet",
    Callback = function()
        if pet == "" then
            WindUI:Notify({
                Title = "Error",
                Content = "Please select a pet.",
                Icon = "alert-circle",
                Duration = 5,
            })
            return
        end

        local qty = tonumber(petQuantity) or 1
        if qty <= 0 then
            WindUI:Notify({
                Title = "Error",
                Content = "Quantity must be greater than 0.",
                Icon = "alert-circle",
                Duration = 5,
            })
            return
        end

        print("Spawning pet: " .. pet .. " x" .. qty)
        local petAssets = game:GetService("ReplicatedStorage"):FindFirstChild("Assets")
            and game:GetService("ReplicatedStorage").Assets:FindFirstChild("Models")
            and game:GetService("ReplicatedStorage").Assets.Models:FindFirstChild("PetAssets")
        if not petAssets then
            WindUI:Notify({
                Title = "Error",
                Content = "PetAssets not found in ReplicatedStorage.Assets.Models.",
                Icon = "alert-circle",
                Duration = 5,
            })
            return
        end

        local petModel = petAssets:FindFirstChild(pet)
        if not petModel or not petModel:IsA("Model") then
            WindUI:Notify({
                Title = "Error",
                Content = "Pet '" .. pet .. "' not found in PetAssets.",
                Icon = "alert-circle",
                Duration = 5,
            })
            return
        end

        local kg
        if petWeight == "" then
            local minInt, maxInt = 4, 20
            local intPart = math.random(minInt, maxInt)
            local decimalPart = math.random(0, 99)
            kg = intPart + (decimalPart / 100)
        else
            kg = tonumber(petWeight) or 4
        end
        local kgStr = string.format("%.2f", kg)
        local scaleFactor = kg / 4

        local backpack = game.Players.LocalPlayer.Backpack
        local existingTool = nil
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:match(pet .. " %[%d+%.%d+ KG%] %[X%d+]$") then
                existingTool = tool
                break
            end
        end

        if existingTool then
            local currentQty = tonumber(existingTool.Name:match("%[X(%d+)]$")) or 0
            local newQty = currentQty + qty
            existingTool.Name = pet .. " [" .. kgStr .. " KG] [X" .. newQty .. "]"
            WindUI:Notify({
                Title = "Success",
                Content = "Updated " .. pet .. " to [X" .. newQty .. "]",
                Icon = "check",
                Duration = 5,
            })
        else
            local tool = Instance.new("Tool")
            tool.Name = pet .. " [" .. kgStr .. " KG] [X" .. qty .. "]"
            tool.RequiresHandle = true

            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(1, 1, 1)
            handle.Transparency = 1
            handle.CanCollide = false
            handle.Anchored = false
            handle.Parent = tool

            local model = petModel:Clone()
            model.Name = "PetModel"
            local primary = model.PrimaryPart
            if not primary then
                WindUI:Notify({
                    Title = "Error",
                    Content = "Pet model '" .. pet .. "' has no PrimaryPart.",
                    Icon = "alert-circle",
                    Duration = 5,
                })
                tool:Destroy()
                return
            end

            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Size = part.Size * scaleFactor
                    local relativePos = primary.CFrame:PointToObjectSpace(part.Position)
                    local newPos = primary.CFrame:PointToWorldSpace(relativePos * scaleFactor)
                    part.CFrame = CFrame.new(newPos) * (part.CFrame - part.CFrame.Position)
                end
            end

            primary.Size = primary.Size * scaleFactor
            model:SetPrimaryPartCFrame(CFrame.Angles(math.rad(-90), math.rad(-85), 0))
            model.Parent = tool

            local kgPart = Instance.new("Part")
            kgPart.Name = kgStr .. " KG"
            kgPart.Size = Vector3.new(1, 1, 1)
            kgPart.Anchored = false
            kgPart.CanCollide = false
            kgPart.Transparency = 1
            kgPart.Parent = tool

            local weldToHandle = Instance.new("WeldConstraint")
            weldToHandle.Part0 = handle
            weldToHandle.Part1 = kgPart
            weldToHandle.Parent = handle

            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = handle
                    weld.Part1 = part
                    weld.Parent = handle
                    part.Anchored = false
                end
            end

            tool.Equipped:Connect(function()
                local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                local offset = CFrame.new(0.192, 0, -1.5) * CFrame.Angles(0, math.rad(-85), 0)
                handle.CFrame = hrp.CFrame * offset
            end)

            tool.Parent = backpack
            WindUI:Notify({
                Title = "Success",
                Content = "Spawned " .. pet .. " [" .. kgStr .. " KG] [X" .. qty .. "]",
                Icon = "check",
                Duration = 5,
            })
        end
    end
})

print("Script fully loaded. UI should be visible.")
