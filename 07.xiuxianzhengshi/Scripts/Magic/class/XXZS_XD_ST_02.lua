--邪道幽萃
--使用神通提升物品品阶，并消耗一个幽魂
--设置失败公式（获取心情、心境的比值）
--设置加成强度（品阶+1）
--其余设置在xml的相关文件（参数添加消耗物品）

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
local tbMagic = tbTable:GetMagic("XXZS_XD_ST_02");--创建一个新的神通class

--注意
--神通脚本运行的时候有两个固定变量
--self.bind 执行神通的npcObj
--self.magic 当前神通的数据，也就是定义在xml里的数据

--初始化神通
function tbMagic:Init()
end

--检查目标是否符合要求
function tbMagic:TargetCheck(k, t)
	local Item = t;
	if Item.Rate >= 12 then
		return false;
	end
	if Item.FreeCount >= 1 then
		return true;
	end
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
	if duration >= self.magic.Param1 then
		return 1;
	end
	return 0;
end

--施展完成/失败 success是否成功，成功接效果，失败不用管
function tbMagic:MagicLeave(success)
	local target = ThingMgr:FindThingByID(self.TargetID)
	if success and target then
		target:SoulCrystalYouPowerUp(0,0.75,1)
		WorldLua:PlayEffect("Effect/System/TeacherEnter", target.Pos, 5);--特效显示
	end
end


--保存神通数据
function tbMagic:OnGetSaveData()
	return nil;
end

--读取神通数据
function tbMagic:OnLoadData(tbData,IDs, IsThing)
	self.TargetID = IDs[0]
end
























