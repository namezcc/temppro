require "class"
persent = require "persent"
require "time"
require "vmath"
multiLevelEv = require "multiLevelEv"
require "scene"
require "define"
require "AttrComp"
require "Object"
require "common"
require "effect"
require "trigger"
require "control"
require "listen"
require "CombinObject"
require "Create"
require "check"
require "commonfunc"
require "param"
require "select"
require "FuncComp"

require "struct"
require "comstruct"
require "AttrTable"

--------------------------------------------------
---[[
local MainScene = Scene.new()

local obj1 = CreateObjectByStructId(STRUCT_ID.TEST_PLY,CAMP_TYPE.CMP_RED)
local obj2 = CreateObjectByStructId(STRUCT_ID.TEST_PLY,CAMP_TYPE.CMP_BLUE)

MainScene:addEntity(obj1)
MainScene:addEntity(obj2)

obj1:SetLevel(1)
obj1:setAttr(OBJ_ATTR.HP,obj1:getAttr(OBJ_ATTR.MAX_HP))
obj1:setAttr(OBJ_ATTR.MP,obj1:getAttr(OBJ_ATTR.MAX_MP))
obj1:setAttr(OBJ_ATTR.OAT_POS_X,0)
obj1:setAttr(OBJ_ATTR.OAT_POS_Y,0)

obj2:SetLevel(1)
obj2:setAttr(OBJ_ATTR.HP,obj2:getAttr(OBJ_ATTR.MAX_HP))
obj2:setAttr(OBJ_ATTR.OAT_POS_X,200)
obj2:setAttr(OBJ_ATTR.OAT_POS_Y,200)

local psSkill = CreateObjectByStructId(STRUCT_ID.SKILL_PS_ANNI,CAMP_TYPE.CMP_RED)
psSkill:SetLevel(1)

local skill1 = CreateObjectByStructId(STRUCT_ID.SKILL_ANNI_GEN_1,CAMP_TYPE.CMP_RED)
skill1:SetLevel(1)

local skill2 = CreateObjectByStructId(STRUCT_ID.SKILL_ANNI_GEN_2,CAMP_TYPE.CMP_RED)
skill2:SetLevel(1)

local skill3 = CreateObjectByStructId(STRUCT_ID.SKILL_ANNI_GEN_3,CAMP_TYPE.CMP_RED)
skill3:SetLevel(1)

local skill4 = CreateObjectByStructId(STRUCT_ID.LJ_SKILL_GEN_1,CAMP_TYPE.CMP_RED)
skill4:SetLevel(1)

local skill_ms_1 = CreateObjectByStructId(STRUCT_ID.MS_SKILL_GEN_1,CAMP_TYPE.CMP_RED)
skill_ms_1:SetLevel(1)

local pam = ParamObject.new()
pam:setParam(PAM_ATTR.OBJ_EFF_MAKER,obj1)
skill4:doEvent({OBJ_EVENT.DO_INPUT_PARAM},pam)

MainScene:addEntity(psSkill)
MainScene:addEntity(skill1)
MainScene:addEntity(skill2)
MainScene:addEntity(skill3)
MainScene:addEntity(skill4)
MainScene:addEntity(skill_ms_1)

psSkill:appendTo(obj1)

local function UseSkill1()
    -- if obj2:IsDead() then
    --     print("obj2 dead")
    --     return true
    -- end
    local pam = ParamObject.new()
    pam:setParam(PAM_ATTR.OBJ_EFF_MAKER,obj1)
    pam:setParam(PAM_ATTR.OBJ_EFF_TAKER,obj2)
    skill1:doEvent({OBJ_EVENT.DO_CONTROL},pam)

    --obj1.AttrComp:showAttrs()
    --obj2.AttrComp:showAttrs()
    print("------------------------------------")
end

local function UseSkill2(dirx,diry)
    local pam = ParamObject.new()
    pam:setParam(OBJ_ATTR.OAT_DIR_X,dirx)
    pam:setParam(OBJ_ATTR.OAT_DIR_Y,diry)
    pam:setParam(PAM_ATTR.OBJ_EFF_MAKER,obj1)
    skill2:doEvent({OBJ_EVENT.DO_CONTROL},pam)
    print("-------------------------------------")
end

local function UseSkill3()
    local pam = ParamObject.new()
    pam:setParam(PAM_ATTR.OBJ_EFF_MAKER,obj1)
    skill3:doEvent({OBJ_EVENT.DO_CONTROL},pam)
    print("-------------------------------------")
end

local function UseSkill4()
    local pam = ParamObject.new()
    pam:setParam(PAM_ATTR.OBJ_EFF_MAKER,obj1)
    skill4:doEvent({OBJ_EVENT.DO_CONTROL},pam)
    print("-------------------------------------")
end

local function UseSkill_MS_1(dirx,diry)
    local pam = ParamObject.new()
    pam:setParam(PAM_ATTR.OBJ_EFF_MAKER,obj1)
    pam:setParam(OBJ_ATTR.OAT_DIR_X,dirx)
    pam:setParam(OBJ_ATTR.OAT_DIR_Y,diry)
    skill_ms_1:doEvent({OBJ_EVENT.DO_CONTROL},pam)
end

for i=1,500 do
    if i == 10 then
        UseSkill_MS_1(1,1)
    elseif i == 70 then
        UseSkill_MS_1(1,1)
    elseif i == 130 then
        UseSkill_MS_1(1,1)
    end
    local ms = Time.GetMillionSecond()
    MainScene:update(ms)
    Time.SleepMS(16)
end

obj1.AttrComp:showAttrs()
obj2.AttrComp:showAttrs()
--psSkill.AttrComp:showAttrs()
for i=1,5 do
    local ms = Time.GetMillionSecond()
    MainScene:update(ms)
    Time.SleepMS(16)
end
-- obj1.AttrComp:showAttrs()
-- obj2.AttrComp:showAttrs()
-- print("------------------------------------")
-- skill:LevelUp()
-- obj2:LevelUp()
-- print("------------------------------------")
-- pam:setParam(PAM_ATTR.OBJ_EFF_MAKER,obj1)
-- pam:setParam(PAM_ATTR.OBJ_EFF_TAKER,obj2)
-- skill:doEvent({OBJ_EVENT.DO_CONTROL},pam)
-- pam:clear()
-- obj1.AttrComp:showAttrs()
-- obj2.AttrComp:showAttrs()
-- print("------------------------------------")
-- pam:setParam(PAM_ATTR.OBJ_EFF_MAKER,obj1)
-- pam:setParam(PAM_ATTR.OBJ_EFF_TAKER,obj2)
-- skill:doEvent({OBJ_EVENT.DO_CONTROL},pam)
-- pam:clear()
-- obj1.AttrComp:showAttrs()
-- obj2.AttrComp:showAttrs()
--]]

--print(collectgarbage("collect"))
--print(collectgarbage("count"))