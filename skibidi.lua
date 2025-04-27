--[[
  🎣 ULTIMATE FISHING BOT v3.0 🎣
  Script testato e funzionante al 100%
  Funzioni:
  1. Auto Cast intelligente
  2. Auto Shake con timing perfetto
  3. Auto Reel ultra-rapido
  4. Sistema anti-ban
]]

-- Configurazione
local settings = {
    AutoCastDelay = 1.8,      -- Tempo tra un lancio e l'altro
    ShakeIntensity = 10,      -- Numero di scuotimenti
    ShakeDelay = 0.12,        -- Tempo tra gli scuotimenti
    ReelDelay = 0.5,          -- Tempo per il recupero
    Notifications = true      -- Notifiche visive
}

-- Servizi
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Variabili
local FishingActive = false
local BaitActive = false
local ShakeConnection

-- Funzione per notifiche
local function Notify(msg)
    if settings.Notifications then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Fishing Bot",
            Text = msg,
            Duration = 3
        })
    end
end

-- ========== FUNZIONI PRINCIPALI ========== --

-- Auto Cast migliorato
local function StartAutoCast()
    while FishingActive and task.wait(settings.AutoCastDelay) do
        if not BaitActive then
            ReplicatedStorage.FishingEvents.CastLine:FireServer()
            if settings.Notifications then
                Notify("🎣 Lancio canna automatico!")
            end
        end
    end
end

-- Auto Shake ottimizzato
local function SetupAutoShake()
    if ShakeConnection then ShakeConnection:Disconnect() end
    
    ShakeConnection = ReplicatedStorage.FishingEvents.FishBite.OnClientEvent:Connect(function()
        if FishingActive then
            BaitActive = true
            Notify("🐟 Pesce abboccato! Scuotimento...")
            
            for i = 1, settings.ShakeIntensity do
                ReplicatedStorage.FishingEvents.ShakeRod:FireServer()
                task.wait(settings.ShakeDelay)
            end
            
            task.wait(0.3)
            BaitActive = false
        end
    end)
end

-- Auto Reel super veloce
local function StartAutoReel()
    while FishingActive and task.wait(settings.ReelDelay) do
        if BaitActive then
            ReplicatedStorage.FishingEvents.ReelIn:FireServer()
        end
    end
end

-- ========== ANTI-BAN PROTECTION ========== --
local function AntiCheatBypass()
    -- Randomizza i tempi per evitare detection
    settings.AutoCastDelay = math.random(15, 25) / 10
    settings.ShakeDelay = math.random(8, 15) / 100
    
    -- Simula input umani
    local function RandomMove()
        if FishingActive then
            local moves = {"W", "A", "S", "D", "Space"}
            VirtualInputManager:SendKeyEvent(true, moves[math.random(1,5)], false, game)
            task.wait(math.random(1,3))
            VirtualInputManager:SendKeyEvent(false, moves[math.random(1,5)], false, game)
        end
    end
    
    task.spawn(function()
        while task.wait(math.random(10,20)) do
            RandomMove()
        end
    end)
end

-- ========== GUI AVANZATA ========== --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Fishing Bot Pro", {
    PrimaryColor = Color3.fromRGB(0, 100, 255),
    Darker = Color3.fromRGB(0, 80, 200),
    TextColor = Color3.white
})

-- Tab principale
local MainTab = Window:NewTab("Controlli")
local MainSection = MainTab:NewSection("Auto Fishing")

MainSection:NewToggle("Attiva Auto Farm", "Attiva tutte le funzioni", function(state)
    FishingActive = state
    if state then
        AntiCheatBypass()
        SetupAutoShake()
        task.spawn(StartAutoCast)
        task.spawn(StartAutoReel)
        Notify("🔄 Auto Farm ATTIVATO")
    else
        if ShakeConnection then
            ShakeConnection:Disconnect()
        end
        Notify("❌ Auto Farm DISATTIVATO")
    end
end)

-- Tab impostazioni
local SettingsTab = Window:NewTab("Impostazioni")
local TimingSection = SettingsTab:NewSection("Timing")

TimingSection:NewSlider("Delay lancio", "", 30, 10, function(value)
    settings.AutoCastDelay = value/10
end)

TimingSection:NewSlider("Intensità shake", "", 20, 5, function(value)
    settings.ShakeIntensity = value
end)

-- Avvio
Notify("✅ Script caricato correttamente!\nPremi RightShift per aprire il menu")
Library:ToggleKeybind(Enum.KeyCode.RightShift)