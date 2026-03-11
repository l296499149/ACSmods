local GreatPainter = GameMain:GetMod("GreatPainter");--先注册一个新的MOD模块
--GreatPainter.AutoStart = true;
GreatPainter.Power = 12;
local GlobleDataMgr = CS.XiaWorld.GlobleDataMgr.Instance;
GreatPainter_MainUI = GreatPainter_MainUI or GameMain:GetMod("Windows"):CreateWindow("GreatPainter_MainUI");
function GreatPainter:OnInit()
	print("GreatPainter init");	
	--接管需要用的管理类
	GreatPainter:LoadSetting();
	GreatPainter.WorldLuaHelper = CS.WorldLuaHelper();
	GreatPainter_MainUI:Init();
	GreatPainter.LocalLoad = true;
end

local function QuickPaintPlus(power)
	local _GreatPainter = GameMain:GetMod("GreatPainter");
	_GreatPainter.Window.BrokenCallBack(_GreatPainter.Window.SelectName, 1, power, true);
	_GreatPainter.Window.BrokenCallBack = nil;
	if not _GreatPainter.Window.waithide then
		_GreatPainter.Window:Hide();
	else
		_GreatPainter.Window.willhide = true;
		CS.MapRender.Instance.MousePainter.enabled = false;
	end
end

local function UpdateButton(EventContext)
	if EventContext.sender.selectedIndex == 2 then
		GreatPainter.Button:SetXY(GreatPainter.Window.contentPane.m_n51.x - 10, GreatPainter.Window.contentPane.m_n51.y - 35);
		GreatPainter.Button.visible = true;
	else
		GreatPainter.Button.visible = false;
	end
end

local function CallWindow()
	print(GreatPainter.Power)
	local Window = CS.Wnd_Message.ShowSlider("超级符师", 2, function(f) if f > -1 then QuickPaintPlus(f+1) end; end, true, nil, nil, GreatPainter.Power -1, true);
	--Window.UIInfo.m_n45.value = 0;
	Window.UIInfo.m_slidertxt.text = string.format("------------------------%02d倍画符------------------------", Window.UIInfo.m_n45.value+1) .. "\n[color=#ff0000]超级符师MOD功能！请谨慎选择倍率以免破坏游戏体验！[/color]";
	Window.UIInfo.m_n45.onChanged:Add(function(e) Window.UIInfo.m_slidertxt.text = string.format("------------------------%02d倍画符------------------------", e.sender.value+1) .."\n[color=#ff0000]超级符师MOD功能！请谨慎选择倍率以免破坏游戏体验！[/color]"; end);
end

local function AddButton()
	local obj = UIPackage.CreateObjectFromURL("ui://0xrxw6g7hdhl18");
	local Button = GreatPainter.Window.contentPane:AddChild(obj);
	Button.width = 75;
	Button.title = "快速画符+";
	Button.name = "QuickPaintPluse";
	Button.onClick:Add(function() CallWindow(); end);
	Button.visible = false;
	GreatPainter.Button = Button;
	GreatPainter.Window.contentPane.m_Mode.onChanged:Add(function(EventContext) UpdateButton(EventContext) end);
	GreatPainter.Window.onPositionChanged:Clear();
end

function GreatPainter:OnEnter()
	print("GreatPainter enter");
	xlua.private_accessible(CS.Wnd_FuPatinter);
	--初始化UI内容
	--if GreatPainter.LocalLoad == true then
	--	GreatPainter:LoadSetting()
	--else
	--	GreatPainter:SaveSetting()
	--end
	GreatPainter_MainUI:Show();
	if GreatPainter.AutoStart == false then
		GreatPainter_MainUI:Hide();
	end
	if GreatPainter.YouCui then
		CS.XiaWorld.GameDefine.SOULCRYSTALYOU_BASE = 1;
	end
	if GreatPainter.LingCui then
		CS.XiaWorld.GameDefine.SOULCRYSTALLING_BASE = 1;
	end
	GreatPainter.Window = CS.Wnd_FuPatinter.Instance;
	GreatPainter.Window.onPositionChanged:Add(function() AddButton() end);
end

function GreatPainter:OnStep(dt)--请谨慎处理step的逻辑，可能会影响游戏效率
	--print("GreatPainter Step"..dt);
end

function GreatPainter:OnRender(dt)--渲染帧 刷新
	--print("GreatPainter Render"..dt);
end

function GreatPainter:ToStringEx(value)
    if type(value)=='table' then
        return GreatPainter:TableToStr(value)
    elseif type(value)=='string' then
        return "\'"..value.."\'"
    else
        return tostring(value)
    end
end

function GreatPainter:TableToStr(t)
    if t == nil then return "" end
    local retstr= "{"

    local i = 1
    for key,value in pairs(t) do
        local signal = ","
        if i==1 then
            signal = ""
        end

        if key == i then
            retstr = retstr..signal..GreatPainter:ToStringEx(value)
        else
            if type(key)=='number' or type(key) == 'string' then
                retstr = retstr..signal..'['..GreatPainter:ToStringEx(key).."]="..GreatPainter:ToStringEx(value)
            else
                if type(key)=='userdata' then
                    retstr = retstr..signal.."*s"..GreatPainter:TableToStr(getmetatable(key)).."*e".."="..GreatPainter:ToStringEx(value)
                else
                    retstr = retstr..signal..key.."="..GreatPainter:ToStringEx(value)
                end
            end
        end

        i = i+1
    end

    retstr = retstr.."}"
    return retstr
end

function GreatPainter:LoadSetting()
	local file = io.open(".\\saves\\GreatPainter.cfg", "r")
	if file == nil then
		print("没有配置文件，创建新的配置文件。");
		
		if GreatPainter.AutoStart == nil then
			GreatPainter.AutoStart = true;
		end
		if GreatPainter.YouCui == nil then
			GreatPainter.YouCui = false;
		end
		if GreatPainter.LingCui == nil then
			GreatPainter.LingCui = false;
		end
		GreatPainter:SaveSetting();
		return;
	end
	local t = file:read("*all")
	print("超级符师读取设置："..t)
	local data = load("return "..t)();
	
	GreatPainter.AutoStart = data.AutoStart;
	GreatPainter.YouCui = data.YouCui;
	GreatPainter.LingCui = data.LingCui;
	file:close();
	return;
end

function GreatPainter:SaveSetting()
	local file = io.open(".\\saves\\GreatPainter.cfg", "w")
	if GreatPainter.AutoStart == nil then
		GreatPainter.AutoStart = true;
	end
	if GreatPainter.YouCui == nil then
		GreatPainter.YouCui = false;
	end
	if GreatPainter.LingCui == nil then
		GreatPainter.LingCui = false;
	end
	local data = {
		AutoStart = GreatPainter.AutoStart;
		YouCui = GreatPainter.YouCui;
		LingCui = GreatPainter.LingCui
		};
	print("超级符师保存设置："..GreatPainter:ToStringEx(data))
	file:write(GreatPainter:ToStringEx(data));
	file:close()
end

function GreatPainter:OnSave()--系统会将返回的table存档 table应该是纯粹的KV
	print("GreatPainter OnSave");
end

function GreatPainter:OnLoad(tbLoad)--读档时会将存档的table回调到这里
	print("GreatPainter OnLoad");
end

function GreatPainter:OnLeave()
	GreatPainter:SaveSetting();
	print("GreatPainter Leave");
end

function GreatPainter:OnSetHotKey()  --更新了热键方法
	local HotKey = { {ID = "GreatPainter" , Name = "超级符师" , Type = "Mod", InitialKey1 = "F8" } };
	return HotKey;
end

function GreatPainter:OnHotKey(ID,state)
	if ID == "GreatPainter" and state == "down" then
		if GreatPainter_MainUI.isShowing then
			GreatPainter_MainUI:Hide();
		else
			GreatPainter_MainUI:Show();
		end
	end
end

function GreatPainter:SetAutoStart(bool)
	GreatPainter.AutoStart = bool;
end

function GreatPainter:SetAll(value)

	local data = PracticeMgr.m_mapSpellDefs;
	local count = 0;
	local realvalue = value/100;
	local newvalue = realvalue/0.95;
	if realvalue == nil then
		GreatPainter.WorldLuaHelper:ShowMsgBox("出错啦！\n超级符师修改失败！\n请及时反馈bug","超级符师");
		return;
	end
	for k, v in pairs(data) do
		local s , cv = GlobleDataMgr.FuSaves:TryGetValue(k)
		if s and cv > newvalue then
			GlobleDataMgr.FuSaves:Remove(k)
		end
		GlobleDataMgr:SaveFuValue(k,newvalue);
	
		local spelldef = PracticeMgr:GetSpellDef(k)
		local spellname = spelldef.DisplayName;
		print(spellname , " 快速画符品质已修改为：" , newvalue);
		count = count + 1;
	end
	print("所有符文都已修改完毕2");
	GreatPainter_MainUI:FuListUpdate(); --更新符文列表
	--弹出窗口显示Log
	GreatPainter.WorldLuaHelper:ShowMsgBox("超级符师修改成功"..count.."个符文","超级符师");
end



function GreatPainter:SetOne(name,value)
	local data = PracticeMgr.m_mapSpellDefs;
	local realvalue = value/100;
	local newvalue = realvalue/0.95;
	if realvalue == nil then
		GreatPainter.WorldLuaHelper:ShowMsgBox("出错啦！\n超级符师修改失败！\n请及时反馈bug","超级符师");
		return;
	end
	local s , cv = GlobleDataMgr.FuSaves:TryGetValue(name)
	if s and cv > newvalue then
		GlobleDataMgr.FuSaves:Remove(name)
	end
	GlobleDataMgr:SaveFuValue(name,newvalue);
	local spelldef = PracticeMgr:GetSpellDef(name)
	local spellname = spelldef.DisplayName;
	print(spellname , " 快速画符品质已修改为：" , newvalue);
	print("单个符文都已修改完毕");
	GreatPainter_MainUI:FuListUpdate();
	--弹出窗口显示Log
	GreatPainter.WorldLuaHelper:ShowMsgBox("超级符师修改成功\n符文：".. spellname .. "\n快速画符品质已修改为：" .. value,"超级符师");
end

function GreatPainter:OnLeave()
	GreatPainter:SaveSetting();
end