--[[
  Fisch Ultimate GUI - Blue Theme
  Funzioni:
  1. Auto Cast
  2. Auto Shake
  3. Auto Reel
  4. Teleport to Saved Position
  5. Inventory
  6. Shop
  7. Quests
  8. Webhook
]]

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Configurazione colori blu
local MainColor = Color3.fromRGB(0, 100, 255)
local BackgroundColor = Color3.fromRGB(20, 20, 40)
local TextColor = Color3.fromRGB(255, 255, 255)

-- Variabili globali
local FishingEnabled = false
local SavedPosition = nil
local shakeConnection = nil

-- Ottimizzazione servizi
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- Creazione GUI con Kavo
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Fisch Ultimate", {
    MainColor = MainColor,
    BackgroundColor = BackgroundColor,
    TextColor = TextColor
})

-- Funzioni di pesca
local function AutoCast()
    while task.wait(1) and FishingEnabled do
        ReplicatedStorage.FishingEvents.CastLine:FireServer()
    end
end

local function AutoShake()
    if shakeConnection then shakeConnection:Disconnect() end
    shakeConnection = ReplicatedStorage.FishingEvents.FishBite.OnClientEvent:Connect(function()
        if FishingEnabled then
            for i = 1, 10 do
                ReplicatedStorage.FishingEvents.ShakeRod:FireServer()
                task.wait(0.1)
            end
        end
    end)
end

local function AutoReel()
    while task.wait(0.5) and FishingEnabled do
        ReplicatedStorage.FishingEvents.ReelIn:FireServer()
    end
end

-- Funzioni di teleport
local function SavePosition()
    local root = Character:FindFirstChild("HumanoidRootPart")
    if root then
        SavedPosition = root.CFrame
        game.StarterGui:SetCore("SendNotification", {
            Title = "Position Saved",
            Text = "Current position has been saved!",
            Duration = 3
        })
    end
end

local function TeleportToSaved()
    if SavedPosition then
        local root = Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = SavedPosition
        end
    else
        game.StarterGui:SetCore("SendNotification", {
            Title = "Error",
            Text = "No position saved!",
            Duration = 3
        })
    end
end

-- Main Tab
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Automatically")

MainSection:NewToggle("Auto Cast", "Automatically casts fishing line", function(state)
    FishingEnabled = state
    if state then
        AutoCast()
        AutoShake()
        AutoReel()
    else
        if shakeConnection then
            shakeConnection:Disconnect()
        end
    end
end)

MainSection:NewToggle("Auto Shake", "Automatically shakes when fish bites", function(state)
    if state and FishingEnabled then
        AutoShake()
    elseif not state and shakeConnection then
        shakeConnection:Disconnect()
    end
end)

MainSection:NewToggle("Auto Reel", "Automatically reels in fish", function(state)
    if state and FishingEnabled then
        AutoReel()
    end
end)

MainSection:NewButton("Save Position", "Saves current position", function()
    SavePosition()
end)

MainSection:NewButton("Teleport To Saved Position", "Teleports to saved position", function()
    TeleportToSaved()
end)

-- Inventory Tab
local InvTab = Window:NewTab("Inventory")
local InvSection = InvTab:NewSection("Inventory Manager")

InvSection:NewButton("Open Inventory", "Opens your inventory", function()
    -- Aggiungi qui la funzione per aprire l'inventario
end)

-- Shop Tab
local ShopTab = Window:NewTab("Shop")
local ShopSection = ShopTab:NewSection("Shop Functions")

ShopSection:NewButton("Open Shop", "Opens the shop menu", function()
    -- Aggiungi qui la funzione per aprire il negozio
end)

-- Quests Tab
local QuestTab = Window:NewTab("Quests")
local QuestSection = QuestTab:NewSection("Quest Manager")

QuestSection:NewButton("Show Quests", "Displays current quests", function()
    -- Aggiungi qui la funzione per mostrare le missioni
end)

-- Webhook Tab
local WebTab = Window:NewTab("Webhook")
local WebSection = WebTab:NewSection("Discord Webhook")

WebSection:NewTextBox("Webhook URL", "Enter your webhook URL", function(text)
    -- Aggiungi qui la logica per il webhook
end)

-- Animazione di apertura
game.StarterGui:SetCore("SendNotification", {
    Title = "Fisch Ultimate GUI",
    Text = "Blue interface loaded successfully!",
    Duration = 5,
    Icon = "rbxassetid://57254792"
})

-- Aggiungi stile aggiuntivo
for _, obj in pairs(Window:GetChildren()) do
    if obj:IsA("Frame") then
        obj.BackgroundColor3 = BackgroundColor
        obj.BackgroundTransparency = 0.1
    end
end
