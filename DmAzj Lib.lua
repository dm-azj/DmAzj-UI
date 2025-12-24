--// DmAzj UI Library (STABLE FIX)
--// No Minimize Animation | No Black Screen
--// Mobile + PC Safe

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Remove duplicate
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

-- Notify
function Library:Notify(text, time)
    time = time or 2
    local g = Instance.new("ScreenGui", PlayerGui)
    g.ResetOnSpawn = false

    local f = Instance.new("Frame", g)
    f.Size = UDim2.fromOffset(280,40)
    f.Position = UDim2.new(0.5,-140,1,60)
    f.BackgroundColor3 = self.Theme.Background
    Instance.new("UICorner", f)

    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.fromScale(1,1)
    l.BackgroundTransparency = 1
    l.Text = text
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.TextColor3 = self.Theme.Text

    task.delay(time,function()
        g:Destroy()
    end)
end

-- Create Window
function Library:CreateWindow(title)
    local gui = Instance.new("ScreenGui", PlayerGui)
    gui.Name = "DmAzjUI"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame", gui)
    main.Size = UDim2.fromOffset(520,360)
    main.Position = UDim2.new(0.5,-260,0.5,-180)
    main.BackgroundColor3 = Library.Theme.Background
    main.Active = true
    main.Draggable = true
    Instance.new("UICorner", main)

    -- Topbar
    local top = Instance.new("Frame", main)
    top.Size = UDim2.new(1,0,0,40)
    top.BackgroundColor3 = Library.Theme.Topbar
    Instance.new("UICorner", top)

    local titleLbl = Instance.new("TextLabel", top)
    titleLbl.Size = UDim2.new(1,-60,1,0)
    titleLbl.Position = UDim2.fromOffset(10,0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 15
    titleLbl.TextColor3 = Library.Theme.Text

    -- Minimize (NO animation)
    local minimize = Instance.new("TextButton", top)
    minimize.Size = UDim2.fromOffset(30,30)
    minimize.Position = UDim2.new(1,-35,0.5,-15)
    minimize.Text = "-"
    minimize.Font = Enum.Font.GothamBold
    minimize.TextSize = 18
    minimize.BackgroundColor3 = Library.Theme.Button
    minimize.TextColor3 = Library.Theme.Text
    Instance.new("UICorner", minimize)

    local contentVisible = true

    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(0,120,1,-40)
    tabBar.Position = UDim2.fromOffset(0,40)
    tabBar.BackgroundColor3 = Library.Theme.Topbar

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.Padding = UDim.new(0,6)

    local pages = Instance.new("Folder", main)

    minimize.MouseButton1Click:Connect(function()
        contentVisible = not contentVisible
        minimize.Text = contentVisible and "-" or "+"
        tabBar.Visible = contentVisible
        for _,p in pairs(pages:GetChildren()) do
            p.Visible = contentVisible and p.Name == "ACTIVE"
        end
    end)

    local Window = {}

    function Window:AddTab(name)
        local tabBtn = Instance.new("TextButton", tabBar)
        tabBtn.Size = UDim2.fromOffset(100,30)
        tabBtn.Text = name
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextSize = 13
        tabBtn.BackgroundColor3 = Library.Theme.Button
        tabBtn.TextColor3 = Library.Theme.Text
        Instance.new("UICorner", tabBtn)

        local page = Instance.new("ScrollingFrame", main)
        page.Size = UDim2.new(1,-130,1,-50)
        page.Position = UDim2.fromOffset(120,45)
        page.CanvasSize = UDim2.new(0,0,0,0)
        page.ScrollBarImageTransparency = 1
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Name = "PAGE"
        page.Parent = pages

        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0,8)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
        end)

        tabBtn.MouseButton1Click:Connect(function()
            for _,p in pairs(pages:GetChildren()) do
                p.Visible = false
                p.Name = "PAGE"
            end
            page.Visible = true
            page.Name = "ACTIVE"
        end)

        -- AUTO OPEN FIRST TAB (FIX BLACK SCREEN)
        if #pages:GetChildren() == 1 then
            page.Visible = true
            page.Name = "ACTIVE"
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
            Instance.new("UICorner", btn)

            btn.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        function Tab:AddToggle(text, default, callback)
            local frame = Instance.new("Frame", page)
            frame.Size = UDim2.new(1,-10,0,40)
            frame.BackgroundColor3 = Library.Theme.Button
            Instance.new("UICorner", frame)

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1,-60,1,0)
            label.Position = UDim2.fromOffset(10,0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Library.Theme.Text

            local state = default or false
            frame.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    state = not state
                    frame.BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.Button
                    pcall(callback,state)
                end
            end)
        end

        function Tab:AddDropdown(text, list, callback)
            local open = false
            local frame = Instance.new("Frame", page)
            frame.Size = UDim2.new(1,-10,0,40)
            frame.BackgroundColor3 = Library.Theme.Button
            frame.ClipsDescendants = true
            Instance.new("UICorner", frame)

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1,-10,0,40)
            label.Position = UDim2.fromOffset(10,0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextColor3 = Library.Theme.Text

            frame.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    open = not open
                    frame.Size = open and UDim2.new(1,-10,0,40 + #list*30) or UDim2.new(1,-10,0,40)
                end
            end)

            for _,v in ipairs(list) do
                local opt = Instance.new("TextButton", frame)
                opt.Size = UDim2.new(1,-20,0,30)
                opt.Position = UDim2.fromOffset(10,40 + (_-1)*30)
                opt.Text = v
                opt.Font = Enum.Font.Gotham
                opt.TextSize = 13
                opt.BackgroundColor3 = Color3.fromRGB(45,45,45)
                opt.TextColor3 = Library.Theme.Text
                Instance.new("UICorner", opt)

                opt.MouseButton1Click:Connect(function()
                    label.Text = text .. ": " .. v
                    callback(v)
                end)
            end
        end

        return Tab
    end

    return Window
end

return Library
