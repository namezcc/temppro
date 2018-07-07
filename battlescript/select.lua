SELECT_TYPE = {
    SL_ALIVE_ENEMY = 1,
}

local RELATION = {
    ENEMY = 1,
    TEAMMATE = 2,
}

SELECT_FUNC = {}
local S = SELECT_FUNC

local function CheckRelation(obj1,obj2)
    local cmp1 = obj1:getAttr(OBJ_ATTR.OAT_CAMP)
    local cmp2 = obj2:getAttr(OBJ_ATTR.OAT_CAMP)
    if cmp1 == cmp2 then
        return RELATION.TEAMMATE
    else
        return RELATION.ENEMY
    end
end

local stype1 = {
    OBJ_TYPE.HERO,
}
S[SELECT_TYPE.SL_ALIVE_ENEMY] = function(scene,obj,slfunc)
    for i,tp in ipairs(stype1) do
        scene:getObjectByType(tp,function(obj2)
            if obj2.id ~= obj.id and 
                CheckRelation(obj,obj2) == RELATION.ENEMY then
                slfunc(obj2)
            end
        end)
    end
end