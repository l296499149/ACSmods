print("this is MapExploreMod")
local MapExploreMod = GameMain:GetMod("MapExplore")

function MapExploreMod:OnInit()
	print("MapExploreMod:OnInit")
	self.tbSaveData = self.tbSaveData or {}
	self.tbSaveData.tbExploreSetting = self.tbSaveData.tbExploreSetting or {}
end

function MapExploreMod:OnSetHotKey()
	local tbHotKeys = {
		{ ID = "MapExplore_Open", Name = "打开世界地图", Type = "地图探索", InitialKey1 = "LeftControl + M", InitialKey2 = "LeftControl + A" },
	}
	return tbHotKeys
end

function MapExploreMod:OnHotKey(ID, State)
	local MainWindow = self:GetMainWindow()
	if ID == "MapExplore_Open" and State == "down" then
		if MainWindow.window.isShowing then
			MainWindow:Hide()
		else
			MainWindow:Show()
		end
	end
end

function MapExploreMod:OnStep(_)
	local MainWindow = self:GetMainWindow()
	local tbExploreSetting = self:GetExploreSetting()
	local bNeedUpdateWindow = false

	for nNpcID, tbNpcSetting in pairs(tbExploreSetting) do
		local Npc = Map.Things:GetNpcByID(nNpcID)
		if Npc == nil then
			bNeedUpdateWindow = true
			tbExploreSetting[nNpcID] = nil
		elseif Npc:CheckCommandSingle("GoMapExplore", false) == nil and MainWindow:CanNpcExplore(Npc)then
			Npc:AddCommand("GoMapExplore", tbNpcSetting.strPlace, tbNpcSetting.nGoType == 1)
		end
	end

	-- 界面显示中，需要更新
	if bNeedUpdateWindow and MainWindow.window.isShowing then
		MainWindow:OnShown()
	end
end

function MapExploreMod:OnSave()
	print("MapExploreMod:OnSave")
	return self.tbSaveData
end

function MapExploreMod:OnLoad(tbSaveData)
	print("MapExploreMod:OnLoad")
	self.tbSaveData = tbSaveData or {}
	self.tbSaveData.tbExploreSetting = self.tbSaveData.tbExploreSetting or {}
end

function MapExploreMod:GetExploreSetting()
	return self.tbSaveData.tbExploreSetting
end

function MapExploreMod:GetMainWindow()
	return GameMain:GetMod("Windows"):GetWindow("MapExplore_MainWindow")
end
