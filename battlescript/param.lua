ParamObject = class("ParamObject",Object)

function ParamObject:ctor()
    self.param = {}
end

function ParamObject:setParam(pid,val)
    self.param[pid] = val
end

function ParamObject:getParam(pid)
    return self.param[pid]
end

function ParamObject:combin(pam)
    for k,v in pairs(pam.param) do
        self.param[k] = v
    end
end

function ParamObject:clear()
    self.param = {}
end

PARAM_CHECK_ID = {
    PC_HAVE_PARAM = 1,    
}

PARAM_CHECK_FUNC = {
}

local P = PARAM_CHECK_FUNC