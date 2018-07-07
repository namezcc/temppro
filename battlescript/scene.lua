Scene = class("Scene")

function Scene:ctor()
    self.entitys = {}
    self.destroyTable = {}
    self.tmplist = {}
    self.lastStamp = Time.GetMillionSecond()
end

function Scene:addEntity(ent)
    if self.entitys[ent.type] == nil then
        self.entitys[ent.type] = {}
    end
    if ent.scene == nil then
        ent.scene = self
    end
    self.entitys[ent.type][ent.id] = ent
end

function Scene:pushNewObject(obj)
    obj.scene = self
    table.insert(self.tmplist,obj)
end

function Scene:tmpToScene()
    if #self.tmplist ==0 then
        return
    end
    for i,v in ipairs(self.tmplist) do
        self:addEntity(v)
    end
    self.tmplist = {}
end

function Scene:update(stamp)
    for k,v in pairs(self.entitys) do
        for id,obj in pairs(v) do
            if obj:getAttr(COMM_ATTR.CAT_DESTROY) then
                self:addDestroy(obj)
            else
                obj:update(stamp)
            end
        end
    end
    self:tmpToScene()
    self:destroyUpdate()
    self.lastStamp = stamp
end

function Scene:addDestroy(obj)
    table.insert(self.destroyTable,{type=obj.type,id=obj.id})
end

function Scene:destroyUpdate()
    if #self.destroyTable == 0 then
        return
    end
    for i,v in ipairs(self.destroyTable) do
        local obj = self.entitys[v.type][v.id]
        self.entitys[v.type][v.id] = nil
        obj:destroy()
        obj.scene = nil
    end
    self.destroyTable = {}
end

function Scene:getObjectByType(type,func)
    if self.entitys[type] then
        for k,v in pairs(self.entitys[type]) do
            func(v)
        end
    end
end

function Scene:selectObject(type,obj,slfunc)
    local func = SELECT_FUNC[type]
    if func then
        func(self,obj,slfunc)
    end
end