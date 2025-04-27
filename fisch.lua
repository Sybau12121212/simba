--[[
  Script per Fisch - Funzioni:
  1. AutoFarm (attacca automaticamente i nemici vicini)
  2. Kill Aura (danno a chi è vicino)
  3. Speed Hack (aumenta velocità movimento)
]]

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Funzione AutoFarm
local function AutoFarm()
    while task.wait() do
        for _, enemy in ipairs(game.Players:GetPlayers()) do
            if enemy ~= Player and enemy.Character then
                local enemyChar = enemy.Character
                local enemyHumanoid = enemyChar:FindFirstChild("Humanoid")
                if enemyHumanoid and enemyHumanoid.Health > 0 then
                    -- Simula un attacco (modifica in base alle meccaniche di Fisch)
                    game:GetService("ReplicatedStorage").MeleeDamage:FireServer(enemyChar, 50)
                end
            end
        end
    end
end

-- Funzione Kill Aura
local function KillAura()
    while task.wait(0.2) do
        for _, enemy in ipairs(game.Players:GetPlayers()) do
            if enemy ~= Player and enemy.Character then
                local enemyRoot = enemy.Character:FindFirstChild("HumanoidRootPart")
                local playerRoot = Character:FindFirstChild("HumanoidRootPart")
                if enemyRoot and playerRoot then
                    local distance = (enemyRoot.Position - playerRoot.Position).Magnitude
                    if distance < 10 then -- Raggio di 10 studs
                        game:GetService("ReplicatedStorage").MeleeDamage:FireServer(enemy.Character, 100)
                    end
                end
            end
        end
    end
end

-- Speed Hack
Humanoid.WalkSpeed = 50 -- Modifica la velocità (default 16)

-- UI (Interfaccia)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Fisch Hack", "DarkTheme")

-- Tab AutoFarm
local AutoTab = Window:NewTab("AutoFarm")
local AutoSection = AutoTab:NewSection("Funzioni")
AutoSection:NewToggle("AutoFarm", "Attacca automaticamente", function(state)
    if state then
        AutoFarm()
    end
end)

-- Tab Kill Aura
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Kill Aura")
CombatSection:NewToggle("Kill Aura", "Danneggia chi è vicino", function(state)
    if state then
        KillAura()
    end
end)

-- Tab Movimento
local MoveTab = Window:NewTab("Movimento")
local MoveSection = MoveTab:NewSection("Speed Hack")
MoveSection:NewSlider("Velocità", "Aumenta la velocità", 100, 16, function(value)
    Humanoid.WalkSpeed = value
end)