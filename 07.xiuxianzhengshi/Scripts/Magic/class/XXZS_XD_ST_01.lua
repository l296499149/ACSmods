--邪道凝珀决
--杀死角色时获取幽魂、游魂、灵魂三种珀类的物品
--角色情绪高于150获得灵魂
--角色情绪介于76~149之间获得游魂
--角色情绪低于75获得幽魂
--其余设置在xml的相关文件

--神通释放步骤
--1、创建神通类别
--2、添加变量（按需求配置）
--3、初始化神通
--4、检查神通可用性
--5、检查释放目标
--6、神通释放前的准备工作
--7、神通释放过程
--8、神通释放完成，并提供效果

--创建神通类别
local tbTable = GameMain:GetMod("MagicHelper");--获取神通模块 这里不要动
local tbMagic = tbTable:GetMagic("XXZS_XD_ST_01");--创建一个新的神通class

--注意
--神通脚本运行的时候有两个固定变量
--self.bind 执行神通的npcObj
--self.magic 当前神通的数据，也就是定义在xml里的数据

--初始化神通
function tbMagic:Init()
end

--检查目标是否符合要求
function tbMagic:TargetCheck(k, t)
	local npc = t;
	if npc.IsPuppet or npc.IsZombie or not npc:CanResurrection() or npc.IsBoss then ----目标为傀儡或僵尸或不能被复活的目标，则无法释放神通
		return false;
	end
	if (npc.IsDeath or npc.IsLingering) and npc:HasSpecialFlag(g_emNpcSpecailFlag.FLAG_DROPSOULCRYSTAL) == false then ----目标为死亡或者濒死，则释放神通，敌人代码（npc.Camp == g_emFightCamp.Enemy）
		return true;
	end
	return false;
end

--开始施展神通
--IDs是一个List<int> 如果目标是非对象，里面的值就是地点key，如果目标是物体，值就是对象ID，否则为nil
--IsThing 目标类型是否为物体
function tbMagic:MagicEnter(IDs, IsThing)
	self.TargetID = IDs[0];
end

--神通施展过程中，需要返回值
--返回值  0继续 1成功并结束 -1失败并结束
--这里表示神通瞬发，成功立即结束
function tbMagic:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束
	self:SetProgress(duration/self.magic.Param1);
	local target = ThingMgr:FindThingByID(self.TargetID)
	self.bind:PlayAnimation("dazuo",true , 1)
	if duration >= self.magic.Param1 then
		return 1;
	end
	return 0;
end

--施展完成/失败 success是否成功，成功接效果，失败不用管
function tbMagic:MagicLeave(success)
	if success == true then
		local target = ThingMgr:FindThingByID(self.TargetID); --使用TargetID来获取目标实体。TargetID需要在MagicEnter的时候赋值。必须是self.xxxx格式
		if target ~= nil then
			target:SetSpecialFlag(g_emNpcSpecailFlag.FLAG_DROPSOULCRYSTAL, 1)
			if target.LuaHelper:GetMood() <= 75 then
				target.LuaHelper:DropAwardItem("XXZS_XD_1",9); --给与目标一个幽魂（提升品阶）
			elseif target.LuaHelper:GetMood() <= 150 then
				target.LuaHelper:DropAwardItem("XXZS_XD_2",9); --给与目标一个游魂（作为符纸材料，作为丹药材料）
			elseif target.LuaHelper:GetMood() <= 99999 then
				target.LuaHelper:DropAwardItem("XXZS_XD_3",9); --给与目标一个灵魂（提升品质）
			end
			WorldLua:PlayEffect("Effect/B/Prefabs/Glowing orbs(10)/Glowing Alarmbell", target.Pos, 5);--特效显示
		end
	end
end

--保存神通数据
function tbMagic:OnGetSaveData()
	return nil;
end

--读取神通数据
function tbMagic:OnLoadData(tbData,IDs, IsThing)
	self.TargetID = IDs[0];
end
























