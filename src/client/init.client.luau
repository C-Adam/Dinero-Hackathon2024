task.wait(2)
print("Website Ready!")
--Essential Services/Libaries and Variables 
local TweenService = game:GetService("TweenService")
local local_player = game.Players.LocalPlayer
local player_gui = local_player:WaitForChild("PlayerGui")

--Primary GUI Elements
local main_gui = player_gui.MainGui
local scrolling_frame = main_gui:WaitForChild("ScrollingFrame")

--Section 1 GUI Elements
local section_1 = scrolling_frame.Section1
local find_location_button = section_1.FindLocationButton
local find_location_frame = scrolling_frame.FindLocationFrame
local get_price_button = section_1.GetPriceButton

--Section 3 GUI Elements
local section_3 = scrolling_frame.Section3
local buy_container_button = section_3.BuyContainerButton
local buy_container_frame = scrolling_frame.BuyContainerFrame
local buy_glass_button = section_3.BuyGlassButton
local buy_glass_frame = scrolling_frame.BuyGlassFrame

local section_4 = scrolling_frame.Section4
local weight_input_box = section_4.WeightBox
local earning_label = section_4.EarningLabel

--Section 1 Functions (Ex. Moving scroll frame when "Get Price Quote" is clicked)
local scroll_position = Vector2.new(0,2000)
local scroll_time = .35

for _, gui_element in scrolling_frame:GetChildren() do --Function that makes every back button on each page close the open page.
    if not gui_element:IsA("Frame") then continue end
    if not gui_element:FindFirstChild("BackButton") then continue end
    gui_element.BackButton.Activated:Connect(function()
        gui_element.Visible = false
    end)
end

local function Scroll(position)
    TweenService:Create(scrolling_frame, TweenInfo.new(scroll_time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out) , {CanvasPosition = position}):Play()
end

find_location_button.Activated:Connect(function()
    find_location_frame.Visible = true
    scrolling_frame.CanvasPosition = Vector2.new(0,0)
end)

get_price_button.Activated:Connect(function()
    Scroll(scroll_position)
end)

--Section 3 Functions (Ex. Clicking "Buy Prism Containers" Button)
buy_container_button.Activated:Connect(function()
    buy_container_frame.Visible = true
    scrolling_frame.CanvasPosition = Vector2.new(0,0)
end)

buy_glass_button.Activated:Connect(function()
    buy_glass_frame.Visible = true
    scrolling_frame.CanvasPosition = Vector2.new(0,0)
end)

--Section 4 Functions (Ex. calculating the conversion for the price quote)
local exchange_rate = 0.5

weight_input_box.FocusLost:Connect(function(enter_pressed, _inputObject)
    if enter_pressed then
        local weight_inputted = tonumber(weight_input_box.Text)
        local converted_amount = weight_inputted * exchange_rate
        earning_label.Text = "$"..converted_amount 
    else
        earning_label.Text = "$0.00"
    end
end)

--Find Location Page Functions
find_location_frame.PingButton.Activated:Connect(function()
    local original_size = UDim2.new(0.073, 0, 0.026, 0)
    local grown_size = UDim2.new(0.098, 0, 0.039, 0)

    local main_pointer = find_location_frame.MainPointer

    TweenService:Create(main_pointer, TweenInfo.new(.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = grown_size}):Play()
    main_pointer.ImageColor3 = Color3.fromRGB(255, 255, 0)

    task.wait(5)

    TweenService:Create(main_pointer, TweenInfo.new(.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = original_size}):Play()
    main_pointer.ImageColor3 = Color3.fromRGB(85, 255, 0)
end)

