require "createtable"

function CreateEffect(eid)
    if eid == EFFECT_TYPE.EFT_RealDmg then
        return RealDmgEff.new()
    elseif eid == EFFECT_TYPE.EFT_ObjectGen then
        return ObjectGenEff.new()
    elseif eid == EFFECT_TYPE.EFT_AppendBuff then
        return AppendEff.new()
    elseif eid == EFFECT_TYPE.EFT_AddBuffLevel then
        return AddBuffLevel.new()
    elseif eid == EFFECT_TYPE.EFT_CheckLevel then
        return CheckEff.new()
    elseif eid == EFFECT_TYPE.EFT_AttrEff then
        return AttrEff.new()
    elseif eid == EFFECT_TYPE.EFT_EventEff then
        return EventEff.new()
    elseif eid == EFFECT_TYPE.EFT_CostEff then
        return CostEff.new()
    elseif eid == EFFECT_TYPE.EFT_RecoverEff then
        return RecoverEff.new()
    elseif eid == EFFECT_TYPE.EFT_CheckDiePassEff then
        return CheckDiePassEff.new()
    end
end

function CreateTrigger(cfg)
    local trig = nil
    if cfg.bigtype == COMP_TYPE.TRIGGER_AND_DESTROY_SELF then
        trig = TriggerAndDestroySelf.new(cfg.id,cfg.type)
    else
        trig = TriggerObject.new(cfg.id,cfg.type)
    end
     
    for i,group in ipairs(cfg.group) do
        local grp = {}
        for k,eid in ipairs(group) do
            local eff = CreateEffect(eid)
            table.insert(grp,eff)
        end
        trig:addEffGroup(grp)
    end
    return trig
end

function CreateControl(cfg)
    if cfg.type == CONTROL_TYPE.CTL_CD then
        return CDControl.new(cfg,cfg.id,cfg.type)
    elseif cfg.type == CONTROL_TYPE.CTL_SWITCH then
        return SwitchControl.new(cfg,cfg.id,cfg.type)
    elseif cfg.type == CONTROL_TYPE.CTL_GROUP then
        return ControlGroup.new(cfg,cfg.id,cfg.type)
    elseif cfg.type == CONTROL_TYPE.CTL_SUB then
        return ControlSub.new(cfg,cfg.id,cfg.type)
    end
end

function CreateListen(cfg)
    return ListenObject.new(cfg,cfg.id,cfg.bigtype)
end

function CreateFollowDestroy(cfg)
    return FollowDestroy.new(cfg.id,cfg.bigtype)
end

function CreateEventDestroy(cfg)
    return EventDestroy.new(cfg,cfg.id,cfg.bigtype)
end

function CreateComp(cfg)
    return CreateCompTable[cfg.bigtype](cfg)
end

function CreateObject(struct,id,sid)
    local obj = nil
    if struct.type == OBJ_TYPE.HERO then
        obj = ObjHero.new(id,struct.type)
    elseif struct.type == OBJ_TYPE.SKILL then
        obj = ObjSkill.new(id,struct.type)
    elseif struct.type == OBJ_TYPE.BUFF then
        obj = ObjBuff.new(id,struct.type)
    end
    assert(obj,"error obj type:"..(struct.type or "nil"))
    if struct.comps then
        for i,v in ipairs(struct.comps) do
            local comp = CreateComp(v)
            obj:addObject(comp)
        end
    end
    obj:setAttr(COMM_ATTR.CAT_ATTR_CFG_ID,sid)
    obj:setAttr(COMM_ATTR.CAT_STRUCT_ID,sid)
    obj:afterCreate()
    print("create type:"..obj.type.." id:"..obj.id.." struct:"..sid.." --- "..Time.GetMillionSecond())
    return obj
end

function CreateObjectByStructId(sid,camp,id)
    id = id or GenTmpObjectID()
    local obj = CreateObject(ObjectStruct[sid],id,sid)
    obj:setAttr(OBJ_ATTR.OAT_CAMP,camp)
    return obj
end

local TMP_OBJECT_ID_BEG = 100000000
local TMP_OBJECT_ID = TMP_OBJECT_ID_BEG
local TMP_OBJECT_ID_MAX = 0xFFFFFFFF
function GenTmpObjectID()
    TMP_OBJECT_ID = TMP_OBJECT_ID + 1
    if TMP_OBJECT_ID == TMP_OBJECT_ID_MAX then
        TMP_OBJECT_ID = TMP_OBJECT_ID_BEG
    end
    return TMP_OBJECT_ID
end

local STACT_OBJECT_ID = 1
function GenStaticObjectID()
    STACT_OBJECT_ID = STACT_OBJECT_ID + 1
    return STACT_OBJECT_ID
end