local Effect = class("Effect",Object)

function Effect:destroy()
end

function Effect:setTrgger(t)
    self.trigger = t
end

function Effect:DoEffect(pam)
end

RealDmgEff = class("RealDmgEff",Effect)
function RealDmgEff:DoEffect(pam)
    local res = {}
    res.attrid = OBJ_ATTR.HP
    res.events = {}
    res.maker = pam:getParam(PAM_ATTR.OBJ_EFF_MAKER)
    res.taker = pam:getParam(PAM_ATTR.OBJ_EFF_TAKER)
    res.val = -self:getAttr(EFF_ATTR.VAL1)

    table.insert(res.events,{res.attrid,ATTR_CHANGE_TYPE.MINUS,self.trigger.type})
    table.insert(res.events,{res.attrid,ATTR_CHANGE_TYPE.MINUS})

    self.trigger:setRes(res)
end

ObjectGenEff = class("ObjectGenEff",Effect)
function ObjectGenEff:DoEffect(pam)
    local structid = self:getAttr(EFF_ATTR.VAL1)
    local struct = ObjectStruct[structid]
    local obj = CreateObject(struct,GenTmpObjectID(),structid)
    local attrid = self:getAttr(EFF_ATTR.VAL2)
    local attr = AttrTable[attrid]
    if attr then
        obj:updateAttr(attr[self:getAttr(EFF_ATTR.VAL3)])
    end
    pam:setParam(self:getAttr(EFF_ATTR.VAL4) or PAM_ATTR.NEW_OBJECT,obj)

    obj:setAttr(OBJ_ATTR.OAT_CAMP,self.trigger.comp:getAttr(OBJ_ATTR.OAT_CAMP))

    self.trigger.comp.scene:pushNewObject(obj)
    obj:doEvent({OBJ_EVENT.DO_EFF_GEN_SELF},pam)
end

AppendObjToMaker = class("AppendObjToMaker",Effect)
function AppendObjToMaker:DoEffect(pam)
    local maker = pam:getParam(PAM_ATTR.OBJ_EFF_MAKER)
    local obj = pam:getParam(PAM_ATTR.NEW_OBJECT)
    if maker and obj then
        obj:appendTo(maker)
    end
end

AppendObjToTaker = class("AppendObjToTaker",Effect)
function AppendObjToTaker:DoEffect(pam)
    local taker = pam:getParam(PAM_ATTR.OBJ_EFF_TAKER)
    local obj = pam:getParam(PAM_ATTR.NEW_OBJECT)
    if taker and obj then
        obj:appendTo(taker)
    end
end

AppendEff = class("AppendEff",Effect)
function AppendEff:DoEffect(pam)
    local buff = pam:getParam(self:getAttr(EFF_ATTR.VAL1))
    local obj = pam:getParam(self:getAttr(EFF_ATTR.VAL2))
    if buff and obj then
        buff:appendTo(obj)
    end
end

AddBuffLevel = class("AddBuffLevel",Effect)
function AddBuffLevel:DoEffect(pam)
    local skill = self.trigger.comp
    local buff = self.trigger.comp
    local lv = buff:getAttr(BUFF_ATTR.LEVEL)
    if lv < buff:getAttr(BUFF_ATTR.MAX_LEVEL) then
        buff:setAttr(BUFF_ATTR.LEVEL,lv+1)
    else
        if skill:getAttr(SKILL_ATTR.TYPE) == SKILL_TYPE.DMG then
            buff:setAttr(BUFF_ATTR.LEVEL,0)
        end
    end
end

CheckEff = class("CheckEff",Effect)
function CheckEff:DoEffect(pam)
    local buff = self.trigger.comp
    local lv = buff:getAttr(BUFF_ATTR.LEVEL)
    if lv ~= buff:getAttr(BUFF_ATTR.MAX_LEVEL) then
        return false
    end

    local obj = pam:getParam(self:getAttr(EFF_ATTR.VAL1))
    if obj:getAttr(SKILL_ATTR.TYPE) ~= SKILL_TYPE.DMG then
        return false
    end
end

AttrEff = class("AttrEff",Effect)
function AttrEff:DoEffect(pam)
    local obj = pam:getParam(PAM_ATTR.OBJ_EFF_TAKER)
    local attrcomp = obj:appendAttr(self.AttrComp.finalAttr)
    self:setAttr(BUFF_ATTR.ATTR_COMP,attrcomp)
end

function AttrEff:destroy()
    local attrcomp = self:getAttr(BUFF_ATTR.ATTR_COMP)
    if attrcomp then
        attrcomp:remSelfComp()
    end
end

ObjStateEff = class("ObjStateEff",Effect)
function ObjStateEff:DoEffect(pam)
    local obj = pam:getParam(PAM_ATTR.OBJ_EFF_TAKER)
    local oldstate = obj:getAttr(OBJ_ATTR.OBJ_STATE)
    local state = self:getAttr(EFF_ATTR.VAL1)
    oldstate = Mbit.setbit(oldstate,state,true)
    obj:setAttr(OBJ_ATTR.OBJ_STATE,oldstate)
    self.target = obj
end

function ObjStateEff:destroy()
    if self.target then
        local oldstate = target:getAttr(OBJ_ATTR.OBJ_STATE)
        local state = self:getAttr(EFF_ATTR.VAL1)
        oldstate = Mbit.setbit(oldstate,state,false)
        self.target:setAttr(OBJ_ATTR.OBJ_STATE,oldstate)
        self.target = nil
    end
end

EventEff = class("EventEff",Effect)
function EventEff:DoEffect(pam)
    local obj = pam:getParam(self:getAttr(EFF_ATTR.VAL1))
    local events = self:getAttr(EFF_ATTR.VAL2)
    obj:doEvent(events,pam)
end

CostEff = class("CostEff",Effect)
function CostEff:DoEffect(pam)
    local maker = pam:getParam(PAM_ATTR.OBJ_EFF_MAKER)
    local val = maker:getAttr(self:getAttr(EFF_ATTR.VAL1))
    local cost = self:getAttr(EFF_ATTR.VAL2)
    if val ==nil or val < cost then
        self.trigger.triggerReturn = false
        return
    end

    local res = {}
    res.attrid = self:getAttr(EFF_ATTR.VAL1)
    res.events = {}
    res.taker = maker
    res.val = -cost
    table.insert(res.events,{res.attrid,ATTR_CHANGE_TYPE.MINUS,self.trigger.type})
    table.insert(res.events,{res.attrid,ATTR_CHANGE_TYPE.MINUS})
    self.trigger:setRes(res)
end

RecoverEff = class("RecoverEff",Effect)
function RecoverEff:DoEffect(pam)
    local maker = pam:getParam(PAM_ATTR.OBJ_EFF_MAKER)
    local add = self:getAttr(EFF_ATTR.VAL2)

    local res = {}
    res.attrid = self:getAttr(EFF_ATTR.VAL1)
    res.events = {}
    res.taker = maker
    res.val = add
    table.insert(res.events,{res.attrid,ATTR_CHANGE_TYPE.PLUS,self.trigger.type})
    table.insert(res.events,{res.attrid,ATTR_CHANGE_TYPE.PLUS})
    self.trigger:setRes(res)
end

CheckDiePassEff = class("CheckDiePassEff",Effect)
function CheckDiePassEff:DoEffect(pam)
    local obj = pam:getParam(self:getAttr(EFF_ATTR.VAL1))
    if not obj:IsDead() then
        return false
    end
end

DestroySelfEff = class("DestroySelfEff",Effect)
function DestroySelfEff:DoEffect(pam)
    self.trigger.comp:setAttr(COMM_ATTR.CAT_DESTROY,true)
end