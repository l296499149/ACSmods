local BetterWindow = GameMain:GetMod("BetterWindow");--先注册一个新的MOD模块
local GreatPainter = GameMain:GetMod("GreatPainter");
GreatPainter_ConfirmUI = BetterWindow:CreateWindow("GreatPainter_ConfirmUI");
function GreatPainter_ConfirmUI:OnInit()
	self:SetTitle("快速画符设置")
	self:SetSize(300,200)
	GreatPainter_ConfirmUI.Label = self:AddLable("Fu_Name","暂无",30,55,200,25)
	GreatPainter_ConfirmUI.text = self:AddLable("text","快速画符品质：",30,85,200,25)
	GreatPainter_ConfirmUI.input = self:AddInput("input","100",120,80)
	GreatPainter_ConfirmUI.input.m_title.restrict = "[0-9]"
	GreatPainter_ConfirmUI.input.m_title.maxLength = 3;
	GreatPainter_ConfirmUI.Name = "";
	
	GreatPainter_ConfirmUI.Confirm = self:AddButton("Bnt_Confirm","确定",60,135);
	GreatPainter_ConfirmUI.Cancel = self:AddButton("Bnt_Cancel","取消",170,135);
	self:Center();
end

function GreatPainter_ConfirmUI:OnShowUpdate()
	
end

function GreatPainter_ConfirmUI:OnShown()

end

function GreatPainter_ConfirmUI:OnUpdate()

end

function GreatPainter_ConfirmUI:OnHide()

end

function GreatPainter_ConfirmUI:UpdateLabel(name,displayname)
	GreatPainter_ConfirmUI.Name = name;
	GreatPainter_ConfirmUI.Label.title = displayname;
	GreatPainter_ConfirmUI.input.m_title.text = 100;
	GreatPainter_ConfirmUI:Show();
end


-- 事件类型 "onClick","onKeyDown","onClickLink","onRightClick","onClickLink"
function GreatPainter_ConfirmUI:OnObjectEvent(t,obj,context)
	--print(t,obj,obj.name)
	if t == "onClick" then
		if obj.name == "Bnt_Confirm" then
			local value = tonumber(GreatPainter_ConfirmUI.input.m_title.text);
			print(GreatPainter_ConfirmUI.Name.."  -  "..value);
			GreatPainter:SetOne(GreatPainter_ConfirmUI.Name,value);
			GreatPainter_ConfirmUI:Hide();
		end
		if obj.name == "Bnt_Cancel" then
			GreatPainter_ConfirmUI:Hide();
		end
	end
end