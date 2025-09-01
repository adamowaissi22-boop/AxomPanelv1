local AxomPanel = {}
AxomPanel.__index = AxomPanel

function AxomPanel:Create()
    local selfObj = {}
    selfObj.Gui = Instance.new("ScreenGui")
    selfObj.Gui.Name = "AxomPanel"
    selfObj.Gui.ResetOnSpawn = false
    selfObj.Gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = selfObj.Gui

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Color = Color3.fromRGB(0, 255, 255)
    UIStroke.Thickness = 2

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TitleBar.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "AxomPanel"
    Title.TextColor3 = Color3.fromRGB(0, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 24
    Title.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.TextSize = 20
    CloseButton.Text = "X"
    CloseButton.Parent = TitleBar
    CloseButton.MouseButton1Click:Connect(function()
        selfObj.Gui:Destroy()
    end)

    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -50)
    ContentFrame.Position = UDim2.new(0, 0, 0, 50)
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.ScrollBarThickness = 8
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ContentFrame

    local function updateCanvasSize()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
    end
    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)

    function selfObj:CreateSection(title)
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Size = UDim2.new(1, -20, 0, 0)
        SectionFrame.BackgroundTransparency = 1
        SectionFrame.Parent = ContentFrame

        local SectionLabel = Instance.new("TextLabel")
        SectionLabel.Size = UDim2.new(1, 0, 0, 30)
        SectionLabel.BackgroundTransparency = 1
        SectionLabel.Text = title
        SectionLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        SectionLabel.Font = Enum.Font.SourceSansBold
        SectionLabel.TextSize = 20
        SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        SectionLabel.Parent = SectionFrame

        local UIList = Instance.new("UIListLayout")
        UIList.SortOrder = Enum.SortOrder.LayoutOrder
        UIList.Padding = UDim.new(0, 10)
        UIList.Parent = SectionFrame

        local section = {}

        function section:CreateButton(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 18
            btn.Text = text
            btn.Parent = SectionFrame
            btn.MouseButton1Click:Connect(callback)
        end

        function section:CreateTextbox(placeholder, callback)
            local tb = Instance.new("TextBox")
            tb.Size = UDim2.new(1, 0, 0, 40)
            tb.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            tb.TextColor3 = Color3.fromRGB(255, 255, 255)
            tb.Font = Enum.Font.SourceSans
            tb.TextSize = 18
            tb.PlaceholderText = placeholder
            tb.Parent = SectionFrame
            tb.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(tb.Text)
                end
            end)
        end

        function section:CreateSlider(title, min, max, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 40)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SliderFrame.Parent = SectionFrame

            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 50, 1, 0)
            SliderValue.Position = UDim2.new(1, -60, 0, 0)
            SliderValue.BackgroundTransparency = 1
            SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderValue.Font = Enum.Font.SourceSans
            SliderValue.TextSize = 18
            SliderValue.Text = tostring(min)
            SliderValue.Parent = SliderFrame

            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, -70, 1, 0)
            SliderButton.Position = UDim2.new(0, 0, 0, 0)
            SliderButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            SliderButton.Text = ""
            SliderButton.Parent = SliderFrame

            SliderButton.MouseButton1Down:Connect(function()
                local mouse = game.Players.LocalPlayer:GetMouse()
                local conn
                conn = mouse.Move:Connect(function()
                    local relativeX = math.clamp(mouse.X - SliderFrame.AbsolutePosition.X, 0, SliderFrame.AbsoluteSize.X - SliderButton.AbsoluteSize.X)
                    SliderButton.Position = UDim2.new(0, relativeX, 0, 0)
                    local value = math.floor((relativeX / (SliderFrame.AbsoluteSize.X - SliderButton.AbsoluteSize.X)) * (max - min) + min)
                    SliderValue.Text = tostring(value)
                    callback(value)
                end)
                local upConn
                upConn = mouse.Button1Up:Connect(function()
                    conn:Disconnect()
                    upConn:Disconnect()
                end)
            end)
        end

        function section:CreateToggle(text, callback)
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(1, 0, 0, 40)
            toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggle.Font = Enum.Font.SourceSansBold
            toggle.TextSize = 18
            toggle.Text = text.." : OFF"
            toggle.Parent = SectionFrame
            local state = false
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = text.." : "..(state and "ON" or "OFF")
                callback(state)
            end)
        end

        function section:CreatePlayerSelector(title, callback)
            local Players = game:GetService("Players")
            local selectedIndex = 1
            local playerList = {}

            local function updateList()
                playerList = {}
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= Players.LocalPlayer then
                        table.insert(playerList, p)
                    end
                end
                if selectedIndex > #playerList then
                    selectedIndex = #playerList
                end
                Label.Text = playerList[selectedIndex] and playerList[selectedIndex].Name or "No Player"
            end

            updateList()
            Players.PlayerAdded:Connect(updateList)
            Players.PlayerRemoving:Connect(updateList)

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Frame.Parent = SectionFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -80, 1, 0)
            Label.Position = UDim2.new(0, 0, 0, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.SourceSans
            Label.TextSize = 18
            Label.Text = playerList[selectedIndex] and playerList[selectedIndex].Name or "No Player"
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame

            local UpButton = Instance.new("TextButton")
            UpButton.Size = UDim2.new(0, 40, 1, 0)
            UpButton.Position = UDim2.new(1, -80, 0, 0)
            UpButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            UpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            UpButton.Font = Enum.Font.SourceSansBold
            UpButton.TextSize = 18
            UpButton.Text = "↑"
            UpButton.Parent = Frame
            UpButton.MouseButton1Click:Connect(function()
                if #playerList == 0 then return end
                selectedIndex = selectedIndex - 1
                if selectedIndex < 1 then selectedIndex = #playerList end
                Label.Text = playerList[selectedIndex].Name
                callback(playerList[selectedIndex])
            end)

            local DownButton = Instance.new("TextButton")
            DownButton.Size = UDim2.new(0, 40, 1, 0)
            DownButton.Position = UDim2.new(1, -40, 0, 0)
            DownButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            DownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DownButton.Font = Enum.Font.SourceSansBold
            DownButton.TextSize = 18
            DownButton.Text = "↓"
            DownButton.Parent = Frame
            DownButton.MouseButton1Click:Connect(function()
                if #playerList == 0 then return end
                selectedIndex = selectedIndex + 1
                if selectedIndex > #playerList then selectedIndex = 1 end
                Label.Text = playerList[selectedIndex].Name
                callback(playerList[selectedIndex])
            end)
        end

        return section
    end

    return selfObj
end

function AxomPanel:Toggle()
    if self.Gui then
        self.Gui.Enabled = not self.Gui.Enabled
    end
end

return AxomPanel
