-- Memory UI: Roblox ScreenGui recreation of generated_ui.cpp in 9zxnk31.rar.
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.
-- The original project draws a 1399 x 731 frame. Its controls here keep UI state only.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

if _G.MemoryUI and type(_G.MemoryUI.Destroy)=="function" then
    pcall(_G.MemoryUI.Destroy)
end
local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MemoryUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Upload the supplied PNGs to Roblox, then put their asset IDs here. Empty IDs
-- use the guarded GitHub adapter when its image APIs exist, or stay hidden.
local ASSET_IDS = {
    background = "", sidebarCrown = "", loginBackground = "", loginCrown = "",
    sliderFill = "",
}
local ICON_IDS = {
    target_fill="", sharp_edit="", baseline_mouse="", view_filled="",
    baseline_discord="", gear="", chevron_right="", users="",
    world_2_fill="", search="", sliders="", dots="", right_fill="",
    users_2="", gamepad_bold="", settings_bold="", dots_2="",
    chevron_down="", pencil="", login_solid="", lock_filled="",
    user_filled="", eye="", view_filled_3="",
}

local C = {
    frame = Color3.fromRGB(15,15,18), panel = Color3.fromRGB(9,9,11),
    sidebar = Color3.fromRGB(9,9,10), header = Color3.fromRGB(10,10,11),
    card = Color3.fromRGB(11,11,13), card2 = Color3.fromRGB(12,12,13),
    stroke = Color3.fromRGB(20,20,23), separator = Color3.fromRGB(17,17,20),
    track = Color3.fromRGB(30,30,32), switchOff = Color3.fromRGB(16,16,19),
    purple = Color3.fromRGB(185,144,252), purpleIcon = Color3.fromRGB(186,145,253),
    text = Color3.fromRGB(240,240,245), muted = Color3.fromRGB(130,130,139),
    dim = Color3.fromRGB(90,90,99), white = Color3.fromRGB(245,245,248),
}
local ICON_TINT = {
    target_fill=Color3.fromRGB(100,100,109), sharp_edit=Color3.fromRGB(102,102,111),
    baseline_mouse=Color3.fromRGB(102,102,111), view_filled=C.purpleIcon,
    baseline_discord=Color3.fromRGB(255,255,255), gear=Color3.fromRGB(115,115,125),
    chevron_right=Color3.fromRGB(111,111,121), users=C.purpleIcon,
    world_2_fill=Color3.fromRGB(148,148,158), search=Color3.fromRGB(146,146,155),
    sliders=Color3.fromRGB(161,126,219), dots=C.text, right_fill=Color3.fromRGB(230,230,235),
    users_2=C.purpleIcon, gamepad_bold=C.purpleIcon, settings_bold=C.purpleIcon,
    dots_2=C.purpleIcon, chevron_down=Color3.fromRGB(197,197,201),
    view_filled_3=C.purpleIcon, pencil=C.purpleIcon,
    user_filled=Color3.fromRGB(107,107,116), lock_filled=Color3.fromRGB(107,107,116),
    eye=Color3.fromRGB(107,107,116), login_solid=C.purpleIcon,
}
local RAW_ASSET_BASE = "https://raw.githubusercontent.com/Financially/stuff/f7ba63ce373b574bc665c60c2b0c9b8b90415a71/memory-ui/assets/"
local AssetManager = {}
function AssetManager.SourceUrl(group,file)
    return RAW_ASSET_BASE .. group .. "/" .. file
end
function AssetManager.Resolve(id,group,file)
    id=tostring(id or "")
    if id~="" then
        return id:match("^rbxasset") and id or ("rbxassetid://" .. id)
    end
    -- This branch is available only in runtimes that expose both functions.
    -- It downloads PNG bytes; it never downloads or executes remote code.
    if type(writefile)~="function" or type(getcustomasset)~="function" then return nil end
    local path="memory_ui_" .. group .. "_" .. file
    local ok,asset=pcall(function()
        if type(isfile)~="function" or not isfile(path) then
            local bytes=game:HttpGet(AssetManager.SourceUrl(group,file))
            if type(bytes)~="string" or #bytes<8 then return nil end
            writefile(path,bytes)
        end
        return getcustomasset(path)
    end)
    return ok and type(asset)=="string" and asset or nil
end
local function mix(a,b,t) return a:Lerp(b, math.clamp(t,0,1)) end
local function pos(x,y) return UDim2.fromOffset(x,y) end

local root = Instance.new("Frame")
root.Name = "PixelCoordinateFrame"
root.Size = UDim2.fromOffset(1399,731)
root.BackgroundColor3 = C.frame
root.BorderSizePixel = 0
root.Parent = gui
local scale = Instance.new("UIScale")
scale.Parent = root

local R = {}
function R.Rect(parent,x,y,w,h,fill,radius,stroke,z)
    local f = Instance.new("Frame")
    f.BorderSizePixel = 0
    f.BackgroundColor3 = fill
    f.Position = pos(x,y)
    f.Size = UDim2.fromOffset(w,h)
    f.ZIndex = z or 1
    f.Parent = parent
    if radius and radius > 0 then
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0,radius)
        c.Parent = f
    end
    if stroke then
        local s = Instance.new("UIStroke")
        s.Color = stroke
        s.Thickness = 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = f
    end
    return f
end
function R.Text(parent,value,x,y,w,h,size,fill,bold,align,z)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.BorderSizePixel = 0
    t.Text = value
    t.TextSize = size
    t.Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
    t.TextColor3 = fill
    t.TextXAlignment = align or Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    t.Position = pos(x,y)
    t.Size = UDim2.fromOffset(w,h)
    t.ZIndex = z or 2
    t.Parent = parent
    return t
end
function R.Circle(parent,x,y,d,fill,z)
    return R.Rect(parent,x,y,d,d,fill,d/2,nil,z)
end
function R.DrawRect(parent,x,y,w,h,stroke,radius,z)
    local f=R.Rect(parent,x,y,w,h,Color3.new(0,0,0),radius,stroke,z)
    f.BackgroundTransparency=1
    return f
end
R.DrawRectFilled=R.Rect
function R.DrawLine(parent,x1,y1,x2,y2,fill,width,z)
    local dx,dy=x2-x1,y2-y1
    local line=R.Rect(parent,(x1+x2)/2,(y1+y2)/2,math.sqrt(dx*dx+dy*dy),width or 1,fill,0,nil,z)
    line.AnchorPoint=Vector2.new(0.5,0.5)
    line.Rotation=math.deg(math.atan2(dy,dx))
    return line
end
function R.DrawPolyline(parent,points,fill,width,z)
    local lines={}
    for i=2,#points do
        local a,b=points[i-1],points[i]
        table.insert(lines,R.DrawLine(parent,a.X,a.Y,b.X,b.Y,fill,width,z))
    end
    return lines
end
function R.PushClipRect(parent,x,y,w,h,z)
    local clip=R.Rect(parent,x,y,w,h,Color3.new(0,0,0),0,nil,z)
    clip.BackgroundTransparency=1
    clip.ClipsDescendants=true
    return clip
end
function R.PopClipRect(clip) return clip.Parent end
function R.Image(parent,id,x,y,w,h,z,group,file)
    if id == "" and not group then return nil end
    local im = Instance.new("ImageLabel")
    im.BackgroundTransparency = 1
    im.BorderSizePixel = 0
    local direct=tostring(id or "")
    im.Image = direct=="" and "" or (direct:match("^rbxasset") and direct or "rbxassetid://"..direct)
    im.Visible = direct~=""
    im.Position = pos(x,y)
    im.Size = UDim2.fromOffset(w,h)
    im.ZIndex = z or 3
    im.Parent = parent
    if direct=="" and group then
        task.spawn(function()
            local resolved=AssetManager.Resolve("",group,file)
            if resolved and im.Parent then im.Image=resolved; im.Visible=true end
        end)
    end
    return im
end
function R.Icon(parent,key,x,y,w,h,z)
    local image=R.Image(parent,ICON_IDS[key] or "",x,y,w,h,z,"icons",key..".png")
    if image then image.ImageColor3=ICON_TINT[key] or C.white; return image end
    local empty=R.Rect(parent,x,y,w,h,C.panel,0,nil,z)
    empty.BackgroundTransparency=1
    empty.Visible=false
    return empty
end
function R.Hit(parent,x,y,w,h,callback,z)
    local b = Instance.new("TextButton")
    b.Text = ""
    b.BackgroundTransparency = 1
    b.BorderSizePixel = 0
    b.Position = pos(x,y)
    b.Size = UDim2.fromOffset(w,h)
    b.ZIndex = z or 5
    b.Parent = parent
    b.MouseButton1Click:Connect(callback)
    return b
end

local connections = {}
local function connect(signal,callback)
    local c = signal:Connect(callback)
    table.insert(connections,c)
    return c
end
local function updateRoot()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local vp = camera.ViewportSize
    local s = math.min(1,vp.X/1399,vp.Y/731)
    scale.Scale = s
    root.Position = pos(math.floor((vp.X-1399*s)/2),math.floor((vp.Y-731*s)/2))
end
updateRoot()
connect(workspace:GetPropertyChangedSignal("CurrentCamera"),function()
    updateRoot()
    if workspace.CurrentCamera then
        connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),updateRoot)
    end
end)
if workspace.CurrentCamera then
    connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),updateRoot)
end

local dashboard = R.Rect(root,23,35,868,681,C.panel,13,Color3.fromRGB(24,24,27),1)
dashboard.Name = "Dashboard"
local content = R.Rect(dashboard,183,60,685,621,C.panel,0,nil,1)
R.Image(content,ASSET_IDS.background,0,0,685,621,2,"textures","subtle_dark_interface_background_texture.png")
local sidebar = R.Rect(dashboard,0,0,183,681,C.sidebar,12,nil,3)
R.Rect(dashboard,183,0,685,60,C.header,0,nil,2)

local function crown(parent,x,y,w,h,z)
    R.Image(parent,ASSET_IDS.sidebarCrown,x,y,w,h,z,"textures","sidebar_crown_logo.png")
end
crown(sidebar,26,21,39,25,4)
R.Text(sidebar,"Memory",80,18,82,19,15,C.text,true,nil,4)
R.Text(sidebar,"Roblox",80,36,80,13,9,Color3.fromRGB(100,100,109),false,nil,4)
R.Text(sidebar,"COMBAT",17,79,110,15,10,C.dim,true,nil,4)
R.Text(sidebar,"GENERAL",17,237,110,15,10,C.dim,true,nil,4)

local tabs = {
    {"Memory",13.28,"view_filled"}, {"Aimbot",105.75,"target_fill"},
    {"Manipulation",145.945,"sharp_edit"}, {"Triggerbot",188.5473,"baseline_mouse"},
    {"Visuals",269,"view_filled"},
}
local selectedTab = 5
local tabVisuals = {}
for i,item in ipairs(tabs) do
    local y = item[2]
    local bg = R.Rect(sidebar,13.28,y,161.72,30,Color3.fromRGB(17,17,18),7,nil,4)
    local icon = R.Icon(sidebar,item[3],21,y+5,22,20,5)
    local label = R.Text(sidebar,item[1],50,y,112,30,11.5,C.muted,false,nil,5)
    tabVisuals[i] = {bg=bg,icon=icon,label=label,amount=(i==5 and 1 or 0)}
    R.Hit(sidebar,13.28,y,161.72,30,function() selectedTab=i end,6)
end
R.Rect(sidebar,0,624,184,1,Color3.fromRGB(28,28,32),0,nil,4)
R.Circle(sidebar,19,641,23,Color3.fromRGB(88,101,242),4)
R.Icon(sidebar,"baseline_discord",20,641,21,22,5)
R.Text(sidebar,"Username",51,638,95,15,11,Color3.fromRGB(224,224,228),false,nil,5)
R.Text(sidebar,"Lifetime",51,651,95,14,10,Color3.fromRGB(90,90,98),false,nil,5)
R.Icon(sidebar,"gear",149,641,25,25,5)

-- Header, including the breadcrumb labels visible in the original frame.
R.Icon(dashboard,"view_filled",200,18,23,22,4)
local breadcrumb={selected=2}
local breadcrumbVisuals=R.Text(dashboard,"Visuals",225,19,54,20,12,C.text,false,nil,4)
R.Icon(dashboard,"chevron_right",277,19,23,20,4)
R.Icon(dashboard,"users",306,19,22,20,4)
local breadcrumbPlayers=R.Text(dashboard,"Players",331,19,57,20,12,C.text,false,nil,4)
R.Icon(dashboard,"world_2_fill",397,19,20,20,4)
local breadcrumbWorld=R.Text(dashboard,"World",423,19,55,20,11.5,Color3.fromRGB(110,110,120),false,nil,4)
R.Icon(dashboard,"search",839,19,26,20,4)
local breadcrumbLabels={breadcrumbVisuals,breadcrumbPlayers,breadcrumbWorld}
local breadcrumbRects={{200,12,80,38},{305,12,86,38},{394,12,90,38}}
for i,rect in ipairs(breadcrumbRects) do
    R.Hit(dashboard,rect[1],rect[2],rect[3],rect[4],function()
        breadcrumb.selected=i
        for j,label in ipairs(breadcrumbLabels) do
            label.TextColor3=(j<=i) and C.text or Color3.fromRGB(110,110,120)
        end
    end,6)
end

local function heading(parent,x,y,w,title)
    local iconKey=({Main="sliders",Player="users_2",Info="gamepad_bold",Extras="settings_bold",Other="dots_2",Visuals="view_filled_3",Effects="pencil"})[title]
    R.Icon(parent,iconKey,x+16,y+11,22,22,4)
    R.Text(parent,title,x+39,y+2,w-48,40,13,Color3.fromRGB(223,223,228),true,nil,4)
end
local function panel(x,y,w,h,title,round,floatingTitle)
    local p = R.Rect(dashboard,x-23,y-35,w,h,C.card,round or 0,C.stroke,3)
    R.Rect(p,1,floatingTitle and 0 or 43,w-2,1,C.separator,0,nil,4)
    heading(p,0,floatingTitle and -35 or 0,w,title)
    return p
end
local main = panel(214,115,328,133,"Main")
local playerPanel = panel(214,261,328,173,"Player")
local info = panel(214,492,328,129,"Info",0,true)
local extras = panel(214,635,328,73,"Extras",10)
local other = panel(554,115,328,270,"Other")
local visual = panel(554,399,328,173,"Visuals")
local effects = panel(554,586,328,145,"Effects")

local switches = {}
local function switch(panelRef,key,label,rowY,trackX)
    local y = rowY
    R.Text(panelRef,label,17,y,205,28,11.5,C.text,false,nil,4)
    local off = R.Rect(panelRef,trackX,y+4,36,20,C.switchOff,9,Color3.fromRGB(26,26,29),4)
    local dot = R.Circle(off,3,3,14,C.white,5)
    local state = {value=false,anim=0,hover=0,frame=off,dot=dot}
    switches[key]=state
    local hit = R.Hit(panelRef,14,y,300,28,function() state.value=not state.value end,6)
    hit.MouseEnter:Connect(function() state.hover=1 end)
    hit.MouseLeave:Connect(function() state.hover=0 end)
    return state
end
switch(main,"enable","Enable",48,274)
switch(main,"boxes","Boxes",89,274)
switch(playerPanel,"name_tags","name tags",48,274)
switch(playerPanel,"health","health",89,274)
switch(playerPanel,"armor","armor",130,274)
switch(info,"range","range",6,274)
switch(info,"loadout","loadout",47,274)
switch(info,"edge_arrows","edge arrows",88,274)
switch(extras,"spectators","spectators",48,274)
switch(visual,"body","body",48,274)
switch(visual,"outline","outline",89,274)
switch(visual,"highlight","highlight",130,274)
switch(effects,"motion","motion",48,274)
switch(effects,"hit_fx","hit fx",89,274)

-- Source artwork includes a small colored square/chevron on the Boxes row.
R.Rect(main,236,98,14,14,C.purple,5,nil,5)
R.Icon(main,"right_fill",252,95,17,20,5)

local slider = {value=0.5,shown=0.5,active=false}
R.Text(other,"Example",18,47,103,26,11.5,C.text,false,nil,4)
local track = R.Rect(other,83,64,154,6,C.track,2,nil,4)
local fill = R.Rect(track,0,0,77,6,C.purple,2,nil,5)
local fillImage=R.Image(fill,ASSET_IDS.sliderFill,0,0,77,6,6,"textures","example_slider_filled_part.png")
if fillImage then fillImage.Size=UDim2.fromScale(1,1) end
local thumb = R.Rect(other,153,63,13.44,6,Color3.new(1,1,1),2,nil,6)
local valueBox = R.Rect(other,251,52,59,27,Color3.fromRGB(14,14,16),0,Color3.fromRGB(19,19,23),4)
local valueText=Instance.new("TextBox")
valueText.Name="SliderValue"
valueText.Text="50.0"
valueText.BackgroundTransparency=1
valueText.BorderSizePixel=0
valueText.ClearTextOnFocus=false
valueText.Font=Enum.Font.GothamMedium
valueText.TextSize=11.5
valueText.TextColor3=Color3.fromRGB(208,208,212)
valueText.TextXAlignment=Enum.TextXAlignment.Center
valueText.Size=UDim2.fromScale(1,1)
valueText.ZIndex=6
valueText.Parent=valueBox
local sliderHit = R.Hit(other,83,55,154,22,function() end,7)
local function sliderAt(input)
    local x=input.Position.X-track.AbsolutePosition.X
    slider.value=math.clamp(x/math.max(track.AbsoluteSize.X,1),0,1)
end
local editingValue=false
valueText.Focused:Connect(function() editingValue=true end)
valueText.FocusLost:Connect(function(enterPressed)
    editingValue=false
    if enterPressed then
        local parsed=tonumber(valueText.Text)
        if parsed then
            slider.value=math.clamp(parsed,0,100)/100
            slider.shown=slider.value
        end
    end
    valueText.Text=string.format("%.1f",slider.shown*100)
end)
sliderHit.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        slider.active=true
        sliderAt(input)
    end
end)
connect(UserInputService.InputChanged,function(input)
    if slider.active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then sliderAt(input) end
end)
connect(UserInputService.InputEnded,function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then slider.active=false end
end)

local activeCombo = nil
local combos = {}
local function combo(key,y,label)
    R.Text(other,label,18,y,120,32,11.5,C.text,false,nil,4)
    local box = R.Rect(other,162,y,148,32,C.card,11,Color3.fromRGB(20,20,24),5)
    R.Text(box,"Player 1",12,0,112,32,11,Color3.fromRGB(213,213,218),false,nil,6)
    local arrow = R.Icon(box,"chevron_down",124,7,15,15,6)
    local popup = R.Rect(other,162,y+38,148,32,C.card,11,Color3.fromRGB(20,20,24),10)
    R.Text(popup,"Player 1",12,0,120,32,11,Color3.fromRGB(242,242,244),false,nil,11)
    popup.Visible=false
    local state={box=box,popup=popup,arrow=arrow,open=false}
    combos[key]=state
    R.Hit(box,0,0,148,32,function()
        if activeCombo and activeCombo~=state then activeCombo.open=false; activeCombo.popup.Visible=false end
        state.open=not state.open
        state.popup.Visible=state.open
        activeCombo=state.open and state or nil
    end,8)
    R.Hit(popup,0,0,148,32,function() state.open=false;popup.Visible=false;activeCombo=nil end,12)
end
combo("target",94,"Target")
combo("players",138,"Players")
connect(UserInputService.InputBegan,function(input)
    if not activeCombo then return end
    if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
    local p=Vector2.new(input.Position.X,input.Position.Y)
    local function inside(f)
        local a=f.AbsolutePosition; local s=f.AbsoluteSize
        return p.X>=a.X and p.X<=a.X+s.X and p.Y>=a.Y and p.Y<=a.Y+s.Y
    end
    if not inside(activeCombo.box) and not inside(activeCombo.popup) then
        activeCombo.open=false
        activeCombo.popup.Visible=false
        activeCombo=nil
    end
end)

local function inputField(parent,x,y,w,h,placeholder,secret)
    local box = R.Rect(parent,x,y,w,h,C.card2,9,Color3.fromRGB(20,20,23),4)
    local input = Instance.new("TextBox")
    input.BackgroundTransparency=1
    input.BorderSizePixel=0
    input.ClearTextOnFocus=false
    input.Font=Enum.Font.GothamMedium
    input.TextSize=11
    input.TextColor3=C.text
    input.PlaceholderColor3=Color3.fromRGB(82,82,89)
    input.PlaceholderText=placeholder
    input.Text=""
    input.TextXAlignment=Enum.TextXAlignment.Left
    input.Position=pos(12,0)
    input.Size=UDim2.fromOffset(w-24,h)
    input.ZIndex=5
    input.Parent=box
    if secret then
        -- Roblox TextBox has no native masked input. A display mask is maintained
        -- separately while a focused field receives keyboard input.
        input.TextEditable=false
    end
    return input,box
end
local playersField = inputField(other,18,183,292,30,"Example",false)
local exampleField = inputField(other,18,227,292,30,"Enter text",false)

-- Initial login panel. The original offsets it by (-439.5,+140.5) to center it.
local backdrop = R.Rect(root,0,0,1399,731,C.frame,0,nil,18)
backdrop.BackgroundTransparency=0
backdrop.Active=false
local login = R.Rect(root,475.5,175.5,448,380,C.panel,13,Color3.fromRGB(12,12,13),19)
login.Name="LoginPanel"
R.Image(login,ASSET_IDS.loginBackground,0,0,448,380,20,"textures","login_panel_dark_abstract_background_texture.png")
R.Image(login,ASSET_IDS.loginCrown,153,76,49,31,21,"textures","login_crown_logo.png")
R.Text(login,"Memory",222,70,160,25,19,C.text,true,nil,21)
R.Text(login,"Loader",222,94,100,16,12,Color3.fromRGB(100,100,109),false,nil,21)
local username = inputField(login,26,140,396,33,"Username",false)
local passwordBox = R.Rect(login,26,184,396,32,C.card2,0,Color3.fromRGB(20,20,23),21)
local passwordMask = R.Text(passwordBox,"Password",31,0,333,32,11,Color3.fromRGB(81,81,88),false,nil,22)
local passwordInput=Instance.new("TextBox")
passwordInput.Text=""
passwordInput.Size=UDim2.fromOffset(1,1)
passwordInput.Position=pos(31,15)
passwordInput.TextTransparency=1
passwordInput.BackgroundTransparency=1
passwordInput.ClearTextOnFocus=false
passwordInput.ZIndex=22
passwordInput.Parent=passwordBox
local password=""
R.Hit(passwordBox,0,0,396,32,function()
    passwordInput:CaptureFocus()
end,23)
local eye = R.Icon(passwordBox,"eye",366,7,20,18,24)
local reveal=false
R.Hit(passwordBox,364,0,32,32,function()
    reveal=not reveal
    passwordMask.Text=reveal and password or string.rep("•",#password)
end,25)
passwordInput:GetPropertyChangedSignal("Text"):Connect(function()
    password=passwordInput.Text
    passwordMask.Text=password=="" and "Password" or (reveal and password or string.rep("•",#password))
end)
local loginButton = R.Rect(login,26,234,396,32,C.card2,9,Color3.fromRGB(21,21,23),21)
R.Icon(loginButton,"login_solid",165,7,24,18,22)
R.Text(loginButton,"Login",192,0,85,32,11,Color3.fromRGB(140,140,149),false,nil,22)
local status = R.Text(login,"",26,287,396,20,11,Color3.fromRGB(236,88,92),false,Enum.TextXAlignment.Center,22)
local postLoginStatus=R.Text(root,"",1059,325,160,20,11,Color3.fromRGB(141,209,130),false,Enum.TextXAlignment.Center,19)
postLoginStatus.Visible=false
local postLoginUntil=0
local authenticated=false
local function tryLogin()
    if username.Text=="" then status.Text="Enter a username"; return end
    if password=="" then status.Text="Enter a password"; return end
    if string.lower(username.Text)~="glitch" or password~="Glitch" then
        status.Text="Invalid credentials"; return
    end
    status.Text="Welcome, Glitch"
    status.TextColor3=Color3.fromRGB(141,209,130)
    postLoginStatus.Text="Welcome, Glitch"
    postLoginStatus.TextTransparency=0
    postLoginStatus.Visible=true
    postLoginUntil=os.clock()+3.5
    authenticated=true
    selectedTab=4 -- Original try_login() selects Triggerbot (index 3).
end
R.Hit(loginButton,0,0,396,32,tryLogin,23)
connect(UserInputService.InputBegan,function(input,processed)
    if not authenticated and passwordInput:IsFocused() and
        (input.KeyCode==Enum.KeyCode.Return or input.KeyCode==Enum.KeyCode.KeypadEnter) then tryLogin() end
end)
username.FocusLost:Connect(function(enter) if enter then tryLogin() end end)

-- Dragging is limited to unused header space. Source window itself is fixed size.
local dragging=false
local dragStart=Vector2.zero
local dragOrigin=Vector2.zero
local dragHit=R.Hit(dashboard,510,0,320,60,function() end,7)
dragHit.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=Vector2.new(input.Position.X,input.Position.Y)
        dragOrigin=Vector2.new(root.Position.X.Offset,root.Position.Y.Offset)
    end
end)
connect(UserInputService.InputChanged,function(input)
    if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
        local delta=Vector2.new(input.Position.X,input.Position.Y)-dragStart
        root.Position=pos(dragOrigin.X+delta.X,dragOrigin.Y+delta.Y)
    end
end)
connect(UserInputService.InputEnded,function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)

local fade=0
connect(RunService.RenderStepped,function(dt)
    local function approach(a,b,s)
        local n=a+(b-a)*(1-math.exp(-s*dt))
        return math.abs(n-b)<0.0005 and b or n
    end
    for i,v in ipairs(tabVisuals) do
        v.amount=approach(v.amount,(selectedTab==i and 1 or 0),14)
        v.bg.BackgroundTransparency=1-v.amount
        if v.icon:IsA("ImageLabel") then v.icon.ImageColor3=mix(C.muted,C.purpleIcon,v.amount) end
        v.label.TextColor3=mix(C.muted,C.text,v.amount)
    end
    for _,v in pairs(switches) do
        v.anim=approach(v.anim,v.value and 1 or 0,16)
        v.frame.BackgroundColor3=mix(C.switchOff,C.purple,v.anim)
        v.dot.Position=pos(3+16*v.anim,3)
    end
    slider.shown=approach(slider.shown,slider.value,slider.active and 40 or 18)
    fill.Size=UDim2.fromOffset(154*slider.shown,6)
    thumb.Position=pos(83+slider.shown*(154-13.44),63)
    if not editingValue then valueText.Text=string.format("%.1f",slider.shown*100) end
    fade=approach(fade,authenticated and 1 or 0,8)
    backdrop.BackgroundTransparency=fade
    backdrop.Visible=fade<0.999
    login.Visible=not authenticated
    if postLoginStatus.Visible and os.clock()>postLoginUntil then
        postLoginStatus.TextTransparency=math.clamp((os.clock()-postLoginUntil)*1.5,0,1)
        if postLoginStatus.TextTransparency>=1 then postLoginStatus.Visible=false end
    end
end)

local api={Gui=gui,Controls=switches,Slider=slider,Combos=combos,Breadcrumb=breadcrumb,Renderer=R,Assets=AssetManager}
function api.Destroy()
    for _,c in ipairs(connections) do c:Disconnect() end
    gui:Destroy()
end
_G.MemoryUI=api

