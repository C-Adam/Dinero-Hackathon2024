task.wait(2)
print("Website Ready!")
--Essential Services/Libaries and Variables 
local UserInputService = game:GetService("UserInputService")
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

    task.wait(3.5)

    TweenService:Create(main_pointer, TweenInfo.new(.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = original_size}):Play()
    main_pointer.ImageColor3 = Color3.fromRGB(85, 255, 0)
end)

--Buy A Container Page Functions
local bin_check = buy_container_frame.BinCheck
local station_check = buy_container_frame.StationCheck
local item_price_label = buy_container_frame.ItemPriceLabel
local total_price_label = buy_container_frame.TotalPriceLabel
local v_station_head_frame = buy_container_frame.VStationHeadFrame
local v_station_body_frame = buy_container_frame.VStationBodyFrame
local purchase_button = buy_container_frame.PurchaseButton
local pay_frame = buy_container_frame.PayFrame
local thank_frame = buy_container_frame.ThankFrame

local say_joke = true

local gal_buttons = {}

local additional_price = 59.98

--Gives all gallon buttons functionality that they light up on clicked
for _, ui_elemnt in buy_container_frame:GetChildren() do
    local is_gal_button = string.find(ui_elemnt.Name, "G")
    if is_gal_button == nil then continue end
    table.insert(gal_buttons, ui_elemnt)
    local selected_color = Color3.fromRGB(85, 170, 255)
    local unselected_color = Color3.fromRGB(255, 255, 255)
    ui_elemnt.Activated:Connect(function()
        for _, gal_button in gal_buttons do
            if gal_button.ImageColor3 == selected_color then
                gal_button.ImageColor3 = unselected_color
            end
        end
        ui_elemnt.ImageColor3 = selected_color
        local gal_price = ui_elemnt:GetAttribute("Price")
        item_price_label.Text = gal_price
        total_price_label.Text = gal_price + additional_price
    end)
end

bin_check.Activated:Connect(function()
    bin_check.ImageTransparency = 0
    station_check.ImageTransparency = 1
    v_station_head_frame.Visible = false
    v_station_body_frame.Visible = false
end)

station_check.Activated:Connect(function()
    station_check.ImageTransparency = 0
    bin_check.ImageTransparency = 1
    v_station_head_frame.Visible = true
    v_station_body_frame.Visible = true
end)

purchase_button.Activated:Connect(function()
    pay_frame.Visible = true
end)

local function FillInformation(bool)
    if bool then
        pay_frame.NameBox.Text = "Ayradeep Ray"
        pay_frame.NumberBox.Text = "************5236"
        pay_frame.DateBox.Text = "**/**"
        pay_frame.CodeBox.Text = "***"
    else
        pay_frame.NameBox.Text = ""
        pay_frame.NumberBox.Text = ""
        pay_frame.DateBox.Text = ""
        pay_frame.CodeBox.Text = ""
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        FillInformation(true)
    elseif input.KeyCode == Enum.KeyCode.LeftAlt then
        say_joke = false
    end
end)

pay_frame.ConfirmButton.Activated:Connect(function()
    if pay_frame.NumberBox.Text == "" then return end
    pay_frame.Visible = false
    if say_joke then
        thank_frame.TextLabel.Text = "Transaction Declined! You don't have any money Ray!"
        thank_frame.ReButton.Text = "Try Again"
    else
        thank_frame.TextLabel.Text = "Thank you for ordering from Prism! We are delighted that you have chosen our services to contribute to a greener future and a more eco-friendly environment!"
        thank_frame.ReButton.Text = "Return"
    end
    task.wait(.5)
    thank_frame.Visible = true
end)

thank_frame.ReButton.Activated:Connect(function()
    if thank_frame.ReButton.Text == "Try Again" then
        thank_frame.Visible = false
        thank_frame.TextLabel.Text = "Thank you for ordering from Prism! We are delighted that you have chosen our services to contribute to a greener future and a more eco-friendly environment!"        
        thank_frame.ReButton.Text = "Return"
        task.wait(.5)
        thank_frame.Visible = true
    else
        thank_frame.Visible = false
    end
    FillInformation(false)
end)
