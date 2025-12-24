--// DmAzj UI Library
--// Clean Rewrite | Mobile Ready | Smooth Minimize
--// Author: dm-azj

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Prevent duplicate UI
if PlayerGui:FindFirstChild("DmAzjUI") then
    PlayerGui.DmAzjUI:Destroy()
end

local Library = {}
Library.Theme = {
    Background = Color3.fromRGB(20,20,20),
    Topbar = Color3.fromRGB(25,25,25),
    Accent = Color3.fromRGB(120,80,255),
    Text = Color3.fromRGB(255,255,255),
    Button = Color3.fromRGB(30,30,30)
}

--// Tween helper
local function Tween(obj, props, time)
    TweenService:Create(
        obj,
        TweenInfo.new(time or 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        props
    ):Play()
end

--// Notification
function Library:Notify(text, duration)
    duration = duration or 2

    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.fromOffset(300,50)
    frame.Position = UDim2.new(1,-320,1,80)
    frame.BackgroundColor3 = self.Theme.Background
    frame.BorderSizePixel = 0

    Instance.new("UICorner", frame)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.fromScale(1,1)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = self.Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14

    Tween(frame, {Position = UDim2.new(1,-320,1,-70)}, 0.3)
    task.delay(duration, function()
        Tween(frame, {Position = UDim2.new(1,-320,1,80)}, 0.3)
        task.delay(0.3, function()
            gui:Destroy()
        end)
    end)
end

--// Create Window
function Library:CreateWindow(title)
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "DmAzjUI"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromOffset(500,360)
    main.Position = UDim2.new(0.5,-250,0.5,-180)
    main.BackgroundColor3 = self.Theme.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true

    Instance.new("UICorner", main)

    -- Topbar
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1,0,0,40)
    top.BackgroundColor3 = self.Theme.Topbar
    top.BorderSizePixel = 0
    Instance.new("UICorner", top)

    local titleLabel = Instance.new("TextLabel", top)
    titleLabel.Size = UDim2.new(1,-80,1,0)
    titleLabel.Position = UDim2.fromOffset(10,0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextXAlignment = Left
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15

    -- Minimize Button
    local minimize = Instance.new("TextButton", top)
    minimize.Size = UDim2.fromOffset(30,30)
    minimize.Position = UDim2.new(1,-35,0.5,-15)
    minimize.Text = "-"
    minimize.Font = Enum.Font.GothamBold
    minimize.TextSize = 18
    minimize.BackgroundColor3 = self.Theme.Button
    minimize.TextColor3 = self.Theme.Text
    minimize.BorderSizePixel = 0
    Instance.new("UICorner", minimize)

    -- Tabs
    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(0,120,1,-40)
    tabBar.Position = UDim2.fromOffset(0,40)
    tabBar.BackgroundColor3 = self.Theme.Topbar
    tabBar.BorderSizePixel = 0

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.Padding = UDim.new(0,6)

    local pages = Instance.new("Folder", main)
    local minimized = false
    local savedSize = main.Size

    minimize.MouseButton1Click:Connect(function()
        minimized = not minimized
        minimize.Text = minimized and "+" or "-"

        if minimized then
            savedSize = main.Size
            Tween(main, {Size = UDim2.fromOffset(500,40)}, 0.25)
            for _,p in pairs(pages:GetChildren()) do
                Tween(p, {Size = UDim2.new(1,-130,0,0)}, 0.25)
                task.delay(0.25, function()
                    p.Visible = false
                end)
            end
        else
            Tween(main, {Size = savedSize}, 0.25)
            for _,p in pairs(pages:GetChildren()) do
                p.Visible = true
                Tween(p, {Size = UDim2.new(1,-130,1,-50)}, 0.25)
            end
        end
    end)

    -- Window Object
    local Window = {}

    function Window:AddTab(name)
        local tabBtn = Instance.new("TextButton", tabBar)
        tabBtn.Size = UDim2.fromOffset(100,30)
        tabBtn.Text = name
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 13
        tabBtn.BackgroundColor3 = Library.Theme.Button
        tabBtn.TextColor3 = Library.Theme.Text
        tabBtn.BorderSizePixel = 0
        Instance.new("UICorner", tabBtn)

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

        tabBtn.MouseButton1Click:Connect(function()
            for _,p in pairs(pages:GetChildren()) do
                p.Visible = false
            end
            page.Visible = true
        end)

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

            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(i)
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

        if #pages:GetChildren() == 1 then
            page.Visible = true
        end

        return Tab
    end

    return Window
end

return Library
