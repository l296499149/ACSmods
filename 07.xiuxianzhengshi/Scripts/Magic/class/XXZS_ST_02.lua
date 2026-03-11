--灵魂拷问
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("XXZS_ST_02");

--local CH = {XT("林轩君"),XT("木偶君"),XT("九天雷神之太上老君"),XT("符仙君运鸿"),XT("雷震天蓬元帅"),XT("太易道尊"),XT("玄元仙君"),XT("百魔万妖之祖"),XT("原初及终焉之鸩")}

function tbMagic:Init()
end

function tbMagic:TargetCheck(k, t)
	local npc = t;
	if npc.IsPuppet or npc.IsZombie or npc.Camp == g_emFightCamp.Enemy then
		return false;
	end
	if npc.Camp == g_emFightCamp.Player or npc.Camp == g_emFightCamp.None or npc.Camp == g_emFightCamp.Friend then
		return true;
	end
	return false;
end

function tbMagic:MagicEnter(IDs, IsThing)
	self.TargetID = IDs[0];
	local target = ThingMgr:FindThingByID(self.TargetID)
	if target ~= nil then
		WorldLua:LingHunKaowen(target, self.bind);
	end
end

function tbMagic:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束
	self:SetProgress(duration/self.magic.Param1);
	if duration >= self.magic.Param1 then
		return 1;
	end
	return 0;
end

function tbMagic:MagicLeave(success)
	if success == true then
		local Q = world:RandomInt(1,6)
		local W = world:RandomInt(6,30)
		local E = world:RandomInt(30,44)
		local YY = world:RandomInt(1,8)
			if YY == 1 then
			world:UnLockJianghuClue(Q);
			elseif YY == 3 then
			world:UnLockJianghuSecret(W);
			elseif YY == 5 then
			world:UnLockJianghuSecret(E);
			else
			GameMain:GetMod("XXZS_RQ"):func(3);;
		end
	end
end

function tbMagic:OnGetSaveData()
	return nil;
end

function tbMagic:OnLoadData(tbData,IDs, IsThing)
	self.TargetID = IDs[0]
end
