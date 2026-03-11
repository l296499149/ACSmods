local BetterWindow = GameMain:GetMod("BetterWindow");--先注册一个新的MOD模块
local SimpleWindow = GameMain:GetMod("SimpleWindow");
BetterWindow.tbWindowClass = BetterWindow.tbWindowClass  or  {};
BetterWindow.tbWindow = BetterWindow.tbWindow or {};
BetterWindow.WindowBase = SimpleWindow.WindowBase;
BetterWindow.enter = false;

function BetterWindow:OnEnter()
	self.enter = true;
end

function BetterWindow:OnLeave()
	self.enter = false;
end


function BetterWindow:NewClass(szName)
	if self.tbWindowClass[szName] ~= nil then
		print("Error:already register WindowClass " .. szName);
		return self.tbWindowClass[szName];
	end
	local tbMod =  Lib:NewClass(self.WindowBase);
	self.tbWindowClass[szName] = tbMod;	
	return tbMod;
end

function BetterWindow:GetWindowClass(szName)
	return self.tbWindowClass[szName];
end


function BetterWindow:GetWindow(szName)
	return self.tbWindow[szName];
end

function BetterWindow:CreateWindow(szName)
	if BetterWindow.tbWindow[szName] ~= nil then
		print("Error:already register Window " .. szName);
		return BetterWindow.tbWindow[szName];
	end
	local win = CS.Wnd_Simple.CreateWindow(szName);
	BetterWindow.tbWindow[szName] = win;
	return win;
end

function BetterWindow.WindowBase:Center()
	self.window:Center();
end

function BetterWindow.WindowBase:AddInput(name,value,x,y)
	local obj = self:AddObjectFromUrl("ui://0xrxw6g7hdhl1c",x,y);
	obj.m_title.text = value;
	obj.name = name;
	return obj;
end

function BetterWindow.WindowBase:AddCheckBox(name,value,x,y)
	local obj = self:AddObjectFromUrl("ui://0xrxw6g7hdhl1a",x,y);
	obj.m_title.text = value;
	obj.name = name;
	return obj;
end

