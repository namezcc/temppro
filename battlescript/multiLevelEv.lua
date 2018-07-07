local SortEvent = class("SortEvent")

function SortEvent:ctor()
    self.event = {}
    self.nextLevel = {}
    self.funcid = 0
end

function SortEvent:sort()
    table.sort( self.event, function(a,b)
        return a.level > b.level
    end)
end

function SortEvent:addEvent(nfunc,lv)
    self.funcid = self.funcid + 1
    table.insert(self.event,{level = lv or 0,func = nfunc,id=self.funcid})
    self:sort()
    return self.funcid
end

function SortEvent:removeEvent(id)
    for i,v in ipairs(self.event) do
        if v.id == id then
            table.remove(self.event,i)
            break
        end
    end
end

function SortEvent:doEvent( ... )
    for i,v in ipairs(self.event) do
        if v.func(...) == false then
            return false
        end
    end
end

function SortEvent:getNextLevel(id)
    return self.nextLevel[id]
end

function SortEvent:createNextLevel(id)
    local ev = SortEvent.new()
    self.nextLevel[id] = ev
    return ev
end

local multiLevelEv = class("multiLevelEv")

function multiLevelEv:ctor()
    self.event = SortEvent.new()
end

function multiLevelEv:addEvent(evlist,func,lv)
    local ev = self.event
    for i,eid in ipairs(evlist) do
        local tmp = ev:getNextLevel(eid)
        if tmp == nil then
            tmp = ev:createNextLevel(eid)
        end
        ev = tmp
    end
    return ev:addEvent(func,lv)
end

function multiLevelEv:removeEvent(evlist,id)
    local ev = self.event
    for i,eid in ipairs(evlist) do
        local tmp = ev:getNextLevel(eid)
        if tmp == nil then
            tmp = ev:createNextLevel(eid)
        end
        ev = tmp
    end
    ev:removeEvent(id)
end

function multiLevelEv:doEvent(evlist,...)
    local ev = self.event
    for i,eid in ipairs(evlist) do
        local tmp = ev:getNextLevel(eid)
        if tmp == nil then
            return
        end
        ev = tmp  
    end
    return ev:doEvent(...)
end

function multiLevelEv:getEvents(evlist)
    local ev = self.event
    for i,eid in ipairs(evlist) do
        local tmp = ev:getNextLevel(eid)
        if tmp == nil then
            return
        end
        ev = tmp
    end
    return ev.event
end

return multiLevelEv