local tbMod = GameMain:NewMod("ModLoaderLite")


function tbMod:OnBeforeInit()
  local thisData = CS.ModsMgr.Instance:FindMod("ModLoaderLite", nil, true)
  local thisPath = thisData.Path
  local mllFile = CS.System.IO.Path.Combine(thisPath, "ModLoaderLite.dll")
  local asm = CS.System.Reflection.Assembly.LoadFrom(mllFile)
  local mll = asm:GetType("ModLoaderLite.MLLMain")
  self.mll = mll
  local ldd = mll:GetMethod("LoadDep")
  ldd:Invoke()
  local init = mll:GetMethod("Init")
  init:Invoke()
end

function tbMod:OnEnter()
  local ld = self.mll:GetMethod("Load")
  ld:Invoke()
end