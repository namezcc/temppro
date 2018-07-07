Object = class("Object")

function Object:ctor(id,ntype,atrcomp)
    self.id = id or 0
    self.type = ntype or 0
    self.AttrComp = atrcomp or AttrComp.new()
    self.event = multiLevelEv.new()
end

function Object:update(stemp)
end

function Object:destroy()
end

function Object:getAttr(attrid)
    return self.AttrComp:getFinalAttr(attrid)
end

function Object:setAttr(attrid,val)
    self.AttrComp:setFinalAttr(attrid,val)
end

function Object:addEvent(evlist,func,lv)
    return self.event:addEvent(evlist,func,lv)
end

function Object:removeEvent(evlist,id)
    self.event:removeEvent(evlist,id)
end

function Object:doEvent(evlist,...)
    return self.event:doEvent(evlist,...)
end

function Object:doListEvent(list,...)
    for i,ev in ipairs(list) do
        if self:doEvent(ev,...) == false then
            break
        end
    end
end

function Object:doAttrChange(aid,val)
    self.AttrComp.attrChange[aid] = nil
    self.AttrComp:addFinalAttr(aid,val)
    local oldval = self.AttrComp.attrChange[aid]
    self:attrChangeEvent(aid,self.AttrComp:getFinalAttr(aid),oldval)
end

function Object:attrChangeEvent(aid,oldval,newval)
end

function Object:onAddtoComp(comp)
    self.comp = comp
end

function Object:updateAttr(attr)
    self.AttrComp:addComp(AttrComp.new(attr))
end

function Object:afterUpdateAttr()
end

function Object:appendAttr(attr)
    return self.AttrComp:appendAttr(attr)
end

function Object:refreshSame(sameObj)
end