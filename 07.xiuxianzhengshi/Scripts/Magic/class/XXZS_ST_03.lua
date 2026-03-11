--化解执念
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("XXZS_ST_03");

function tbMagic:Init()
end

function tbMagic:TargetCheck(k, t)	
	local npc = t;
	if npc.IsPuppet or npc.IsZombie or npc.IsDeath or npc.IsLingering or npc.PropertyMgr.Practice:GetRandomObsessionMindCanLook(false) < 0 then
		return false;
	end
	return true;
end

function tbMagic:MagicEnter(IDs, IsThing)
	self.TargetID = IDs[0];
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
			local index = target.PropertyMgr.Practice:GetRandomObsessionMindCanLook();
			target.PropertyMgr.Practice:UpGradeObsessionMind(index);
			--if self.magic.sParam1 ~= nil then
				--local item = ItemRandomMachine.RandomItem(self.magic.sParam1);
				--if item ~= nil then
					--Map:DropItem(item, target.Key, true, true, true, true, 5);
				--end
			--end
			WorldLua:PlayEffect("Effect/A/Prefabs/Projectiles/Light/LightImpactNormal", target.Pos, 5);			
		end
	end	
end

function tbMagic:OnGetSaveData()
	return nil;	
end

function tbMagic:OnLoadData(tbData,IDs, IsThing)	
	self.TargetID = IDs[0]
end
