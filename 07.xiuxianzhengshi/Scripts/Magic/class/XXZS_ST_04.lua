--心魔化念
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("XXZS_ST_04");

function tbMagic:Init()
end

function tbMagic:TargetCheck(k, t)
	local npc = t;
	if not npc.GongKind == g_emGongKind.God then
		return false;
	end
	return true;
end

function tbMagic:MagicEnter(IDs, IsThing)
	self.TargetID = IDs[0]
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
		local target = ThingMgr:FindThingByID(self.TargetID)
		if target ~= nil then
			if target.LuaHelper:IsGodPractice() then		--判定目标功法是否为神修
				local SX = target.LuaHelper:GetProperty("GodPractice_GodPowerAddV")
				if SX < 20 then								--判定神性的区间值
					NpcMgr:CreateEliteEnemysAtSide(nil, CS.XiaWorld.g_emThingDir.None, Map, 2, 0, 11);
					GameMain:GetMod("XXZS_RQ"):func(1);
					target.LuaHelper:ModifierProperty("GodPractice_GodPowerAddV", -5);
					world:ShowStoryBox(XT("该角色的心魔很弱。"), XT("心魔化念"));
				elseif SX < 40 then
					NpcMgr:CreateEliteEnemysAtSide(nil, CS.XiaWorld.g_emThingDir.None, Map, 4, 0, 33);
					GameMain:GetMod("XXZS_RQ"):func(2);
					target.LuaHelper:ModifierProperty("GodPractice_GodPowerAddV", -10);
					world:ShowStoryBox(XT("该角色的心魔较弱。"), XT("心魔化念"));
				elseif SX < 60 then
					NpcMgr:CreateEliteEnemysAtSide(nil, CS.XiaWorld.g_emThingDir.None, Map, 6, 0, 55);
					GameMain:GetMod("XXZS_RQ"):func(3);
					target.LuaHelper:ModifierProperty("GodPractice_GodPowerAddV", -15);
					world:ShowStoryBox(XT("该角色的心魔一般。"), XT("心魔化念"));
				elseif SX < 80 then
					NpcMgr:CreateEliteEnemysAtSide(nil, CS.XiaWorld.g_emThingDir.None, Map, 8, 0, 77);
					GameMain:GetMod("XXZS_RQ"):func(4);
					target.LuaHelper:ModifierProperty("GodPractice_GodPowerAddV", -20);
					world:ShowStoryBox(XT("该角色的心魔较强。"), XT("心魔化念"));
				elseif sx <= 99999 then
					NpcMgr:CreateEliteEnemysAtSide(nil, CS.XiaWorld.g_emThingDir.None, Map, 10, 0, 99);
					GameMain:GetMod("XXZS_RQ"):func(5);
					target.LuaHelper:ModifierProperty("GodPractice_GodPowerAddV", -25);
					world:ShowStoryBox(XT("该角色的心魔很强。"), XT("心魔化念"));
				end
				--target.LuaHelper:AddNeedValue("GodPower", -1);--减少神性，Param2设置的负数，应该是可以减少的吧
				--func(1)		--召唤敌人
			end
		end
	end
end

function tbMagic:OnGetSaveData()
	return nil;
end

function tbMagic:OnLoadData(tbData,IDs, IsThing)
	self.TargetID = IDs[0]
end
