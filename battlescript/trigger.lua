TriggerObject = class("TriggerObject",Object)

function TriggerObject:ctor(...)
    TriggerObject.super.ctor(self,...)
    self.deal = {}
    self.effectGroup = {}
    self.collect = EventCollect.new()
end

function TriggerObject:destroy()
    for i,group in ipairs(self.effectGroup) do
        for k,eff in ipairs(group) do
            eff:destroy()
        end
    end
end

function TriggerObject:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_TRIGGER,self.id},function( ... )
        self.triggerReturn = nil
        self:trigger(...)
        return self.triggerReturn
    end)
    self.comp = comp
end

function TriggerObject:updateAttr(attr)
    if attr.attr then
        TriggerObject.super.updateAttr(self,attr.attr)
    end
    for i,group in ipairs(attr.group) do
        for k,v in ipairs(group) do
            self.effectGroup[i][k]:updateAttr(v)
        end
    end
end

function TriggerObject:addEffGroup(grp)
    for i,v in ipairs(grp) do
        v:setTrgger(self)
    end
    table.insert(self.effectGroup,grp)
end

function TriggerObject:collectEvent(evlist,pam)
    self.collect:collectEvent(evlist,self.comp)

    table.insert(evlist,COMM_EVENT.TRIGGER_TAKER)
    self.collect:collectEvent(evlist,pam:getParam(PAM_ATTR.OBJ_EFF_TAKER))
    
    evlist[#evlist] = COMM_EVENT.TRIGGER_MAKER
    self.collect:collectEvent(evlist,pam:getParam(PAM_ATTR.OBJ_EFF_MAKER))
end

function TriggerObject:beforTrigger(pam)
    self:collectEvent({COMM_EVENT.BEFOR_TRIGGER,self.type},pam)
    return self.collect:doEvent(pam)
end
function TriggerObject:afterTrigger(pam)
    self:collectEvent({COMM_EVENT.AFTER_TRIGGER,self.type},pam)
    self.collect:doEvent(pam)
end
function TriggerObject:trigger(pam)
    if self:beforTrigger(pam) == false then
        return false
    end
    self:clearRes()
    for i,grp in ipairs(self.effectGroup) do
        for k,eff in ipairs(grp) do
            if eff:DoEffect(pam) == false then
                break
            end
        end
        self:dealRes()
    end
    self:afterTrigger(pam)
end
function TriggerObject:clearRes()
    self.deal = {}
end
function TriggerObject:dealRes()
    for k,attrs in pairs(self.deal) do
        for at,v in pairs(attrs) do
            if v.maker then
                self:doAttrResEvent(v.maker,v.events,{COMM_EVENT.BEFOR_CHANGE_ATTR,COMM_EVENT.ATTR_MAKER},v)
            end
            self:doAttrResEvent(v.taker,v.events,{COMM_EVENT.BEFOR_CHANGE_ATTR,COMM_EVENT.ATTR_TAKER},v)
            v.taker:doAttrChange(at,v.val)
            self:doAttrResEvent(v.taker,v.events,{COMM_EVENT.AFTER_CHANGE_ATTR,COMM_EVENT.ATTR_TAKER},v)
            if v.maker then
                self:doAttrResEvent(v.maker,v.events,{COMM_EVENT.AFTER_CHANGE_ATTR,COMM_EVENT.ATTR_MAKER},v)
            end
        end
    end
    self:clearRes()
end

function TriggerObject:setRes(v)
    if self.deal[v.taker] == nil then
        self.deal[v.taker] = {}
    end
    local old = self.deal[v.taker][v.attrid]
    if old then
        old.val = old.val + v.val
    else
        self.deal[v.taker][v.attrid] = v
    end
end

function TriggerObject:doAttrResEvent(obj,evs,append,info)
    for i,ev in ipairs(evs) do
        for k,v in ipairs(append) do
            table.insert(ev,v)
        end
        obj:doEvent(ev,info)
        for k=1,#append do
            table.remove(ev,#ev)
        end
    end
end

TriggerAndDestroySelf = class("TriggerAndDestroySelf",TriggerObject)
function TriggerAndDestroySelf:trigger(pam)
    TriggerAndDestroySelf.super.trigger(self,pam)
    self.comp:doEvent({OBJ_EVENT.DO_DESTROY_SELF})
end