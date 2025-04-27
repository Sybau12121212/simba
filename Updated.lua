--[[
  🎣 Fisch Ultimate Auto-Farm Script 🎣
  Funzioni:
  1. Auto Cast (lancio automatico canna)
  2. Auto Shake (scuotimento automatico)
  3. Auto Reel (recupero automatico pesce)
  4. Anti-AFK integrato
]]

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Servizi
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Variabili
local FishingEnabled = false
local ShakeConnection = nil

-- Anti-AFK
local AntiAFK = true
if AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- Funzione Auto Cast
local function AutoCast()
    while FishingEnabled and task.wait(1.5) do
        ReplicatedStorage.FishingEvents.CastLine:FireServer()
    end
end

-- Funzione Auto Shake
local function SetupAutoShake()
    if ShakeConnection then ShakeConnection:Disconnect() end
    ShakeConnection = ReplicatedStorage.FishingEvents.FishBite.OnClientEvent:Connect(function()
        if FishingEnabled then
            for i = 1, 8 do
                ReplicatedStorage.FishingEvents.ShakeRod:FireServer()
                task.wait(0.15)
            end
        end
    end)
end

-- Funzione Auto Reel
local function AutoReel()
    while FishingEnabled and task.wait(0.7) do
        ReplicatedStorage.FishingEvents.ReelIn:FireServer()
    end
end

-- UI con Kavo Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Fisch Ultimate", "DarkTheme")

-- Tab Pesca
local FishingTab = Window:NewTab("Auto Farm")
local MainSection = FishingTab:NewSection("Funzioni Pesca")

MainSection:NewToggle("Attiva Auto Farm", "Auto Cast + Shake + Reel", function(state)
    FishingEnabled = state
    if state then
        AutoCast()
        SetupAutoShake()
        AutoReel()
    else
        if ShakeConnection then
            ShakeConnection:Disconnect()
        end
    end
end)

MainSection:NewKeybind("Toggle GUI", "Attiva/Disattiva la GUI", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

-- Notifica iniziale
game.StarterGui:SetCore("SendNotification", {
    Title = "Fisch Ultimate Loaded",
    Text = "Premi RightControl per aprire/chidere il menu!",
    Duration = 8,
    Icon = "rbxassetid://7733960981"
})

-- Ottimizzazione prestazioni
if setfpscap then setfpscap(60) end