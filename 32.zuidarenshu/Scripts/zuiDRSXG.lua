local zuiDRSXG = GameMain:GetMod("zuiDRSXG");--先注册一个新的MOD模块

function zuiDRSXG:OnEnter()
	
	CS.XiaWorld.GameDefine.SchoolMaxNpc = {36,36,72,180};
	print("门派最大人数修改为: 180 ");

	CS.XiaWorld.GameDefine.SchoolMaxDNpc = {36,36,72,180};
	print("门派最大人数修改为: 180");

end


