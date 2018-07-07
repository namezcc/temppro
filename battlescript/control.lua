local Control = class("Control",Object)

function Control:ctor( ... )
    Control.super.ctor(self,...)
    self.collect = EventCollect.new()
end

function Control:collectEvent(evlist,pam)
    self.collect:collectEvent(evlist,self.comp)
    self.collect:collectEvent(evlist,pam:getParam(PAM_ATTR.OBJ_EFF_MAKER))
end

function Control:control(pam)
end

function Control:doControl(pam)
end

function Control:beforControl(pam)
    self:collectEvent({COMM_EVENT.BEFOR_CONTROL,self.id},pam)
    return self.collect:doEvent(pam)
end

function Control:afterControl(pam)
    self:collectEvent({COMM_EVENT.AFTER_CONTROL,self.id},pam)
    self.collect:doEvent(pam)
end

function Control:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_CONTROL},function(...)
        self:control(...)
    end)
    self.comp = comp
end

CDControl = class("CDControl",Control)
function CDControl:ctor(cfg ,... )
    CDControl.super.ctor(self,...)
    self.doevents = cfg.doEvent
    self.cdtime = 0
end

function CDControl:checkCD()
    local now = Time.GetMillionSecond()
    if now >= self.cdtime then
        return true
    end
end

function CDControl:afterControl(pam)
    CDControl.super.afterControl(self,pam)
    local cd = self:getAttr(COMM_ATTR.CAT_CONTROL_CD) or 0
    if cd == 0 then
        return
    end
    local now = Time.GetMillionSecond()
    self.cdtime = now + cd
end

function CDControl:control(pam)
    print("control ------------- id:"..self.id)

    if self:checkCD() ~= true then
        print("in cd")
        return false
    end

    pam:setParam(PAM_ATTR.PAT_HERO_SKILL,self.comp)
    if self:beforControl(pam) == false then
        print("control failur")
        return false
    end
    
    if self:doControl(pam) == false then
        return false
    end

    self:afterControl(pam)
end

function CDControl:doControl(pam)
    for i,ev in ipairs(self.doevents) do
        if self.comp:doEvent(ev,pam) == false then
            print("control break:"..i)
            return false
        end
    end
end

SwitchControl = class("SwitchControl",CDControl)
function SwitchControl:ctor(cfg,...)
    SwitchControl.super.ctor(self,cfg,...)
    self.openEvent = cfg.openEvent
    self.closeEvent = cfg.closeEvent
    self.switch = false
end

function SwitchControl:onAddtoComp(comp)
    SwitchControl.super.onAddtoComp(self,comp)

    comp:addEvent({OBJ_EVENT.DO_OPEN_CONTROL},function(pam)
        self.switch = true
        for i,ev in ipairs(self.openEvent) do
            if self.comp:doEvent(ev,pam) == false then
                break
            end
        end
    end)

    comp:addEvent({OBJ_EVENT.DO_CLOSE_CONTROL},function(pam)
        self.switch = false
        for i,ev in ipairs(self.closeEvent) do
            if self.comp:doEvent(ev,pam) == false then
                break
            end
        end
    end)
end

function SwitchControl:doControl(pam)
    if self.switch then
        self.comp:doEvent({OBJ_EVENT.DO_CLOSE_CONTROL},pam)
    else
        self.comp:doEvent({OBJ_EVENT.DO_OPEN_CONTROL},pam)
    end
end

ControlGroup = class("ControlGroup",CDControl)
function ControlGroup:ctor(cfg,...)
    ControlGroup.super.ctor(self,cfg,...)
    self.eventGroup = cfg.eventGroup
    self.index = 1
end

function ControlGroup:onAddtoComp(comp)
    ControlGroup.super.onAddtoComp(self,comp)
    self:initEvent(comp)
end

function ControlGroup:initEvent(comp)
    comp:addEvent({OBJ_EVENT.DO_CTL_JUMP_NEXT,self.id},function()
        self.index = self.index + 1
        if self.index > #self.eventGroup then
            self.index = 1
        end
    end)

    comp:addEvent({OBJ_EVENT.DO_CTL_JUMP_BEGIN,self.id},function()
        self.index = 1
    end)

    for i,v in ipairs(self.eventGroup) do
        comp:addEvent({OBJ_EVENT.DO_CTL_JUMP_INDEX,self.id,i},function()
            self.index = i
        end)
    end
end

function ControlGroup:doControl(pam)
    self.comp:doEvent(self.eventGroup[self.index],pam)
end

ControlSubGroup = class("ControlSubGroup",ControlGroup)
function ControlSubGroup:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_CTL_SUB_CONTROL,self.id},function(...)
        return self:control(...)
    end)
    self.comp = comp
    self:initEvent(comp)
end

ControlSub = class("ControlSub",CDControl)
function ControlSub:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_CTL_SUB_CONTROL,self.id},function(...)
        return self:control(...)
    end)
    self.comp = comp
end