local tbBulkEntry = GameMain:GetMod("BulkEntry");--先注册一个新的MOD模块
local agent = nil;
function tbBulkEntry:OnBeforeInit()
    print("BulkEntry BeforeInit");
    if agent == nil then
        local mod = CS.ModsMgr.Instance:FindMod("BookSearch","",true);
        local assembly = CS.System.Reflection.Assembly.LoadFrom(mod.Path.."\\Library\\BulkEntry.dll");
        local type = assembly:GetType("BulkEntry.Agent");
        agent = CS.System.Activator.CreateInstance(type);
        print("BulkEntry load_assembly");
    end
end

function tbBulkEntry:OnEnter()
    if agent ~= nil then
        agent:Enter();
    end
end

function tbBulkEntry:OnClick(building)
    if agent ~= nil then
        agent:OnClick(building);
    end
end