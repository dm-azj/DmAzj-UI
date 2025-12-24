--// DmAzj UI Library (FINAL FIXED)

local Library = {}
Library.__index = Library

-- Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- Prevent duplicate load
if Player.PlayerGui:FindFirstChild("DmAzjUILoaded") then
    warn("DmAzj UI already running")
    return
end

local flag = Instance.new("BoolValue")
flag.Name = "DmAzjUILoaded"
flag.Parent = Player.PlayerGui

-- Theme
local Theme = {
    Background = Color3.fromRGB(18,22,28),
    Topbar = Color3.fromRGB(22,26,32),
    Container = Color3.fromRGB(28,34,42),
    Button = Color3.fromRGB(50,70,95),
    Accent = Color3.fromRGB(90,130,200),
    Text = Color3.fromRGB(235,235,235)
}

-- Tween helper
local function Tween(obj, props, time)
    TweenService:Create(
        obj,
        TweenInfo.new(time or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    ):Play()
end

-- Notification (single instance)
local currentNotify
function Library:Notify(text, dur)
    dur = dur or 3
    if currentNotify then currentNotify:Destroy() end

    local gui = Instance.new("ScreenGui", Player.PlayerGui)
    gui.ResetOnSpawn = false
    currentNotify = gui

    local box = Instance.new("Frame", gui)
    box.Size = UDim2.new(0,300,0,45)
    box.Position = UDim2.new(1,320,1,-70)
    box.BackgroundColor3 = Theme.Container
    Instance.new("UICorner", box)

    local lbl = Instance.new("TextLabel", box)
    lbl.Size = UDim2.new(1,-20,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Left

    Tween(box,{Position=UDim2.new(1,-320,1,-70)})
    task.delay(dur,function()
        Tween(box,{Position=UDim2.new(1,320,1,-70)})
        task.delay(0.3,function()
            gui:Destroy()
            currentNotify=nil
        end)
    end)
end

-- Window
function Library:CreateWindow(titleText)
    local gui = Instance.new("ScreenGui", Player.PlayerGui)
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0,480,0,360)
    main.Position = UDim2.new(0.5,-240,0.5,-180)
    main.BackgroundColor3 = Theme.Background
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main)

    -- Topbar
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1,0,0,45)
    top.BackgroundColor3 = Theme.Topbar
    Instance.new("UICorner", top)

    local title = Instance.new("TextLabel", top)
    title.Size = UDim2.new(1,-60,1,0)
    title.Position = UDim2.new(0,15,0,0)
    title.BackgroundTransparency = 1
    title.Text = titleText or "DmAzj UI"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Theme.Text
    title.TextXAlignment = Left

    -- Minimize button
    local min = Instance.new("TextButton", top)
    min.Size = UDim2.new(0,30,0,30)
    min.Position = UDim2.new(1,-40,0.5,-15)
    min.Text = "-"
    min.Font = Enum.Font.GothamBold
    min.TextSize = 18
    min.BackgroundColor3 = Theme.Button
    min.TextColor3 = Theme.Text
    Instance.new("UICorner", min)

    -- Tabs bar
    local tabs = Instance.new("Frame", main)
    tabs.Position = UDim2.new(0,0,0,45)
    tabs.Size = UDim2.new(1,0,0,36)
    tabs.BackgroundTransparency = 1
    local tabLayout = Instance.new("UIListLayout", tabs)
    tabLayout.FillDirection = Horizontal
    tabLayout.Padding = UDim.new(0,8)

    -- CONTENT HOLDER (THIS FIXES EVERYTHING)
    local contentHolder = Instance.new("Frame", main)
    contentHolder.Position = UDim2.new(0,10,0,85)
    contentHolder.Size = UDim2.new(1,-20,1,-95)
    contentHolder.BackgroundTransparency = 1
    contentHolder.ClipsDescendants = true

    local pages = {}
    local currentPage
    local minimized = false

    -- Minimize FIX (ONE container tween)
    min.MouseButton1Click:Connect(function()
        minimized = not minimized
        min.Text = minimized and "+" or "-"

        Tween(main,{
            Size = minimized and UDim2.new(0,480,0,45) or UDim2.new(0,480,0,360)
        })

        Tween(contentHolder,{
            Size = minimized and UDim2.new(1,-20,0,0) or UDim2.new(1,-20,1,-95)
        })
    end)

    local Window = {}

    function Window:AddTab(name)
        local tab = Instance.new("TextButton", tabs)
        tab.Size = UDim2.new(0,100,1,0)
        tab.Text = name
        tab.Font = Enum.Font.Gotham
        tab.TextSize = 14
        tab.BackgroundColor3 = Theme.Button
        tab.TextColor3 = Theme.Text
        Instance.new("UICorner", tab)

        local page = Instance.new("Frame", contentHolder)
        page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1
        page.Visible = false
        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0,8)

        tab.MouseButton1Click:Connect(function()
            if currentPage then currentPage.Visible=false end
            page.Visible=true
            currentPage=page
        end)

        if not currentPage then
            page.Visible=true
            currentPage=page
        end

        local Tab = {}

        function Tab:AddButton(text,cb)
            local b=Instance.new("TextButton",page)
            b.Size=UDim2.new(1,0,0,40)
            b.Text=text
            b.Font=Enum.Font.Gotham
            b.TextSize=14
            b.BackgroundColor3=Theme.Button
            b.TextColor3=Theme.Text
            Instance.new("UICorner",b)
            b.MouseButton1Click:Connect(function()
                Tween(b,{BackgroundColor3=Theme.Accent},0.1)
                task.delay(0.1,function()
                    Tween(b,{BackgroundColor3=Theme.Button},0.1)
                end)
                if cb then cb() end
            end)
        end

        function Tab:AddSlider(text,min,max,cb)
            local hold=Instance.new("Frame",page)
            hold.Size=UDim2.new(1,0,0,55)
            hold.BackgroundTransparency=1

            local lbl=Instance.new("TextLabel",hold)
            lbl.Size=UDim2.new(1,0,0,20)
            lbl.BackgroundTransparency=1
            lbl.Text=text
            lbl.TextColor3=Theme.Text
            lbl.Font=Enum.Font.Gotham
            lbl.TextSize=13

            local bar=Instance.new("Frame",hold)
            bar.Position=UDim2.new(0,0,0,30)
            bar.Size=UDim2.new(1,0,0,10)
            bar.BackgroundColor3=Theme.Container
            Instance.new("UICorner",bar)

            local fill=Instance.new("Frame",bar)
            fill.Size=UDim2.new(0,0,1,0)
            fill.BackgroundColor3=Theme.Accent
            Instance.new("UICorner",fill)

            local dragging=false
            bar.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Touch then
                    dragging=true
                    main.Draggable=false
                end
            end)

            UIS.InputEnded:Connect(function()
                dragging=false
                main.Draggable=true
            end)

            UIS.InputChanged:Connect(function(i)
                if dragging then
                    local x=math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
                    fill.Size=UDim2.new(x,0,1,0)
                    local val=math.floor(min+(max-min)*x)
                    if cb then cb(val) end
                end
            end)
        end

        return Tab
    end

    return Window
end

return Library
