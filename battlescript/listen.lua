ListenComp = class("ListenComp",Object)
function ListenComp:ctor(cfg)
    ListenComp.super.ctor(self,cfg.id,cfg.bigtype)
    self.listen = cfg.listen
    self.removeList = {}
end

function ListenComp:destroy()
    for i,v in ipairs(self.removeList) do
        v.object:removeEvent(v.events,v.id)
    end
    self.removeList = nil
    self.listen = nil
end

function ListenComp:listenEvent(obj)
    for i,v in ipairs(self.listen) do
        for k,lev in ipairs(v.listenEvent) do
            local lid = obj:addEvent(lev,function( ... )
                for k,ev in ipairs(v.doEvent) do
                    if self.comp:doEvent(ev,...) == false then
                        return false
                    end
                end
            end)
            table.insert(self.removeList,{events=lev,object=obj,id=lid})
        end
    end
end

ListenSelf = class("ListenSelf",ListenComp)
function ListenSelf:onAddtoComp(comp)
    self.comp = comp
    self:listenEvent(comp)
end

ListenObject = class("ListenObject",ListenComp)
function ListenObject:ctor(cfg)
    ListenObject.super.ctor(self,cfg)
    self.target = cfg.target
end

function ListenObject:onAddtoComp(comp)
    self.comp = comp
    comp:addEvent({OBJ_EVENT.DO_LISTEN,self.id},function(pam)
        local obj = pam:getParam(self.target)
        self:listenEvent(obj)
    end)
end