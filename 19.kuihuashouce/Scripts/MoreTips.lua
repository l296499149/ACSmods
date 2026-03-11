local MoreTips = GameMain:GetMod("MoreTips");

function MoreTips:OnEnter()
	CS.Wnd_Help.Instance:Show();
	CS.Wnd_Help.Instance:Hide();
	CS.Wnd_Help.Instance.contentPane.m_Text.m_title.onClickLink:Set(MoreTips.onClickLink); 
end

function MoreTips.onClickLink(Context)
	local link = Context.data;
	if string.find(link,"http://") or string.find(link,"https://") then
		CS.UnityEngine.Application.OpenURL(Context.data)
	end
	if string.find(link,"tencent://") and CS.System.Diagnostics.Process.GetProcessesByName("QQ").Length then
		CS.UnityEngine.Application.OpenURL(Context.data)
	end
end
