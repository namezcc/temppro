FUNC_ID = {
    F_CHECK_DEAD = 1,
}
FUNC_TABLE = {}
local F = FUNC_TABLE

FuncTrigger = class("FuncTrigger",Object)
function FuncTrigger:ctor(cfg)
    FuncTrigger.super.ctor(self,cfg.id,cfg.bigtype)
    self:initGroup(cfg.group)
end

function FuncTrigger:initGroup(group)
    self.group = {}
    for i,v in ipairs(group) do
        local func = FUNC_TABLE[v.id].new(v)
        func.trigger = self
        table.insert(self.group,func)
    end
end

function FuncTrigger:onAddtoComp(comp)
    self.comp = comp
    comp:addEvent({OBJ_EVENT.DO_FUNCTION,self.id},function(pam)
        return self:doFunc(pam)
    end)
end

function FuncTrigger:doFunc(pam)
    for i,v in ipairs(self.group) do
        if v:doFunc(pam) == false then
            return false
        end
    end
end

function FuncTrigger:destroy()
    for i,v in ipairs(self.group) do
        v:destroy()
        v.trigger = nil
    end
    self.group = nil
end

local FuncComp = class("FuncComp")
function FuncComp:ctor(cfg)
    self.cfg = cfg
end

function FuncComp:doFunc(pam)
end

function FuncComp:destroy()
    self.cfg = nil
end

local F_checkDead = class("F_checkDead",FuncComp)
F[FUNC_ID.F_CHECK_DEAD] = F_checkDead

function F_checkDead:doFunc(pam)
    local obj = pam:getParam(self.cfg.val1)
    if obj:IsDead() then
        return true
    else
        return false
    end
end
--------------------------------------------