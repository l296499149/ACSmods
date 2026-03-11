print("this is MapExplore_MainWindow")
local WindowMod = GameMain:GetMod("Windows")
local MapExplore_MainWindow = WindowMod:CreateWindow("MapExplore_MainWindow")

function MapExplore_MainWindow:OnInit()
	self.window.contentPane = UIPackage.CreateObject("MapExplore", "Main")
	self.window.closeButton = self:GetChild("frame"):GetChild("n5")
	self:GetChild("frame"):GetChild("title").text = "地图历练"
	self.NpcList = MapExplore_MainWindow:GetChild("NpcList")
end

function MapExplore_MainWindow:OnShown()
	local tbPlace = {}
	local tbPlaceDisplayName = {}

	for strPlace, PlaceData in pairs(PlacesMgr.Places) do
		if PlaceData.UnLock then
			local PlaceDef = PlacesMgr:GetPlaceDef(strPlace)
			if PlaceDef ~= nil and PlaceDef.DisplayName ~= nil and PlaceDef.DisplayName ~= "失落之地(模组丢失)" then
				table.insert(tbPlace, strPlace)
				table.insert(tbPlaceDisplayName, PlaceDef.DisplayName)
			end
		end
	end

	self.NpcList:RemoveChildrenToPool()

	local listAllNpc = Map.Things:GetPlayerActiveNpcs(g_emNpcRaceType.Wisdom)
	for _, Npc in pairs(listAllNpc) do
		if self:IsValidNpc(Npc) then
			local Item = self.NpcList:AddItemFromPool()
			Item.data = Npc.ID

			local NameLabel = Item:GetChild("Name")
			NameLabel.text = Npc.Name

			local PlaceComboBox = Item:GetChild("Place")
			PlaceComboBox.items = tbPlaceDisplayName
			PlaceComboBox.values = tbPlace

			local GoBtn = Item:GetChild("Go")
			GoBtn.data = 0
			GoBtn.onClick:Add(self.OnGoOrStayBtnClick)

			local StayBtn = Item:GetChild("Stay")
			StayBtn.data = 1
			StayBtn.onClick:Add(self.OnGoOrStayBtnClick)

			local CancelBtn = Item:GetChild("Cancel")
			CancelBtn.onClick:Add(self.OnCancelClick)

			local CallBackBtn = Item:GetChild("CallBack")
			CallBackBtn.onClick:Add(self.OnCallBackClick)

			self:UpdateNpcItem(Item)
		end
	end

	self.window:Center()
end

function MapExplore_MainWindow:OnUpdate(_)
	local bUpdateSucc = true
	local ItemArray = self.NpcList:GetChildren()
	for i = 0, ItemArray.Length - 1 do
		if not self:UpdateNpcItem(ItemArray[i]) then
			bUpdateSucc = false
			break
		end
	end
	if not bUpdateSucc then
		self:OnShown()
	end
end

-- 更新Item状态
function MapExplore_MainWindow:UpdateNpcItem(Item)
	local Npc = Map.Things:GetNpcByID(Item.data)
	if Npc == nil then
		return false
	end

	local CommonText = Item:GetChild("Text")
	CommonText.text = "未初始数据"

	local GoBtn = Item:GetChild("Go")
	GoBtn.enabled = false

	local StayBtn = Item:GetChild("Stay")
	StayBtn.enabled = false

	local CancelBtn = Item:GetChild("Cancel")
	CancelBtn.visible = false
	CancelBtn.enabled = false

	local CallBackBtn = Item:GetChild("CallBack")
	CallBackBtn.visible = true
	CallBackBtn.enabled = false

	-- 等待出发->起飞离家->前往目的->目的地停留120秒->回家->放下收获
	local bExploring = Npc:HasSpecialFlag(g_emNpcSpecailFlag.MapExploring)
	local bHasCmd = Npc:CheckCommandSingle("GoMapExplore", false) ~= nil

	-- 有命令时可以执行"取消历练"操作
	if bHasCmd then
		CancelBtn.visible = true
		CancelBtn.enabled = true
		CallBackBtn.visible = false
	end

	-- Npc是否可以外出历练
	local bCanExplore, strFailMsg = self:CanNpcExplore(Npc)
	if bCanExplore then
		GoBtn.enabled = true
		StayBtn.enabled = true
		local tbExploreSetting = self:GetExploreSetting()
		local tbNpcSetting = tbExploreSetting[Npc.ID]
		if tbNpcSetting ~= nil then
			-- 使当时选择中的按钮变灰，但是依旧可点击
			if tbNpcSetting.nGoType == 0 then
				GoBtn.grayed = true
			elseif tbNpcSetting.nGoType == 1 then
				StayBtn.grayed = true
			end
			-- 使地点下拉框选中当前地点
			local PlaceComboBox = Item:GetChild("Place")
			for i = 0, PlaceComboBox.values.Length - 1 do
				if tbNpcSetting.strPlace == PlaceComboBox.values[i] then
					PlaceComboBox.selectedIndex = i
					break
				end
			end
		end
	end

	-- 不在历练中
	if not bExploring then
		-- 已经发出指令
		if bHasCmd then
			CommonText.text = "等待出发"
			return true
		end

		-- 无法历练
		if not bCanExplore then
			CommonText.text = strFailMsg
			return true
		end

		-- 无安排，可历练，显示历练耗时
		local strPlace = Item:GetChild("Place").value
		local PlaceDef = PlacesMgr:GetPlaceDef(strPlace)
		local fSingleCost = PlacesMgr:GetCost(Npc, PlaceDef.Name)
		CommonText.text = string.format("无历练安排, 前往[color=#008080]%s[/color]需要[color=#804040]%.2f[/color]天", PlaceDef.DisplayName, (fSingleCost * 2 + 120) / 600)
		return true
	end

	-- 有历练命令，可以取消历练
	if bHasCmd then
		CommonText.text = "正在御剑离开"
		return true
	end

	-- 没有MapExploreData，已经回到家了
	local MapExploreData = self:GetNpcMapExploreData(Npc.ID)
	if MapExploreData == nil then
		CommonText.text = "历练归来, 放下收获"
		return true
	end

	-- 只有出发和停留才可以使用"召回"操作
	if MapExploreData.Stage ~= 2 then
		CallBackBtn.enabled = true
	end

	-- 出发，停留，返回 三个阶段
	local PlaceDef = PlacesMgr:GetPlaceDef(MapExploreData.Place)
	if MapExploreData.Stage == 0 then
		CommonText.text = string.format("前往[color=#008080]%s[/color], [color=#804040]%s[/color]后抵达", PlaceDef.DisplayName, self:GameTime2Str(MapExploreData.NeedTime - MapExploreData.StageP))
		return true
	end

	if MapExploreData.Stage == 1 then
		if MapExploreData.IsStay then
			CommonText.text = string.format("在[color=#008080]%s[/color]驻扎中, [color=#804040]%s[/color]后触发事件", PlaceDef.DisplayName, self:GameTime2Str(MapExploreData.Story))
		else
			CommonText.text = string.format("已经抵达[color=#008080]%s[/color], [color=#804040]%s[/color]后触发事件", PlaceDef.DisplayName, self:GameTime2Str(120 - MapExploreData.StageP))
		end
		return true
	end

	if MapExploreData.Stage == 2 then
		CommonText.text = string.format("从[color=#008080]%s[/color]的返回途中, [color=#804040]%s[/color]后抵达", PlaceDef.DisplayName, self:GameTime2Str(MapExploreData.NeedTime - MapExploreData.StageP))
		return true
	end

	return false
end

-- 游戏的时间转成便于现实阅读的时间格式
function MapExplore_MainWindow:GameTime2Str(fGameTime)
	if fGameTime > 600 then
		return string.format("%.2f天", fGameTime / 600)
	end
	local fReallyTime = fGameTime / 600 * 24 * 3600
	local nHour = math.modf(fReallyTime / 3600)
	local nMin = math.modf(fReallyTime % 3600 / 60)
	return string.format("%02d:%02d", nHour, nMin)
end

-- 获取Npc探索的数据
function MapExplore_MainWindow:GetNpcMapExploreData(nNpcID)
	for _, MapExploreData in pairs(PlacesMgr.MapExplors) do
		if MapExploreData.NpcID == nNpcID then
			return MapExploreData
		end
	end
	return nil
end

-- 是否有效Npc
function MapExplore_MainWindow:IsValidNpc(Npc)
	if not Npc.IsValid then
		return false
	end
	if Npc.IsGod then
		return false
	end
	if Npc.IsDeath then
		return false
	end
	if Npc.IsPuppet then
		return false
	end
	if Npc.IsZombie then
		return false
	end
	if Npc.IsVistor then
		return false
	end
	if Npc.Rank ~= g_emNpcRank.Disciple then
		return false
	end
	return true
end

-- Npc是否可以外出历练
function MapExplore_MainWindow:CanNpcExplore(Npc)
	if Map.Things:OnlyBossExist() then
		return false, "门派存亡之际不宜外出。"
	end
	if Npc.PropertyMgr.Practice.TouchNeck and Npc.PropertyMgr.Practice.CurNeck ~= nil and Npc.PropertyMgr.Practice.CurNeck.NeckCountdown > 0 and not Npc:HasSpecialFlag(g_emNpcSpecailFlag.FLAG_PRACTICEDIE) then
		return false, "瓶颈即将松动，暂时不宜外出历练。"
	end
	if Npc:HasSpecialFlag(g_emNpcSpecailFlag.FLAG_CANTEXPLORESTAY) then
		return false, "正在静修中，不能外出历练。"
	end
	return true, "可以外出历练"
end

-- 获取历练配置
function MapExplore_MainWindow:GetExploreSetting()
	local MapExploreMod = GameMain:GetMod("MapExplore")
	return MapExploreMod:GetExploreSetting()
end

function MapExplore_MainWindow.OnGoOrStayBtnClick(Event)
	local Item = Event.sender.parent
	local nNpcID = Item.data
	local strPlace = Item:GetChild("Place").value
	local nGoType = Event.sender.data
	local tbExploreSetting = MapExplore_MainWindow:GetExploreSetting()
	local tbNpcSetting = tbExploreSetting[nNpcID]

	-- 首次点击
	if tbExploreSetting[nNpcID] == nil then
		tbNpcSetting = {}
		tbNpcSetting.strPlace = strPlace
		tbNpcSetting.nGoType = nGoType
		tbExploreSetting[nNpcID] = tbNpcSetting
		return
	end

	-- 如果有历练命令顺便取消
	local Npc = Map.Things:GetNpcByID(nNpcID)
	if Npc:CheckCommandSingle("GoMapExplore", false) ~= nil then
		Npc:RemoveCommand("GoMapExplore", false)
	end

	-- 点了另外一个按钮
	if tbNpcSetting.nGoType ~= nGoType then
		tbNpcSetting.strPlace = strPlace
		tbNpcSetting.nGoType = nGoType
	else
		tbExploreSetting[nNpcID] = nil
	end
end

function MapExplore_MainWindow.OnCallBackClick(Event)
	local nNpcID = Event.sender.parent.data
	local MapExploreData = MapExplore_MainWindow:GetNpcMapExploreData(nNpcID)
	PlacesMgr:CallBackNpc(MapExploreData)
end

function MapExplore_MainWindow.OnCancelClick(Event)
	local nNpcID = Event.sender.parent.data
	local Npc = Map.Things:GetNpcByID(nNpcID)
	local tbExploreSetting = MapExplore_MainWindow:GetExploreSetting()
	Npc:RemoveCommand("GoMapExplore", false)
	tbExploreSetting[nNpcID] = nil
end
