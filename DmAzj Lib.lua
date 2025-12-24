--// DmAzj UI Library
--// First Clean Rewrite Version
--// Simple | Stable | Mobile Ready

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Remove duplicate UI
if PlayerGui:FindFirstChild("DmAzjUI") then
    PlayerGui.DmAzjUI:Destroy()
end

local Library = {}

Library.Theme = {
    Background = Color3.fromRGB(20,20,20),
    Topbar = Color3.fromRGB(25,25,25),
    Button = Color3.fromRGB(35,35,35),
    Accent = Color3.fromRGB(120,80,255),
    Text = Color3.fromRGB(255,255,255)
}

-- Simple tween helper
local function Tween(obj, props, time)
    TweenService:Create(
        obj,
        TweenInfo.new(time or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    ):Play()
end

-- Notification
function Library:Notify(text, duration)
    duration = duration or 2

    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.fromOffset(300,40)
    frame.Position = UDim2.new(0.5,-150,1,60)
    frame.BackgroundColor3 = self.Theme.Background
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.fromScale(1,1)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = self.Theme.Text

    task.delay(duration, function()
        gui:Destroy()
    end)
end

-- Create Window
function Library:CreateWindow(title)
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "DmAzjUI"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromOffset(480,340)
    main.Position = UDim2.new(0.5,-240,0.5,-170)
    main.BackgroundColor3 = Library.Theme.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main)

    -- Topbar
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1,0,0,40)
    top.BackgroundColor3 = Library.Theme.Topbar
    top.BorderSizePixel = 0
    Instance.new("UICorner", top)

    local titleLabel = Instance.new("TextLabel", top)
    titleLabel.Size = UDim2.new(1,-20,1,0)
    titleLabel.Position = UDim2.fromOffset(10,0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextColor3 = Library.Theme.Text

    -- Tabs
    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(0,120,1,-40)
    tabBar.Position = UDim2.fromOffset(0,40)
    tabBar.BackgroundColor3 = Library.Theme.Topbar
    tabBar.BorderSizePixel = 0

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.Padding = UDim.new(0,6)

    local pages = Instance.new("Folder", main)

    local Window = {}

    function Window:AddTab(name)
        local tabButton = Instance.new("TextButton", tabBar)
        tabButton.Size = UDim2.fromOffset(100,30)
        tabButton.Text = name
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 13
        tabButton.BackgroundColor3 = Library.Theme.Button
        tabButton.TextColor3 = Library.Theme.Text
        tabButton.BorderSizePixel = 0
        Instance.new("UICorner", tabButton)

        local page = Instance.new("ScrollingFrame", main)
        page.Size = UDim2.new(1,-130,1,-50)
        page.Position = UDim2.fromOffset(120,45)
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.ScrollBarImageTransparency = 1
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = pages

        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0,8)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
        end)

        tabButton.MouseButton1Click:Connect(function()
            for _,p in pairs(pages:GetChildren()) do
                p.Visible = false
            end
            page.Visible = true
        end)

        -- Auto open first tab
        if #pages:GetChildren() == 1 then
            page.Visible = true
        end

        local Tab = {}

        function Tab:AddButton(text, callback)
            local btn = Instance.new("TextButton", page)
            btn.Size = UDim2.new(1,-10,0,40)
            btn.Text = text
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.BackgroundColor3 = Library.Theme.Button
            btn.TextColor3 = Library.Theme.Text
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn)

            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        function Tab:AddSlider(text, min, max, callback)
            local frame = Instance.new("Frame", page)
            frame.Size = UDim2.new(1,-10,0,50)
            frame.BackgroundColor3 = Library.Theme.Button
            frame.BorderSizePixel = 0
            Instance.new("UICorner", frame)

            local bar = Instance.new("Frame", frame)
            bar.Size = UDim2.new(0,0,1,0)
            bar.BackgroundColor3 = Library.Theme.Accent
            Instance.new("UICorner", bar)

            local dragging = false

            frame.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)

            game:GetService("UserInputService").InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            game:GetService("UserInputService").InputChanged:Connect(function(i)
                if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch) then
                    local pct = math.clamp(
                        (i.Position.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X,
                        0,1
                    )
                    bar.Size = UDim2.new(pct,0,1,0)
                    local value = math.floor(min + (max - min) * pct)
                    pcall(callback, value)
                end
            end)
        end

        return Tab
    end

    return Window
end

return Library
