EventCollect = class("EventCollect",Object)
function EventCollect:ctor()
    self.event = {}
end

function EventCollect:collectEvent(evlist,obj)
    if obj == nil then
        return
    end
    local events = obj.event:getEvents(evlist)
    if events then
        for i,v in ipairs(events) do
            table.insert(self.event,v)
        end
    end
end

function EventCollect:doEvent(...)
    if #self.event == 0 then
        return
    end
    table.sort( self.event, function(a,b)
        return a.level > b.level
    end)
    for i,v in ipairs(self.event) do
        if v.func(...) == false then
            return false
        end
    end
    self:clear()
    return true
end

function EventCollect:clear()
    self.event = {}
end

FollowDestroy = class("FollowDestroy",Object)
function FollowDestroy:ctor( ... )
    FollowDestroy.super.ctor(self,...)
    self.removeList = {}
end

function FollowDestroy:destroy()
    for i,v in ipairs(self.removeList) do
        v.object:removeEvent(v.events,v.id)
    end
    self.removeList = nil
end

function FollowDestroy:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_LISTEN},function(...)
        self:listenDestroy(...)
    end)
    self.comp = comp
end

function FollowDestroy:listenDestroy(obj)
    local evlist = {COMM_EVENT.BEFOR_DESTROY}
    local lid = obj:addEvent(evlist,function()
        self.comp:setAttr(COMM_ATTR.CAT_DESTROY,true)        
    end)
    table.insert(self.removeList,{events=evlist,object=obj,id=lid})
end

EventDestroy = class("EventDestroy",Object)
function EventDestroy:ctor(cfg,...)
    EventDestroy.super.ctor(self,...)
    self.listen = cfg.listen
end

function EventDestroy:onAddtoComp(comp)
    for i,ev in ipairs(self.listen) do
        comp:addEvent(ev,function( ... )
            comp:setAttr(COMM_ATTR.CAT_DESTROY,true)
        end) 
    end
end

MoveComp = class("MoveComp",Object)
function MoveComp:ctor(cfg)
    MoveComp.super.ctor(self,cfg.id,cfg.bigtype)
    self.length = cfg.length or 0
    self.endpoint = 0
end

function MoveComp:afterUpdateAttr()
    if self.length > 0 then
        local speed = self.comp:getAttr(OBJ_ATTR.OAT_SPEED)
        local use = self.length*1000/speed
        self.endpoint = Time.GetMillionSecond() + use
    end
end

function MoveComp:onAddtoComp(comp)
    self.comp = comp
    comp:addEvent({OBJ_EVENT.DO_EFF_GEN_SELF},function()
        self:initMdir()
    end)
end

function MoveComp:initMdir()
    local x1 = self.comp:getAttr(OBJ_ATTR.OAT_DIR_X) or 0
    local y1 = self.comp:getAttr(OBJ_ATTR.OAT_DIR_Y) or 0
    local nx,ny=0,0
    if x1 ~= 0 or y1 ~= 0 then
        nx,ny= vmath.normalize(0,0,x1,y1)
    end
    self.comp:setAttr(OBJ_ATTR.OAT_MDIR_X,nx)
    self.comp:setAttr(OBJ_ATTR.OAT_MDIR_Y,ny)
end

function MoveComp:update(stamp)
    local lastStamp = self.comp.scene.lastStamp
    local mdx = self.comp:getAttr(OBJ_ATTR.OAT_MDIR_X) or 0
    local speed = self.comp:getAttr(OBJ_ATTR.OAT_SPEED) or 0
    if mdx ~= 0 then
        local sx = speed*mdx
        local nx = sx*(stamp-lastStamp)/1000+self.comp:getAttr(OBJ_ATTR.OAT_POS_X)
        self.comp:setAttr(OBJ_ATTR.OAT_POS_X,nx)
    end

    local mdy = self.comp:getAttr(OBJ_ATTR.OAT_MDIR_Y) or 0
    if mdy ~= 0 then
        local sy = speed*mdy
        local ny = sy*(stamp-lastStamp)/1000+self.comp:getAttr(OBJ_ATTR.OAT_POS_Y)
        self.comp:setAttr(OBJ_ATTR.OAT_POS_Y,ny)
    end

    if self.endpoint > 0 and stamp >= self.endpoint then
        self.comp:doEvent({OBJ_EVENT.DO_DESTROY_SELF})
    end
end

MoveTarget = class("MoveTarget",MoveComp)
function MoveTarget:ctor(cfg)
    MoveTarget.super.ctor(self,cfg)
    self.target = cfg.target
end

function MoveTarget:onAddtoComp(comp)
    MoveTarget.super.onAddtoComp(self,comp)

    comp:addEvent({OBJ_EVENT.DO_EFF_GEN_SELF},function(pam)
        self.target = pam:getParam(self.target)
        self.target:doEvent({OBJ_EVENT.DO_MOVE_TARGET_DESTROY})
    end)

    comp:addEvent({OBJ_EVENT.DO_MOVE_TARGET_DESTROY},function()
        comp:doEvent({OBJ_EVENT.DO_DESTROY_SELF})
    end)
end

function MoveTarget:update(stamp)
    if self.target == nil or self.target:IsDead() then
        self.comp:doEvent({OBJ_EVENT.DO_DESTROY_SELF})
        return
    end

    local lastStamp = self.comp.scene.lastStamp
    local mdx = self.comp:getAttr(OBJ_ATTR.OAT_MDIR_X) or 0
    local mdy = self.comp:getAttr(OBJ_ATTR.OAT_MDIR_Y) or 0

    local speed = self.comp:getAttr(OBJ_ATTR.OAT_SPEED) or 0
    if mdx ~= 0 then
        local sx = speed*mdx
        local nx = sx*(stamp-lastStamp)/1000+self.target:getAttr(OBJ_ATTR.OAT_POS_X)
        self.target:setAttr(OBJ_ATTR.OAT_POS_X,nx)
    end

    if mdy ~= 0 then
        local sy = speed*mdy
        local ny = sy*(stamp-lastStamp)/1000+self.target:getAttr(OBJ_ATTR.OAT_POS_Y)
        self.target:setAttr(OBJ_ATTR.OAT_POS_Y,ny)
    end

    if self.endpoint > 0 and stamp >= self.endpoint then
        self.comp:doEvent({OBJ_EVENT.DO_DESTROY_SELF})
    end
end

PosBorn = class("PosBorn",Object)
function PosBorn:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_EFF_GEN_SELF},function(pam)
        self:bornPos(pam)    
    end,EVENT_LEVEL.LEVEL_10)
    self.comp = comp
end

function PosBorn:bornPos(pam)
end

PosBornMaker = class("PosBornMaker",PosBorn)
function PosBornMaker:bornPos(pam)
    local maker = pam:getParam(PAM_ATTR.OBJ_EFF_MAKER)
    local x = maker:getAttr(OBJ_ATTR.OAT_POS_X)
    local y = maker:getAttr(OBJ_ATTR.OAT_POS_Y)

    self.comp:setAttr(OBJ_ATTR.OAT_POS_X,x)
    self.comp:setAttr(OBJ_ATTR.OAT_POS_Y,y)
end

AttrMaker = class("AttrMaker",Object)
function AttrMaker:ctor(cfg)
    AttrMaker.super.ctor(self,cfg.id,cfg.bigtype)
    self.config = cfg.config
end

function AttrMaker:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_EFF_GEN_SELF},function(pam)
        self:makeAttr(pam)
    end,EVENT_LEVEL.LEVEL_10)
    self.comp = comp
end

function AttrMaker:makeAttr(pam)
    for i,cfg in ipairs(self.config) do
        if cfg.attrfrom == PAM_ATTR.PMA_OBJ_SELF then
            self.comp:setAttr(cfg.attrid,pam:getParam(cfg.attrid))
        else
            local obj = pam:getParam(cfg.attrfrom)
            self.comp:setAttr(cfg.attrid,obj:getAttr(cfg.attrid))
        end
    end
end


Tracker = class("Tracker",Object)
function Tracker:ctor(cfg)
    Tracker.super.ctor(self,cfg.id,cfg.bigtype)
    self.tracker = cfg.tracker
    self.speedFrom = cfg.speedFrom
end

function Tracker:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_BEGIN_TRACK},function(pam)
        self:beginTrack(pam)
    end)
    self.comp = comp
end

function Tracker:update(stamp)
    self:track(stamp)
end

function Tracker:beginTrack(pam)
    local obj = pam:getParam(PAM_ATTR.OBJ_EFF_TAKER)
    self.target = obj
    if self.tracker == nil then
        self.tracker = self.comp
    else
        self.tracker = pam:getParam(self.tracker)
    end

    if self.speedFrom then
        self.speedFrom = pam:getParam(self.speedFrom)
    else
        self.speedFrom = self.comp
    end
    self:track()
end

function Tracker:checkTrack(stamp)
    return true
end

function Tracker:getTargetPos()
    local x = self.target:getAttr(OBJ_ATTR.OAT_POS_X)
    local y = self.target:getAttr(OBJ_ATTR.OAT_POS_Y)
    return x,y
end

function Tracker:getBeginPos()
    local x = self.tracker:getAttr(OBJ_ATTR.OAT_POS_X)
    local y = self.tracker:getAttr(OBJ_ATTR.OAT_POS_Y)
    return x,y
end

function Tracker:getSpeed()
    return self.speedFrom:getAttr(OBJ_ATTR.OAT_SPEED)
end

function Tracker:track(stamp)
    if self:checkTrack(stamp) ~= true then
        return
    end

    local x1,y1 = self:getBeginPos()
    local x2,y2 = self:getTargetPos()
    local nx,ny = vmath.normalize(x1,y1,x2,y2)
    self.comp:setAttr(OBJ_ATTR.OAT_MDIR_X,nx)
    self.comp:setAttr(OBJ_ATTR.OAT_MDIR_Y,ny)
end

TrackerFollowDestroy = class("TrackerFollowDestroy",Tracker)
function TrackerFollowDestroy:checkTrack(stamp)
    if self.comp:getAttr(COMM_ATTR.CAT_DESTROY) then
        return false
    end
    if self.target == nil or 
       self.target:IsDead() or 
       self.target:getAttr(COMM_ATTR.CAT_DESTROY) then

       self.comp:doEvent({OBJ_EVENT.DO_DESTROY_SELF})
       return false
    end
    return true
end

TrackerLastPosition = class("TrackerLastPosition",Tracker)
function TrackerLastPosition:checkTrack(stamp)
    if self.comp:getAttr(COMM_ATTR.CAT_DESTROY) then
        return false
    end
    if self.target then
        if self.target:IsDead() or self.target:getAttr(COMM_ATTR.CAT_DESTROY) then
            self.lastx = self.target:getAttr(OBJ_ATTR.OAT_POS_X)
            self.lasty = self.target:getAttr(OBJ_ATTR.OAT_POS_Y)
            self.target = nil

            local sp = self:getSpeed()
            local x1,y1 = self:getBeginPos()
            local len = vmath.lenghInt(x1,y1,self.lastx,self.lasty)
            local usems = len*1000/sp
            self.lastStamp = stamp + usems
        end
    else
        if self.lastStamp <= stamp then
            self.comp:doEvent({OBJ_EVENT.DO_DESTROY_SELF})
            return false
        end
    end
    return true
end

function TrackerLastPosition:getTargetPos()
    if self.target == nil then
        return self.lastx,self.lasty
    else
        return TrackerLastPosition.super.getTargetPos(self)
    end
end

BuffRepRefresh = class("BuffRepRefresh",Object)
function BuffRepRefresh:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_BUFF_REPEAT},function(oldbuff)
        oldbuff:refreshSame(comp)
        return false
    end)
end

BuffRepReplace = class("BuffRepReplace",Object)
function BuffRepReplace:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_BUFF_REPEAT},function(oldbuff)
        oldbuff:setAttr({COMM_ATTR.CAT_DESTROY},true)
        oldbuff:destroy()
    end)
end

EventBranch = class("EventBranch",Object)
function EventBranch:ctor(cfg)
    EventBranch.super.ctor(self,cfg.id,cfg.bigtype)
    self.eventCheck = cfg.eventCheck
    self.eventTrue = cfg.eventTrue
    self.eventFalse = cfg.eventFalse
end

function EventBranch:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_EVENT_BRANCH,self.id},function(pam)
        self:doBranch(pam)
    end)
    self.comp = comp
end

function EventBranch:doBranch(pam)
    local res = true
    for i,ev in ipairs(self.eventCheck) do
        if self.comp:doEvent(ev,pam) == false then
            res = false
            break
        end
    end

    local evtable = nil
    if res == true then
        evtable = self.eventTrue
    else
        evtable = self.eventFalse
    end
    if evtable then
        for i,ev in ipairs(evtable) do
            self.comp:doEvent(ev,pam)
        end
    end
end

SwitchComp = class("SwitchComp",Object)
function SwitchComp:ctor(cfg)
    SwitchComp.super.ctor(self,cfg.id,cfg.bigtype)
    self.switch = cfg.switch or false
end

function SwitchComp:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_SWITCH_CHECK,self.id},function()
        return self.switch
    end)

    comp:addEvent({OBJ_EVENT.DO_SWITCH_OPEN,self.id},function()
        self.switch = true
    end)

    comp:addEvent({OBJ_EVENT.DO_SWITCH_CLOSE,self.id},function()
        self.switch = false
    end)
end

ParamCollect = class("ParamCollect",Object)
function ParamCollect:ctor(cfg)
    ParamCollect.super.ctor(self,cfg.id,cfg.bigtype)
    self.config = cfg.config
    self.pam = ParamObject.new()
end

function ParamCollect:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_EFF_GEN_SELF},function(pam)
        self:collectParam(pam)
    end)

    comp:addEvent({OBJ_EVENT.DO_OUTPUT_PARAM},function(pam)
        self:output(pam)
    end)

    comp:addEvent({OBJ_EVENT.DO_INPUT_PARAM},function(pam)
        self:input(pam)
    end)

    self.comp = comp
end

function ParamCollect:collectParam(pam)
    for i,v in ipairs(self.config) do
        self.pam:setParam(v.set,pam:getParam(v.get))
    end
end

function ParamCollect:output(pam)
    pam:combin(self.pam)
end

function ParamCollect:input(pam)
    self.pam:combin(pam)
end

ObjectMaker = class("ObjectMaker",Object)
function ObjectMaker:ctor(cfg)
    ObjectMaker.super.ctor(self,cfg.id,cfg.bigtype)
    self.structid = cfg.structid
    self.attrid = cfg.attrid or self.structid
    self.pamval = cfg.pamval
end

function ObjectMaker:onAddtoComp(comp)
    self.comp = comp
    comp:addEvent({OBJ_EVENT.DO_MAKE_OBJECT,self.id},function(pam)
        self:makeObject(pam)
    end)
end

function ObjectMaker:makeObject(pam)
    local struct = ObjectStruct[self.structid]
    assert(struct,"nil struct id:"..(self.structid or "nil"))
    local obj = CreateObject(struct,GenTmpObjectID(),self.structid)
    local attr = AttrTable[self.attrid]
    if attr then
        obj:updateAttr(attr[self:getAttr(COMM_ATTR.CAT_MAKE_LEVEL)])
    end
    pam:setParam(self.pamval or PAM_ATTR.NEW_OBJECT,obj)

    obj:setAttr(OBJ_ATTR.OAT_CAMP,self.comp:getAttr(OBJ_ATTR.OAT_CAMP))

    self.comp.scene:pushNewObject(obj)
    obj:doEvent({OBJ_EVENT.DO_EFF_GEN_SELF},pam)
end

BuffAppend = class("BuffAppend",Object)
function BuffAppend:ctor(cfg)
    BuffAppend.super.ctor(self,cfg.id,cfg.bigtype)
    self.target = cfg.target
    self.buff = cfg.buff
end

function BuffAppend:onAddtoComp(comp)
    self.comp = comp
    comp:addEvent({OBJ_EVENT.DO_APPEND_BUFF},function(pam)
        local buff = pam:getParam(self.buff)
        local obj = pam:getParam(self.target)
        buff:appendTo(obj)
    end)
end

TriggerEvent = class("TriggerEvent",Object)
function TriggerEvent:ctor(cfg)
    TriggerEvent.super.ctor(self,cfg.id,cfg.bigtype)
    self.target = cfg.target
    self.doevents = cfg.doEvent
end

function TriggerEvent:onAddtoComp(comp)
    self.comp = comp
    comp:addEvent({OBJ_EVENT.DO_TRIGGER_OBJ_EVENT,self.id},function(pam)
        local obj = pam:getParam(self.target)
        if obj then
            for i,ev in ipairs(self.doevents) do
                if obj:doEvent(ev,pam) == false then
                    break
                end
            end
        end
    end)
end