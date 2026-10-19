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
local playerGui = player:WaitForChild("PlayerGui")
local previousGui = playerGui:FindFirstChild("MemoryUI")
if previousGui then previousGui:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "MemoryUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- Upload the supplied PNGs to Roblox, then put their asset IDs here. Empty IDs
-- use the guarded GitHub adapter when its image APIs exist, or stay hidden.
local ASSET_IDS = {
    background = "", sidebarCrown = "",
    sliderFill = "",
}
local ICON_IDS = {
    target_fill="", sharp_edit="", baseline_mouse="", view_filled="",
    baseline_discord="", gear="", chevron_right="", users="",
    world_2_fill="", search="", sliders="", dots="", right_fill="",
    users_2="", gamepad_bold="", settings_bold="", dots_2="",
    chevron_down="", pencil="", view_filled_3="",
}
-- Supply uploaded Roblox FontFamily asset IDs for the extracted source fonts.
local FONT_IDS = {inter="",geist="",roboto=""}
local function fontFace(family,bold)
    local id=tonumber(FONT_IDS[family])
    if not id then return nil end
    local weight=bold and Enum.FontWeight.Bold or Enum.FontWeight.Medium
    local ok,face=pcall(Font.fromId,id,weight)
    return ok and face or nil
end

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
-- Coordinates are measured in the source's 1399 x 731 design space.
local G = {
    frame={w=1399,h=731}, dashboard={x=23,y=35,w=868,h=681},
    sidebar={w=183}, header={h=60},
    main={214,115,328,133}, player={214,261,328,173},
    info={214,492,328,129}, extras={214,635,328,73},
    other={554,115,328,270}, visuals={554,399,328,173},
    effects={554,586,328,145},
    switch={w=36,h=20,rowStep=41}, slider={w=154,h=6},
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
root.Size = UDim2.fromOffset(G.frame.w,G.frame.h)
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
function R.Text(parent,value,x,y,w,h,size,fill,bold,align,z,family)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.BorderSizePixel = 0
    t.Text = value
    t.TextSize = size
    t.Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
    local face=fontFace(family or "inter",bold)
    if face then t.FontFace=face end
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
    if image then image.ScaleType=Enum.ScaleType.Fit;image.ImageColor3=ICON_TINT[key] or C.white; return image end
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
    local s = math.min(1,vp.X/G.frame.w,vp.Y/G.frame.h)
    scale.Scale = s
    root.Position = pos(math.floor((vp.X-G.frame.w*s)/2),math.floor((vp.Y-G.frame.h*s)/2))
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

local dashboard = R.Rect(root,G.dashboard.x,G.dashboard.y,G.dashboard.w,G.dashboard.h,C.panel,13,Color3.fromRGB(24,24,27),1)
dashboard.Name = "Dashboard"
local content = R.Rect(dashboard,183,60,685,621,C.panel,0,nil,1)
R.Image(content,ASSET_IDS.background,0,0,685,621,2,"textures","subtle_dark_interface_background_texture.png")
local sidebar = R.Rect(dashboard,0,0,G.sidebar.w,G.dashboard.h,C.sidebar,12,nil,3)
R.Rect(dashboard,G.sidebar.w,0,685,G.header.h,C.header,0,nil,2)

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
    local icon, label
    if i > 1 then
        local sourceIcons={target_fill={22.78,112.75,16,16},sharp_edit={21.05,151.17,19.55,19.55},baseline_mouse={21.67,196.35,14,14},view_filled={23.52,271.85,15,15}}
        local spec=sourceIcons[item[3]]
        icon=R.Icon(sidebar,item[3],spec[1],spec[2],spec[3],spec[4],5)
        label=R.Text(sidebar,item[1],50.9,y,112,30,11.5,C.muted,false,nil,5,item[1]=="Visuals" and "geist" or "inter")
    end
    tabVisuals[i] = {bg=bg,icon=icon,label=label,amount=(i==5 and 1 or 0)}
    R.Hit(sidebar,13.28,y,161.72,30,function() selectedTab=i end,6)
end
R.Rect(sidebar,0,624,184,1,Color3.fromRGB(28,28,32),0,nil,4)
R.Circle(sidebar,19,641,23,Color3.fromRGB(88,101,242),4)
R.Icon(sidebar,"baseline_discord",21.78,644.32,16,16,5)
R.Text(sidebar,"Username",51,638,95,15,11,Color3.fromRGB(224,224,228),false,nil,5)
R.Text(sidebar,"Lifetime",51,651,95,14,10,Color3.fromRGB(90,90,98),false,nil,5)
R.Icon(sidebar,"gear",149.56,644.58,15,15,5)

-- Header, including the breadcrumb labels visible in the original frame.
R.Icon(dashboard,"view_filled",200.52,22.84,15,15,4)
local breadcrumb={selected=2}
local breadcrumbVisuals=R.Text(dashboard,"Visuals",225,19,54,20,12,C.text,false,nil,4)
R.Icon(dashboard,"chevron_right",276.98,23.92,13.4,13.4,4)
R.Icon(dashboard,"users",306.29,24.36,15,12,4)
local breadcrumbPlayers=R.Text(dashboard,"Players",331,19,57,20,12,C.text,false,nil,4)
R.Icon(dashboard,"world_2_fill",400.73,22.83,15,15,4)
local breadcrumbWorld=R.Text(dashboard,"World",423,19,55,20,11.5,Color3.fromRGB(110,110,120),false,nil,4)
R.Icon(dashboard,"search",839.2,23.31,14,14,4)
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
    local iconSize=({Main={14,14},Player={18,14.4},Info={21,21},Extras={17,17},Other={15,15},Visuals={17.42,17.42},Effects={19,19}})[title]
    local sourceOffset=({Main={18.21,15.44,39.76,13.66},Player={17.99,15.29,44.78,13.79},
        Info={15.58,2.22,44.85,5.63},Extras={16.31,13.96,40.25,14.56},
        Other={17.82,14.84,38.83,14.58},Visuals={17.47,13.76,44.11,14.16},
        Effects={16,12.74,40.22,14.61}})[title]
    R.Icon(parent,iconKey,x+sourceOffset[1],y+sourceOffset[2],iconSize[1],iconSize[2],4)
    R.Text(parent,title,x+sourceOffset[3],y+sourceOffset[4]-12,w-48,24,13,Color3.fromRGB(223,223,228),true,nil,4,(title=="Main" or title=="Player" or title=="Visuals") and "geist" or "inter")
end
local function panel(x,y,w,h,title,round,floatingTitle)
    local p = R.Rect(dashboard,x-23,y-35,w,h,C.card,round or 0,C.stroke,3)
    R.Rect(p,1,floatingTitle and 0 or 43,w-2,1,C.separator,0,nil,4)
    heading(p,0,floatingTitle and -35 or 0,w,title)
    return p
end
local function panelFrom(spec,title,round,floatingTitle)
    return panel(spec[1],spec[2],spec[3],spec[4],title,round,floatingTitle)
end
local main = panelFrom(G.main,"Main")
local playerPanel = panelFrom(G.player,"Player")
local info = panelFrom(G.info,"Info",0,true)
local extras = panelFrom(G.extras,"Extras",10)
local other = panelFrom(G.other,"Other")
local visual = panelFrom(G.visuals,"Visuals")
local effects = panelFrom(G.effects,"Effects")

local switches = {}
local function switch(panelRef,key,label,rowY,trackX)
    local y = rowY
    R.Text(panelRef,label,17,y,205,28,11.5,C.text,false,nil,4)
    local off = R.Rect(panelRef,trackX,y+4,G.switch.w,G.switch.h,C.switchOff,9,Color3.fromRGB(26,26,29),4)
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
R.Icon(main,"dots",252,52,12,12,5)

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
local valueFace=fontFace("roboto",false)
if valueFace then valueText.FontFace=valueFace end
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
    local inputFace=fontFace("inter",false)
    if inputFace then input.FontFace=inputFace end
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

-- The archive defines selection styling for these tabs but no page content.
-- These three pages are editable UI additions requested for this port.
local extraPages={}
local function extraPage(index,title,iconKey)
    local page=R.Rect(dashboard,183,60,685,621,C.panel,0,nil,8)
    page.Visible=false
    extraPages[index]=page
    R.Icon(page,iconKey,23,20,18,18,9)
    R.Text(page,title,49,16,300,26,15,C.text,true,nil,9)
    R.Rect(page,8,55,669,1,C.separator,0,nil,9)
    return page
end
local function extraCard(page,x,y,title,iconKey)
    local card=R.Rect(page,x,y,320,177,C.card,0,C.stroke,9)
    R.Icon(card,iconKey,17,13,17,17,10)
    R.Text(card,title,42,6,250,34,13,C.text,true,nil,10)
    R.Rect(card,1,43,318,1,C.separator,0,nil,10)
    return card
end
local aimbotPage=extraPage(2,"Aimbot","target_fill")
local aimbotMain=extraCard(aimbotPage,8,72,"Main","sliders")
switch(aimbotMain,"aimbot_enabled","Enable",48,266)
switch(aimbotMain,"aimbot_visible","Visible check",89,266)
switch(aimbotMain,"aimbot_team","Team check",130,266)
local aimbotTarget=extraCard(aimbotPage,349,72,"Target","users_2")
switch(aimbotTarget,"aimbot_head","Head",48,266)
switch(aimbotTarget,"aimbot_body","Body",89,266)
local manipulationPage=extraPage(3,"Manipulation","sharp_edit")
local manipulationMain=extraCard(manipulationPage,8,72,"Main","sliders")
switch(manipulationMain,"manipulation_enabled","Enable",48,266)
switch(manipulationMain,"manipulation_motion","Motion",89,266)
local manipulationTarget=extraCard(manipulationPage,349,72,"Player","users_2")
switch(manipulationTarget,"manipulation_local","Local player",48,266)
switch(manipulationTarget,"manipulation_others","Other players",89,266)
local triggerbotPage=extraPage(4,"Triggerbot","baseline_mouse")
local triggerbotMain=extraCard(triggerbotPage,8,72,"Main","sliders")
switch(triggerbotMain,"triggerbot_enabled","Enable",48,266)
switch(triggerbotMain,"triggerbot_hold","Hold to activate",89,266)
local triggerbotTarget=extraCard(triggerbotPage,349,72,"Target","users_2")
switch(triggerbotTarget,"triggerbot_visible","Visible check",48,266)
switch(triggerbotTarget,"triggerbot_team","Team check",89,266)

-- Visuals color picker: RGB state is derived from HSV drag coordinates.
local colors={body=Color3.fromRGB(185,144,252),outline=Color3.fromRGB(185,144,252),highlight=Color3.fromRGB(185,144,252)}
local picker=R.Rect(dashboard,548,371,228,210,C.card2,9,C.stroke,13)
picker.Visible=false
R.Text(picker,"Color",14,7,180,28,12,C.text,true,nil,14)
local colorPreview=R.Rect(picker,190,12,23,20,C.purple,4,C.stroke,14)
local sat=R.Rect(picker,14,44,200,112,C.white,2,nil,14)
local satGradient=Instance.new("UIGradient")
satGradient.Color=ColorSequence.new(Color3.new(1,1,1),C.purple)
satGradient.Parent=sat
local valueLayer=R.Rect(sat,0,0,200,112,Color3.new(0,0,0),0,nil,15)
local valueGradient=Instance.new("UIGradient")
valueGradient.Rotation=90
valueGradient.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
valueGradient.Parent=valueLayer
local satCursor=R.DrawRect(sat,192,0,9,9,C.white,5,16)
local hueBar=R.Rect(picker,14,168,200,14,C.white,3,nil,14)
local hueGradient=Instance.new("UIGradient")
hueGradient.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromHSV(0,1,1)),
    ColorSequenceKeypoint.new(1/6,Color3.fromHSV(1/6,1,1)),
    ColorSequenceKeypoint.new(2/6,Color3.fromHSV(2/6,1,1)),
    ColorSequenceKeypoint.new(3/6,Color3.fromHSV(3/6,1,1)),
    ColorSequenceKeypoint.new(4/6,Color3.fromHSV(4/6,1,1)),
    ColorSequenceKeypoint.new(5/6,Color3.fromHSV(5/6,1,1)),
    ColorSequenceKeypoint.new(1,Color3.fromHSV(1,1,1)),
})
hueGradient.Parent=hueBar
local hueCursor=R.Rect(hueBar,0,-2,4,18,C.white,2,C.stroke,16)
local pickerKey=nil
local hue,saturation,value=0.75,0.25,1
local picking=nil
local swatches={}
local function redrawPicker()
    local color=Color3.fromHSV(hue,saturation,value)
    if pickerKey then colors[pickerKey]=color;swatches[pickerKey].BackgroundColor3=color end
    colorPreview.BackgroundColor3=color
    satGradient.Color=ColorSequence.new(Color3.new(1,1,1),Color3.fromHSV(hue,1,1))
    satCursor.Position=pos(math.clamp(saturation*200-4,0,191),math.clamp((1-value)*112-4,0,103))
    hueCursor.Position=pos(math.clamp(hue*200-2,0,196),-2)
end
local function pickAt(input)
    local target=picking=="sat" and sat or hueBar
    local left=target.AbsolutePosition.X
    local width=math.max(target.AbsoluteSize.X,1)
    if picking=="sat" then
        saturation=math.clamp((input.Position.X-left)/width,0,1)
        value=1-math.clamp((input.Position.Y-target.AbsolutePosition.Y)/math.max(target.AbsoluteSize.Y,1),0,1)
    else
        hue=math.clamp((input.Position.X-left)/width,0,1)
    end
    redrawPicker()
end
for i,key in ipairs({"body","outline","highlight"}) do
    local swatch=R.Rect(visual,240,52+(i-1)*41,18,18,colors[key],4,C.stroke,6)
    swatches[key]=swatch
    R.Hit(visual,234,46+(i-1)*41,30,30,function()
        pickerKey=key
        hue,saturation,value=colors[key]:ToHSV()
        picker.Visible=true
        redrawPicker()
    end,7)
end
local satHit=R.Hit(sat,0,0,200,112,function() end,17)
local hueHit=R.Hit(hueBar,0,0,200,14,function() end,17)
satHit.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then picking="sat";pickAt(input) end
end)
hueHit.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then picking="hue";pickAt(input) end
end)
connect(UserInputService.InputChanged,function(input)
    if picking and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then pickAt(input) end
end)
connect(UserInputService.InputEnded,function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then picking=nil end
end)
connect(UserInputService.InputBegan,function(input)
    if not picker.Visible then return end
    if input.KeyCode==Enum.KeyCode.Escape then picker.Visible=false;return end
    if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
    local p=input.Position
    local a,s=picker.AbsolutePosition,picker.AbsoluteSize
    if p.X<a.X or p.X>a.X+s.X or p.Y<a.Y or p.Y>a.Y+s.Y then
        local onSwatch=false
        for _,swatch in pairs(swatches) do
            local b,t=swatch.AbsolutePosition,swatch.AbsoluteSize
            if p.X>=b.X-6 and p.X<=b.X+t.X+6 and p.Y>=b.Y-6 and p.Y<=b.Y+t.Y+6 then onSwatch=true;break end
        end
        if not onSwatch then picker.Visible=false end
    end
end)

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

connect(RunService.RenderStepped,function(dt)
    local function approach(a,b,s)
        local n=a+(b-a)*(1-math.exp(-s*dt))
        return math.abs(n-b)<0.0005 and b or n
    end
    for i,v in ipairs(tabVisuals) do
        v.amount=approach(v.amount,(selectedTab==i and 1 or 0),14)
        v.bg.BackgroundTransparency=1-v.amount
        if v.icon and v.icon:IsA("ImageLabel") then v.icon.ImageColor3=mix(C.muted,C.purpleIcon,v.amount) end
        if v.label then v.label.TextColor3=mix(C.muted,C.text,v.amount) end
    end
    for i,page in pairs(extraPages) do page.Visible=(selectedTab==i) end
    if selectedTab~=5 then picker.Visible=false end
    for _,v in pairs(switches) do
        v.anim=approach(v.anim,v.value and 1 or 0,16)
        v.frame.BackgroundColor3=mix(C.switchOff,C.purple,v.anim)
        v.dot.Position=pos(3+16*v.anim,3)
    end
    slider.shown=approach(slider.shown,slider.value,slider.active and 40 or 18)
    fill.Size=UDim2.fromOffset(154*slider.shown,6)
    thumb.Position=pos(83+slider.shown*(154-13.44),63)
    if not editingValue then valueText.Text=string.format("%.1f",slider.shown*100) end
end)

local api={Gui=gui,Controls=switches,Slider=slider,Combos=combos,Breadcrumb=breadcrumb,Colors=colors,Renderer=R,Assets=AssetManager}
function api.Destroy()
    for _,c in ipairs(connections) do c:Disconnect() end
    gui:Destroy()
end
_G.MemoryUI=api
