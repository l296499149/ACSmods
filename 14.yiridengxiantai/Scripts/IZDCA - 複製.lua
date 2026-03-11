local JD = GameMain:GetMod("IZDCA");--先注册一个新的MOD模块

function JD:Hension()
local Npc = me.npcObj
if  Npc.MaxLing >= 1 then
local Practice = Npc.PropertyMgr.Practice
local Time = Npc.MaxLing/Practice:BaseAbsorbEffectGold()
local Value = Practice:GoldEffectSpeed(Npc.Key)
Practice:MakeGold(Time * Value)
Npc:AddLing(-Npc.MaxLing)

world:ShowStoryBox("恭喜"..Npc.Name.."修為更上一層樓。","修為精進",{"知道了"},
function(key)
if key == 0 then
Npc.LuaHelper:AddMsg(""..Npc.Name.."获得了")
end
end
)

end

end

