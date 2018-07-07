TimeCheck = class("TimeCheck",Object)
function TimeCheck:ctor(cfg ,... )
    TimeCheck.super.ctor(self,...)
    self.doevents = cfg.doEvent
end

function TimeCheck:afterUpdateAttr()
    self.dopoint = Time.GetMillionSecond() + self:getAttr(COMM_ATTR.CAT_CHECK_TIME)
end

function TimeCheck:refreshSame(sameObj)
    self.dopoint = sameObj.dopoint
end

function TimeCheck:update(stemp)
    if stemp >= self.dopoint then
        self.comp:doListEvent(self.doevents,ParamObject.new())
    end 
end

TimeCheckDestroy = class("TimeCheckDestroy",TimeCheck)
function TimeCheckDestroy:update(stemp)
    if stemp >= self.dopoint then
        self.comp:doListEvent(self.doevents,ParamObject.new())
        self.comp:doEvent({OBJ_EVENT.DO_DESTROY_SELF})
    end 
end

TimeInterval = class("TimeInterval",Object)
function TimeInterval:ctor(cfg ,... )
    TimeInterval.super.ctor(self,...)
    self.doevents = cfg.doEvent
    self.interval = cfg.interval
    self.dopoint = Time.GetMillionSecond() + self.interval
end

function TimeInterval:afterUpdateAttr()
    local last = self:getAttr(COMM_ATTR.CAT_CHECK_TIME)
    if last == nil then
        self.endpoint = -1
    else
        self.endpoint = Time.GetMillionSecond() + last
    end
end

function TimeInterval:refreshSame(sameObj)
    self.endpoint = sameObj.endpoint
end

function TimeInterval:update(stemp)
    if stemp >= self.dopoint then
        self.dopoint = stemp + self.interval
        self.comp:doListEvent(self.doevents,ParamObject.new())
    end

    if self.endpoint < 0 then
        return
    end

    if stemp >= self.endpoint then
        self.comp:doEvent({OBJ_EVENT.DO_DESTROY_SELF})
        return
    end
end

DelayTimeInterval = class("DelayTimeInterval",TimeInterval)
function DelayTimeInterval:ctor(cfg)
    DelayTimeInterval.super.ctor(self,cfg,cfg.id,cfg.bigtype)
    local delay = cfg.delay or 0
    self.dopoint = Time.GetMillionSecond() + delay
end

UpdateEvent = class("UpdateEvent",Object)
function UpdateEvent:ctor(cfg)
    UpdateEvent.super.ctor(self,cfg.id,cfg.bigtype)
    self.doevents = cfg.doEvent
end

function UpdateEvent:update()
    self.comp:doListEvent(self.doevents,ParamObject.new())
end

DistanceCheck = class("DistanceCheck",Object)
function DistanceCheck:ctor( cfg,... )
    DistanceCheck.super.ctor(self,...)
    self.doevents = cfg.doEvent
    self.distance = cfg.distance
    self.target = cfg.target
    self.checker = cfg.checker
end

function DistanceCheck:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_EFF_GEN_SELF},function(pam)
        self:initCheck(pam)
    end)
    self.comp = comp
end

function DistanceCheck:initCheck(pam)
    local taker = pam:getParam(self.target)
    self.target = taker
    if self.checker then
        self.checker = pam:getParam(self.checker)
    else
        self.checker = self.comp
    end
end

function DistanceCheck:update(stamp)
    if self.target == nil then
        return
    end

    if self.comp:getAttr(COMM_ATTR.CAT_DESTROY) then
        return
    end

    if self.target:IsDead() or self.target:getAttr(COMM_ATTR.CAT_DESTROY) then
        return
    end

    local x1 = self.checker:getAttr(OBJ_ATTR.OAT_POS_X)
    local y1 = self.checker:getAttr(OBJ_ATTR.OAT_POS_Y)
    local x2 = self.target:getAttr(OBJ_ATTR.OAT_POS_X)
    local y2 = self.target:getAttr(OBJ_ATTR.OAT_POS_Y)

    local dis = vmath.lenghInt(x1,y1,x2,y2)
    if dis <= self.distance then
        self.comp:doListEvent(self.doevents,ParamObject.new())
    end
end

-- DistanceCheck = class("DistanceCheck",Object)
-- function DistanceCheck:ctor( cfg,... )
--     DistanceCheck.super.ctor(self,...)
--     self.doevents = cfg.doEvent
--     self.distance = cfg.distance
-- end

-- function DistanceCheck:onAddtoComp(comp)
--     comp:addEvent({OBJ_EVENT.DO_CHECK_DISTANCE},function(pam)
--         self:initCheck(pam)
--     end)
--     self.comp = comp
-- end

ChooseRangeCheck = class("ChooseRangeCheck",Object)
function ChooseRangeCheck:ctor( cfg,... )
    ChooseRangeCheck.super.ctor(self,...)
    self.distance = cfg.distance
end

function ChooseRangeCheck:onAddtoComp(comp)
    comp:addEvent({COMM_EVENT.DO_CHECK_DISTANCE},function(pam)
        return self:checkRange(pam)
    end)
    self.comp = comp
end

function ChooseRangeCheck:checkRange(pam)
    local obj = pam:getParam(PAM_ATTR.OBJ_EFF_TAKER)
    local maker = pam:getParam(PAM_ATTR.OBJ_EFF_MAKER)
    if obj == nil then
        return false
    end

    local x1 = maker:getAttr(OBJ_ATTR.OAT_POS_X)
    local y1 = maker:getAttr(OBJ_ATTR.OAT_POS_Y)
    local x2 = obj:getAttr(OBJ_ATTR.OAT_POS_X)
    local y2 = obj:getAttr(OBJ_ATTR.OAT_POS_Y)
    local len = vmath.lenghInt(x1,y1,x2,y2)
    if len > self.distance then
        return false
    end
end

local ShapeTrigger = class("ShapeTrigger",Object)
function ShapeTrigger:ctor(cfg)
    ShapeTrigger.super.ctor(self,cfg.id,cfg.bigtype)
    self.doevents = cfg.doEvent
    self.selector = cfg.selector
end

function ShapeTrigger:onAddtoComp(comp)
    comp:addEvent({OBJ_EVENT.DO_SHAPE_TRIGGER,self.id},function()
        self:check()
    end)

    comp:addEvent({OBJ_EVENT.DO_EFF_GEN_SELF},function(pam)
        local maker = pam:getParam(PAM_ATTR.OBJ_EFF_MAKER)
        self.maker = maker
    end)
    self.comp = comp
end

function ShapeTrigger:checkShape()
    local list = {}
    self.comp.scene:selectObject(self.selector,self.maker,function(obj)
        if self:checkFunc(obj) then
            table.insert(list,obj)
        end
    end)
    return list
end

function ShapeTrigger:checkFunc(obj)
end

function ShapeTrigger:getParam()
    local pam = ParamObject.new()
    --pam:setParam(PAM_ATTR.OBJ_EFF_MAKER,self:getAttr(PAM_ATTR.OBJ_EFF_MAKER))
    pam:setParam(PAM_ATTR.OBJ_EFF_MAKER,self.maker)
    return pam
end

function ShapeTrigger:check()
    local objList = self:checkShape()
    if objList==nil or #objList == 0 then
        return
    end

    for i,obj in ipairs(objList) do
        local pam = self:getParam()
        pam:setParam(PAM_ATTR.OBJ_EFF_TAKER,obj)

        self.comp:doListEvent(self.doevents,pam)
    end
end

ShapeSector = class("ShapeSector",ShapeTrigger)
function ShapeSector:ctor(cfg)
    ShapeSector.super.ctor(self,cfg)
    self.radii = cfg.radii 
    self.angle = cfg.angle
    self.posmod = cfg.posmod
    self.dirmod = cfg.dirmod
end

function ShapeSector:getPos()
    local x,y
    if self.posmod == SHAPE_ATTR_MOD.SAM_FROM_MAKER then
        x = self.maker:getAttr(OBJ_ATTR.OAT_POS_X)
        y = self.maker:getAttr(OBJ_ATTR.OAT_POS_Y)
    else
        x = self.comp:getAttr(OBJ_ATTR.OAT_POS_X)
        y = self.comp:getAttr(OBJ_ATTR.OAT_POS_Y)
    end
    return x,y
end

function ShapeSector:getDir()
    local x,y
    if self.posmod == SHAPE_ATTR_MOD.SAM_FROM_MAKER then
        x = self.maker:getAttr(OBJ_ATTR.OAT_DIR_X)
        y = self.maker:getAttr(OBJ_ATTR.OAT_DIR_Y)
    else
        x = self.comp:getAttr(OBJ_ATTR.OAT_DIR_X)
        y = self.comp:getAttr(OBJ_ATTR.OAT_DIR_Y)
    end
    return x,y
end

function ShapeSector:checkFunc(obj)
    local sx,sy = self:getPos()
    local dirx,diry = self:getDir()

    local ox = obj:getAttr(OBJ_ATTR.OAT_POS_X)
    local oy = obj:getAttr(OBJ_ATTR.OAT_POS_Y)

    local length = vmath.lenghInt(sx,sy,ox,oy)
    if length > self.radii then
        print("length short radii:"..self.radii.."  length:"..length)
        return false
    end

    local vecdir = Vector.new(dirx,diry)
    local veco = vmath.vector(sx,sy,ox,oy)
    local angle = vmath.angle(vecdir,veco)
    if angle <= self.angle then
        return true
    else
        print("angle not suport need:"..self.angle.."  angle:"..angle)
    end
end

ShapeCircle = class("ShapeCircle",ShapeTrigger)
function ShapeCircle:ctor(cfg)
    ShapeCircle.super.ctor(self,cfg)
    self.radii = cfg.radii 
    self.posmod = cfg.posmod
end

function ShapeCircle:getPos()
    local x,y
    if self.posmod == SHAPE_ATTR_MOD.SAM_FROM_MAKER then
        x = self.maker:getAttr(OBJ_ATTR.OAT_POS_X)
        y = self.maker:getAttr(OBJ_ATTR.OAT_POS_Y)
    else
        x = self.comp:getAttr(OBJ_ATTR.OAT_POS_X)
        y = self.comp:getAttr(OBJ_ATTR.OAT_POS_Y)
    end
    return x,y
end

function ShapeCircle:checkFunc(obj)
    local sx,sy = self:getPos()

    local ox = obj:getAttr(OBJ_ATTR.OAT_POS_X)
    local oy = obj:getAttr(OBJ_ATTR.OAT_POS_Y)

    local length = vmath.lenghInt(sx,sy,ox,oy)
    if length > self.radii then
        --print("length short radii:"..self.radii.."  length:"..length)
        return false
    end
    return true
end