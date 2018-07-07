CombinObject = class("CombinObject",Object)

function CombinObject:ctor( ... )
    CombinObject.super.ctor(self,...)
    self.objects = {}
    self.child = {}
    self.parent = {}
end

function CombinObject:afterCreate()
end

function CombinObject:addObject(obj)
    self.objects[obj.id] = obj
    obj:onAddtoComp(self)
end

function CombinObject:getObject(id)
    return self.objects[id]
end

function CombinObject:removeObj(id)
    self.objects[id] = nil
end

function CombinObject:updateAttr(cfg)
    if cfg.attr then
        CombinObject.super.updateAttr(self,cfg.attr)
    end
    if cfg.comps then
        for i,v in ipairs(cfg.comps) do
            local comp = self:getObject(v.id)
            if comp then
                comp:updateAttr(v.attr)
            end
        end
    end

    for k,obj in pairs(self.objects) do
        obj:afterUpdateAttr()
    end
end

function CombinObject:update(stamp)
    for k,comp in pairs(self.objects) do
        comp:update(stamp)
    end
end

function CombinObject:destroy()
    local sid = self:getAttr(COMM_ATTR.CAT_STRUCT_ID)
    print("destroy type:"..self.type.." id:"..self.id.." struct:"..sid.." --- "..Time.GetMillionSecond())
    self:doEvent({COMM_EVENT.BEFOR_DESTROY})
    CombinObject.super.destroy(self)
    for k,comp in pairs(self.objects) do
        comp:destroy()
    end
    for k,v in pairs(self.parent) do
        v.child[self.id] = nil
    end
    for k,v in pairs(self.child) do
        v.parent[self.id] = nil
    end
    self.parent = nil
    self.child = nil
end

function CombinObject:appendTo(comobj)
    comobj.child[self.id] = self
    self.parent[comobj.id] = comobj
    local pam = ParamObject.new()
    pam:setParam(PAM_ATTR.OBJ_EFF_TAKER,comobj)
    self:doEvent({OBJ_EVENT.DO_APPEND_TO_OBJ},pam)
end

function CombinObject:SetLevel(level)
    self:setAttr(COMM_ATTR.CAT_LEVEL,level)
    local attrCfg = self:getAttr(COMM_ATTR.CAT_ATTR_CFG_ID)
    local atttab = AttrTable[attrCfg]
    assert(atttab,"nil attr_cfg_id:"..(attrCfg or "nil"))
    self:updateAttr(atttab[level])
end

function CombinObject:IsDead()
    return false
end

ObjMaster = class("ObjMaster",CombinObject)
function ObjMaster:SkillUp(index)
    


end

local HERO_ATTR_CHANGE_FUNC = {}
local HAF = HERO_ATTR_CHANGE_FUNC

HAF[OBJ_ATTR.HP] = function(obj,oldval,newval)
    if newval <= 0 then
        obj:setAttr(OBJ_ATTR.HP,0)
        obj:doEvent({OBJ_EVENT.DO_OBJECT_DEAD})
    end
end

ObjHero = class("ObjHero",CombinObject)
function ObjHero:attrChangeEvent(aid,oldval,newval)
    local func = HAF[aid]
    if func then
        func(self,oldval,newval) 
    end
end

function ObjHero:IsDead()
    if self:getAttr(OBJ_ATTR.HP) <= 0 then
        return true
    end
end

function ObjHero:LevelUp()
    local lv = self:getAttr(COMM_ATTR.CAT_LEVEL)
    self:SetLevel(lv+1)
end

function ObjHero:findSameBuff(buff)
    local sid = buff:getAttr(COMM_ATTR.CAT_STRUCT_ID)
    for k,v in pairs(self.child) do
        local osid = v:getAttr(COMM_ATTR.CAT_STRUCT_ID)
        if osid == sid then
            if v:getAttr(COMM_ATTR.CAT_DESTROY) ~= true then
                return v
            end
        end
    end
end

ObjSkill = class("ObjSkill",CombinObject)
function ObjSkill:LevelUp()
    local lv = self:getAttr(COMM_ATTR.CAT_LEVEL)
    self:SetLevel(lv+1)
end

function ObjSkill:findSameBuff(buff)
    local sid = buff:getAttr(COMM_ATTR.CAT_STRUCT_ID)
    for k,v in pairs(self.child) do
        local osid = v:getAttr(COMM_ATTR.CAT_STRUCT_ID)
        if osid == sid then
            if v:getAttr(COMM_ATTR.CAT_DESTROY) ~= true then
                return v
            end
        end
    end
end

function ObjSkill:afterCreate()
    local s = COMM_STRUCT[COMM_STRUCT_ID.CS_EVENT_DESTROY_SELF]
    local comp = EventDestroy.new(s,s.id,s.bigtype)
    self:addObject(comp)
end

ObjBuff = class("ObjBuff",CombinObject)
function ObjBuff:afterCreate()
    local s = COMM_STRUCT[COMM_STRUCT_ID.CS_EVENT_DESTROY_SELF]
    local comp = EventDestroy.new(s,s.id,s.bigtype)
    self:addObject(comp)

    s = COMM_STRUCT[COMM_STRUCT_ID.CS_FOLLOW_DESTROY]
    comp = FollowDestroy.new(s,s.id,s.bigtype)
    self:addObject(comp)
end

function ObjBuff:appendTo(comobj)
    local oldbuff = comobj:findSameBuff(self)
    if oldbuff then
        if self:doEvent({OBJ_EVENT.DO_BUFF_REPEAT},oldbuff) == false then
            self:setAttr(COMM_ATTR.CAT_DESTROY,true)
            return
        end
    end
    ObjBuff.super.appendTo(self,comobj)
end

function ObjBuff:refreshSame(sameObj)
    for k,comp in pairs(self.objects) do
        comp:refreshSame(sameObj:getObject(k))
    end
end

function ObjBuff:destroy()
    if self:getAttr(COMM_ATTR.CAT_BEEN_DESTROY) then
        return
    end
    ObjBuff.super.destroy(self)
    self:setAttr(COMM_ATTR.CAT_BEEN_DESTROY,true)
end