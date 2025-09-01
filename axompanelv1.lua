local AxomPanel = {}
AxomPanel.__index = AxomPanel

function AxomPanel:Create()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AxomPanel"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

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
        ScreenGui:Destroy()
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

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 350, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 20
    Button.Text = "Test Button"
    Button.Parent = ContentFrame
    Button.MouseButton1Click:Connect(function()
        print("Button pressed")
    end)

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0, 350, 0, 50)
    TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 18
    TextBox.PlaceholderText = "Type something..."
    TextBox.Parent = ContentFrame
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            print("TextBox input:", TextBox.Text)
        end
    end)

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0, 350, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SliderFrame.Parent = ContentFrame

    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0, 50, 1, 0)
    SliderValue.Position = UDim2.new(1, -60, 0, 0)
    SliderValue.BackgroundTransparency = 1
    SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderValue.Font = Enum.Font.SourceSans
    SliderValue.TextSize = 18
    SliderValue.Text = "50"
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
            local percent = math.floor((relativeX / (SliderFrame.AbsoluteSize.X - SliderButton.AbsoluteSize.X)) * 100)
            SliderValue.Text = percent
        end)
        local upConn
        upConn = mouse.Button1Up:Connect(function()
            conn:Disconnect()
            upConn:Disconnect()
        end)
    end)

    return {Gui = ScreenGui, MainFrame = MainFrame, ContentFrame = ContentFrame}
end

return AxomPanel
