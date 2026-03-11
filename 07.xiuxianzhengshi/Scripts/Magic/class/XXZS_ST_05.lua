--伏羲卦术
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("XXZS_ST_05");

local MIWENA = {90001,900015}--上古道统
local MIWENB = {99011,99016}--江湖秘闻
local MIWENC = {99021,99026}--残卷异界
--local MIWEND = {99901,99906}--追杀
local MIWENE = {53,76}--系统秘闻
local MIWENF = {1,24}--系统天气

function tbMagic:Init()
end

function tbMagic:TargetCheck(k, t)
	return true;
end

function tbMagic:MagicEnter(IDs, IsThing)
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
		local LuaHelper = self.bind.LuaHelper;
		local SW = LuaHelper:GetSchoolScore(0);
		local TS = world:DayCount();
		local MS = world:DaySecond();
		local NL = LuaHelper:GetAge();
		local SJ = LuaHelper:RandomInt(1,11);
		local rate = (TS + NL) / (SW + 10 * (1 + MS));
		if world:CheckRate(rate) then
			if SJ == 1 or SJ == 2 then
				GameEventMgr:TriggerEvent(world:RandomInt(MIWENA[1],MIWENA[2]));
			elseif SJ == 3 then
				GameEventMgr:TriggerEvent(world:RandomInt(MIWENB[1],MIWENB[2]));
			elseif SJ == 5 then
				GameEventMgr:TriggerEvent(world:RandomInt(MIWENC[1],MIWENC[2]));
			elseif SJ == 7 or SJ == 8 or SJ == 9 then
				GameEventMgr:TriggerEvent(world:RandomInt(MIWENF[1],MIWENF[2]));
			--elseif SJ > 7 then
			else
				GameEventMgr:TriggerEvent(world:RandomInt(MIWENE[1],MIWENE[2]));
			end
			world:ShowStoryBox(XT("伏羲卦术施展成功，获得一条秘闻。"), XT("伏羲卦术"));
		else
			world:ShowStoryBox(XT("伏羲卦术施展失败。"), XT("伏羲卦术"));
		end
	end
end

function tbMagic:OnGetSaveData()
	return nil;	
end

function tbMagic:OnLoadData(tbData,IDs, IsThing)	

end
