local Library = {}
Library.__index = Library

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- Theme
local Theme = {
    Background = Color3.fromRGB(18,22,28),
    Container = Color3.fromRGB(25,30,38),
    Button = Color3.fromRGB(45,65,90),
    Accent = Color3.fromRGB(90,130,200),
    Text = Color3.fromRGB(235,235,235),
    Muted = Color3.fromRGB(150,150,150)
}

local TweenInfoFast = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function Tween(obj, props)
    TweenService:Create(obj, TweenInfoFast, props):Play()
end

-- Single running notification tracker
local currentNotification = nil

function Library:SetTheme(tbl)
    for k,v in pairs(tbl) do
        Theme[k] = v
    end
end

function Library:Notify(text, duration)
    duration = duration or 3

    -- Remove previous notification if exists
    if currentNotification and currentNotification.Parent then
        currentNotification:Destroy()
    end

    local gui = Instance.new("ScreenGui", Player.PlayerGui)
    gui.ResetOnSpawn = false
    currentNotification = gui

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0,300,0,45)
    frame.Position = UDim2.new(1,320,1,-70)
    frame.BackgroundColor3 = Theme.Container
    frame.ZIndex = 10
    Instance.new("UICorner", frame)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1,-20,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 15
    lbl.TextColor3 = Theme.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    Tween(frame, {Position = UDim2.new(1,-320,1,-70)})
    task.delay(duration, function()
        Tween(frame, {Position = UDim2.new(1,320,1,-70)})
        task.delay(0.3, function()
            gui:Destroy()
            currentNotification = nil
        end)
    end)
end

function Library:CreateWindow(titleText)
    local gui = Instance.new("ScreenGui", Player.PlayerGui)
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0,480,0,360)
    main.Position = UDim2.new(0.5,-240,0.5,-180)
    main.BackgroundColor3 = Theme.Background
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main)

    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1,-50,0,45)
    title.Position = UDim2.new(0,15,0,0)
    title.BackgroundTransparency = 1
    title.Text = titleText or "DmAzj UI"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Theme.Text

    local minimize = Instance.new("TextButton", main)
    minimize.Size = UDim2.new(0,30,0,30)
    minimize.Position = UDim2.new(1,-40,0,8)
    minimize.Text = "-"
    minimize.Font = Enum.Font.GothamBold
    minimize.TextSize = 18
    minimize.BackgroundColor3 = Theme.Button
    minimize.TextColor3 = Theme.Text
    Instance.new("UICorner", minimize)

    local tabsBar = Instance.new("Frame", main)
    tabsBar.Size = UDim2.new(1,0,0,36)
    tabsBar.Position = UDim2.new(0,0,0,45)
    tabsBar.BackgroundTransparency = 1
    local tabsLayout = Instance.new("UIListLayout", tabsBar)
    tabsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsLayout.Padding = UDim.new(0,8)

    local pages = Instance.new("Folder", main)
    local CurrentTab

    minimize.MouseButton1Click:Connect(function()
        local open = false
        for _,v in pairs(pages:GetChildren()) do
            open = v.Visible
            v.Visible = not v.Visible
        end
        Tween(main, {Size = open and UDim2.new(0,480,0,55) or UDim2.new(0,480,0,360)})
    end)

    local Window = {}

    function Window:AddTab(name)
        local tabBtn = Instance.new("TextButton", tabsBar)
        tabBtn.Size = UDim2.new(0,100,1,0)
        tabBtn.Text = name
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 14
        tabBtn.BackgroundColor3 = Theme.Button
        tabBtn.TextColor3 = Theme.Text
        Instance.new("UICorner", tabBtn)

        local page = Instance.new("Frame", main)
        page.Size = UDim2.new(1,-20,1,-95)
        page.Position = UDim2.new(0,10,0,85)
        page.BackgroundTransparency = 1
        page.Visible = false
        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0,8)

        tabBtn.MouseButton1Click:Connect(function()
            if CurrentTab then CurrentTab.Visible = false end
            page.Visible = true
            CurrentTab = page
        end)

        if not CurrentTab then
            page.Visible = true
            CurrentTab = page
        end

        local Tab = {}

        function Tab:AddButton(text, callback)
            local btn = Instance.new("TextButton", page)
            btn.Size = UDim2.new(1,0,0,40)
            btn.Text = text
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 15
            btn.BackgroundColor3 = Theme.Button
            btn.TextColor3 = Theme.Text
            Instance.new("UICorner", btn)
            btn.MouseButton1Click:Connect(function()
                Tween(btn, {BackgroundColor3 = Theme.Accent})
                task.delay(0.15,function() Tween(btn, {BackgroundColor3 = Theme.Button}) end)
                if callback then callback() end
            end)
        end

        function Tab:AddSlider(text, min, max, callback)
            local holder = Instance.new("Frame", page)
            holder.Size = UDim2.new(1,0,0,55)
            holder.BackgroundTransparency = 1

            local lbl = Instance.new("TextLabel", holder)
            lbl.Size = UDim2.new(1,0,0,20)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 14
            lbl.TextColor3 = Theme.Text

            local bar = Instance.new("Frame", holder)
            bar.Size = UDim2.new(1,0,0,10)
            bar.Position = UDim2.new(0,0,0,30)
            bar.BackgroundColor3 = Theme.Container
            Instance.new("UICorner", bar)

            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new(0,0,1,0)
            fill.BackgroundColor3 = Theme.Accent
            Instance.new("UICorner", fill)

            local dragging = false
            bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    main.Draggable = false -- disable GUI drag
                end
            end)
            UIS.InputEnded:Connect(function(i)
                if dragging then
                    dragging = false
                    main.Draggable = true -- re-enable GUI drag
                end
            end)
            UIS.InputChanged:Connect(function(i)
                if dragging then
                    local x = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
                    fill.Size = UDim2.new(x,0,1,0)
                    local value = math.floor(min + (max-min)*x)
                    if callback then callback(value) end
                end
            end)
        end

        -- AddDropdown / AddKeybind / AddToggle logic can remain as previous version
        function Tab:AddDropdown(text, list, callback)
            local open = false
            local holder = Instance.new("Frame", page)
            holder.Size = UDim2.new(1,0,0,40)
            holder.BackgroundTransparency = 1

            local btn = Instance.new("TextButton", holder)
            btn.Size = UDim2.new(1,0,0,40)
            btn.Text = text
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 15
            btn.BackgroundColor3 = Theme.Button
            btn.TextColor3 = Theme.Text
            Instance.new("UICorner", btn)

            local options = Instance.new("Frame", holder)
            options.Size = UDim2.new(1,0,0,0)
            options.Position = UDim2.new(0,0,0,45)
            options.BackgroundColor3 = Theme.Container
            options.ClipsDescendants = true
            Instance.new("UICorner", options)
            local listLayout = Instance.new("UIListLayout", options)

            btn.MouseButton1Click:Connect(function()
                open = not open
                Tween(options, {Size = open and UDim2.new(1,0,0,#list*35) or UDim2.new(1,0,0,0)})
                Tween(holder, {Size = open and UDim2.new(1,0,0,45+#list*35) or UDim2.new(1,0,0,40)})
            end)

            for _,v in pairs(list) do
                local opt = Instance.new("TextButton", options)
                opt.Size = UDim2.new(1,0,0,35)
                opt.Text = v
                opt.Font = Enum.Font.Gotham
                opt.TextSize = 14
                opt.BackgroundTransparency = 1
                opt.TextColor3 = Theme.Text
                opt.MouseButton1Click:Connect(function()
                    btn.Text = text..": "..v
                    if callback then callback(v) end
                end)
            end
        end

        function Tab:AddKeybind(text, key, callback)
            local lbl = Instance.new("TextLabel", page)
            lbl.Size = UDim2.new(1,0,0,35)
            lbl.Text = text.." ["..key.Name.."]"
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 14
            lbl.TextColor3 = Theme.Text
            lbl.BackgroundTransparency = 1

            UIS.InputBegan:Connect(function(i,g)
                if not g and i.KeyCode == key then
                    if callback then callback() end
                end
            end)
        end

        return Tab
    end

    return Window
end

return Library
