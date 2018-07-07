ObjectFunc = {}
-- 考虑 state 作为 table的方式
function ObjectFunc.CheckAction(obj,actType)
    local state = obj:getAttr(OBJ_ATTR.OBJ_STATE) or 0
    if state == 0 then
        return true
    end

    for s,v in pairs(OBJ_STATE_TO_ACT_STATE) do
        if Mbit.checkbit(state,s) then
            if Mbit.checkbit(v,actType) then
                return false
            end
        end
    end

    return true
end