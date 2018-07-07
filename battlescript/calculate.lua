
local CALC_OPERATION = {
    OPT_GET_ATTR = 1,
    OPT_ADD = 2,
    OPT_MINUS = 3,
    OPT_MULT = 4,
    OPT_DIVID = 5,
    OPT_CMP_BG = 6,
    OPT_CMP_EQ = 7,
    OPT_CMP_LS = 8,
    OPT_CMP_NEQ = 9,
    OPT_CMP_BG_EQ = 10,
    OPT_CMP_LS_EQ = 11,
    OPT_CMP_JUMP = 12,
    OPT_CMP_SET = 13,
}

local OPT_PAM_AT = {
    OPA_OPT = 1,
    OPA_IN_IDX = 2,
    OPA_TO_IDX = 3,
    OPA_ATTR_ID = 4,
    OPA_JUMP_IDX = 5,
    OPA_T_JUMP_IDX = 6,
    OPA_F_JUMP_IDX = 7,
    OPA_SET_VAL = 8,
}

local CalcObject = class("CalcObject",Object)

function CalcObject:opt_getAttr(p)
    self.cash[p:getAttr(OPT_PAM_AT.OPA_TO_IDX)] = self.objbox[p:getAttr(OPT_PAM_AT.OPA_IN_IDX)]:getAttr(p:getAttr(OPT_PAM_AT.OPA_ATTR_ID))
end
function CalcObject:opt_add(p)
    self.cash[p:getAttr(OPT_PAM_AT.OPA_TO_IDX)] = self.cash[1] + self.cash[2]
end
function CalcObject:opt_minus(p)
    self.cash[p:getAttr(OPT_PAM_AT.OPA_TO_IDX)] = self.cash[1] - self.cash[2] 
end
function CalcObject:opt_mult(p)
    self.cash[p:getAttr(OPT_PAM_AT.OPA_TO_IDX)] = self.cash[1] * self.cash[2]
end
function CalcObject:opt_divid(p)
    self.cash[p:getAttr(OPT_PAM_AT.OPA_TO_IDX)] = self.cash[1] / self.cash[2]
end
function CalcObject:opt_bg(p)
    if self.cash[1] > self.cash[2] then
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_T_JUMP_IDX))
    else
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_F_JUMP_IDX))
    end
end
function CalcObject:opt_eq(p)
    if self.cash[1] == self.cash[2] then
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_T_JUMP_IDX))
    else
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_F_JUMP_IDX))
    end
end
function CalcObject:opt_ls(p)
    if self.cash[1] < self.cash[2] then
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_T_JUMP_IDX))
    else
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_F_JUMP_IDX))
    end
end
function CalcObject:opt_neq(p)
    if self.cash[1] ~= self.cash[2] then
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_T_JUMP_IDX))
    else
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_F_JUMP_IDX))
    end
end
function CalcObject:opt_bg_eq(p)
    if self.cash[1] >= self.cash[2] then
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_T_JUMP_IDX))
    else
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_F_JUMP_IDX))
    end
end
function CalcObject:opt_ls_eq(p)
    if self.cash[1] <= self.cash[2] then
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_T_JUMP_IDX))
    else
        self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_F_JUMP_IDX))
    end
end
function CalcObject:opt_jump(p)
    self:jumpProc(p:getAttr(OPT_PAM_AT.OPA_JUMP_IDX))
end
function CalcObject:opt_set(p)
    self.cash[p:getAttr(OPT_PAM_AT.OPA_TO_IDX)] = p:getAttr(OPT_PAM_AT.OPA_SET_VAL)
end

CalcObject.CalcFunc = {
    [CALC_OPERATION.OPT_GET_ATTR] = CalcObject.opt_getAttr,
    [CALC_OPERATION.OPT_ADD] = CalcObject.opt_add,
    [CALC_OPERATION.OPT_MINUS] = CalcObject.opt_minus,
    [CALC_OPERATION.OPT_MULT] = CalcObject.opt_mult,
    [CALC_OPERATION.OPT_DIVID] = CalcObject.opt_divid,
    [CALC_OPERATION.OPT_CMP_BG] = CalcObject.opt_bg,
    [CALC_OPERATION.OPT_CMP_EQ] = CalcObject.opt_eq,
    [CALC_OPERATION.OPT_CMP_LS] = CalcObject.opt_ls,
    [CALC_OPERATION.OPT_CMP_NEQ] = CalcObject.opt_neq,
    [CALC_OPERATION.OPT_CMP_BG_EQ] = CalcObject.opt_bg_eq,
    [CALC_OPERATION.OPT_CMP_LS_EQ] = CalcObject.opt_ls_eq,
    [CALC_OPERATION.OPT_CMP_JUMP] = CalcObject.opt_jump,
    [CALC_OPERATION.OPT_CMP_SET] = CalcObject.opt_set,
}

function CalcObject:initProgress(proc)
    self.objbox = {}
    self.cash = {}
    self.proIndex = 1
    self.progress = proc
end

function CalcObject:jumpProc(index)
    self.proIndex = index - 1
end

function CalcObject:calc()
    local max = #self.progress
    while(self.proIndex<=max)
    do
        local v = self.progress
        self.CalcFunc[v:getAttr(OPT_PAM_AT.OPA_OPT)](self,v)
        self.proIndex = self.proIndex + 1
    end
end