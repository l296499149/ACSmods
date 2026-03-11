local STACK = GameMain:GetMod("MOREMAXSTACK");

function STACK:OnBeforeInit()

local b,data = CS.XiaWorld.ThingMgr.Instance.m_mapThingDefs:TryGetValue(2);

	for k, v in pairs(data) do
		if v ~= nil then
			if v.MaxStack ~= nil then
				if v.MaxStack ~= 1 then
					v.MaxStack = 9999
				end
			end
		end 
	end

CS.XiaWorld.ThingMgr.Instance:GetDef(g_emThingType.Space,"StorageSpace").MaxStack = 9999

end

