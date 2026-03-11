local NOFIRE = GameMain:GetMod("NOFIRE");
local time = 0;
local flag = 0;

function NOFIRE:OnStep(dt)
if flag == 0 then
time = time + dt;
if time >= 10  then
flag = 1;
CS.GameMain.Instance.NoBurning = true
end
end
end

