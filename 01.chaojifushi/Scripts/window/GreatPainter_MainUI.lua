local Windows = GameMain:GetMod("Windows");--先注册一个新的MOD模块
local GreatPainter = GameMain:GetMod("GreatPainter");
GreatPainter_MainUI = Windows:CreateWindow("GreatPainter_MainUI");
local GlobleDataMgr = CS.XiaWorld.GlobleDataMgr.Instance;
function GreatPainter_MainUI:OnInit()
	self.window.contentPane = UIPackage.CreateObject("GreatPainter", "GreatPainterWindow");--载入UI包里的窗口
	self.window.closeButton = self:GetChild("frame"):GetChild("n5");
	self:GetChild("frame"):GetChild("title").text = "超级符师 v2.6"
	self:GetChild("n20").selected = GreatPainter.AutoStart;
	self:GetChild("n20").onClick:Add(GreatPainter_MainUI.OnClick2);
	self:GetChild("n24").selected = GreatPainter.YouCui;
	self:GetChild("n24").onClick:Add(GreatPainter_MainUI.YouCuiClick);
	self:GetChild("n25").selected = GreatPainter.LingCui;
	self:GetChild("n25").onClick:Add(GreatPainter_MainUI.LingCuiClick);
	self:GetChild("n19"):GetChild("title").text = 100;
	self:FuList();
	self:GetChild("list").onClickItem:Add(GreatPainter_MainUI.ClickSelectItem);
	self:GetChild("bnt_1").onClick:Add(GreatPainter_MainUI.OnClick);
	self.window:Center();
	local a = self.window.position;
	self.window:SetPosition(a.x,75,a.x);
end

function GreatPainter_MainUI:OnShowUpdate()
	GreatPainter_MainUI.isShowing = true;
end

function GreatPainter_MainUI:OnShown()
	GreatPainter_MainUI.isShowing = true;
end

function GreatPainter_MainUI:OnHide()
	GreatPainter_MainUI.isShowing = false;
end

function GreatPainter_MainUI:GetQuickData()
	local Quick_Data = {};
	local FuSaves = GlobleDataMgr.FuSaves;
		for k, v in pairs(FuSaves) do
			Quick_Data[k] = v;
		end
	return Quick_Data;
end

function GreatPainter_MainUI:FuList()
	local Fu_all = PracticeMgr.m_mapSpellDefs;
	local Quick_Data = GreatPainter_MainUI:GetQuickData();
	local list = self:GetChild("list");
	
	for k, v in pairs(Fu_all) do
		local spellDef = PracticeMgr:GetSpellDef(k);
		local item = list:AddItemFromPool();
		item.icon = "thing://2,Item_SpellLv3";
		item.name = k;
		if Quick_Data[k] ~= nil and spellDef.Name ~= "Spell_SYSLOST" then	--屏蔽掉模组丢失
			local value = Quick_Data[k] * 100;
			item.title = spellDef.DisplayName .."-"..math.ceil(math.floor(value*0.95));
		else
			item.title = spellDef.DisplayName .."-".."暂无";
		end
		item.tooltips = spellDef.Desc;
	end
end

function GreatPainter_MainUI:FuListUpdate()
	local Quick_Data = GreatPainter_MainUI:GetQuickData();
	local list = self:GetChild("list");
	local Children = list:GetChildren()
	
	for i = 0 , list.numItems-1 , 1 do
		local spellDef = PracticeMgr:GetSpellDef(Children[i].name);
		if Quick_Data[Children[i].name] ~= nil then
			local value = Quick_Data[Children[i].name] * 100;
			Children[i].title = spellDef.DisplayName .."-"..math.ceil(math.floor(value*0.95));
		else
			Children[i].title = spellDef.DisplayName .."-".."暂无";
		end
	end
end


function GreatPainter_MainUI.ClickSelectItem(context)
	GreatPainter_ConfirmUI:Show();
	GreatPainter_ConfirmUI:UpdateLabel(context.data.name,context.data.title);
end

function GreatPainter_MainUI.OnClick(context)
	local value = GreatPainter_MainUI:GetChild("n19"):GetChild("title").text;
	GreatPainter:SetAll(tonumber(value));
end

function GreatPainter_MainUI.OnClick2(context)
	GreatPainter.AutoStart = context.sender.selected;
end

function GreatPainter_MainUI.YouCuiClick(context)
	GreatPainter.YouCui = context.sender.selected;
	if GreatPainter.YouCui == true then
		CS.XiaWorld.GameDefine.SOULCRYSTALYOU_BASE = 1;
		world:ShowMsgBox("幽粹成功率设置为：\n100%","超级符师");
	else
		CS.XiaWorld.GameDefine.SOULCRYSTALYOU_BASE = 0.9;
		world:ShowMsgBox("幽粹成功率设置为：\n游戏默认值","超级符师");
	end
end

function GreatPainter_MainUI.LingCuiClick(context)
	GreatPainter.LingCui = context.sender.selected;
	if GreatPainter.LingCui == true then
		CS.XiaWorld.GameDefine.SOULCRYSTALLING_BASE = 1;
		world:ShowMsgBox("灵粹成功率设置为：\n100%","超级符师");
	else
		CS.XiaWorld.GameDefine.SOULCRYSTALLING_BASE = 0.9;
		world:ShowMsgBox("灵粹成功率设置为：\n游戏默认值","超级符师");
	end
end
