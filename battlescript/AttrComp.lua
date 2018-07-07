local ATTR_CHANGE_FUNC = {
    
}

AttrComp = class("AttrComp")

function AttrComp:ctor(attrs,id)
    self.id = id or 0
    self.attrs = table.clone(attrs) or {}
    self.finalAttr = table.clone(attrs) or {}
    self.childComp = {}
    self.parentComp = {}
    self.attrChange = {}

    if attrs then
        for k,v in pairs(attrs) do
            self.attrChange[k] = 0
        end
    end
    self:doAttrChangeFunc()
end

function AttrComp:doAttrChangeFunc()
    for k,v in pairs(self.attrChange) do
        if ATTR_CHANGE_FUNC[k] then
            ATTR_CHANGE_FUNC[k](self)
        end
    end
end

function AttrComp:addComp(comp)
    if self.childComp[comp.id] then
        self.childComp[comp.id]:remSelfComp(self)
    end

    self.childComp[comp.id] = comp
    comp.parentComp[self.id] = self

    local par = self:getRoots()
    for k,v in pairs(par) do
        v:onAddAttr(comp.attrs)
    end
end

function AttrComp:appendAttr(attr)
    local comp = AttrComp.new(attr,GenTmpObjectID())
    self:addComp(comp)
    return comp
end

function AttrComp:remSelfComp(parent)
    if table.getn(self.parentComp) == 0 then
        return
    end

    if parent then
        self:sendRemAttr(parent)
        parent.childComp[self.id] = nil
    else
        local roots = self:getRoots()
        for k,v in pairs(roots) do
            self:sendRemAttr(v)
        end
        for k,v in pairs(self.parentComp) do
            v.childComp[self.id] = nil
        end
    end
    self.parentComp = {}
end

function AttrComp:getFinalAttr(attrid)
    return self.finalAttr[attrid]
end

function AttrComp:addFinalAttr(id,val)
    if self.attrChange[id] == nil then
        self.attrChange[id] = self.finalAttr[id] or 0
    end
    if self.finalAttr[id] then
        self.finalAttr[id] = self.finalAttr[id] + val
    else
        self.finalAttr[id] = val    
    end
end

function AttrComp:setFinalAttr(id,val)
    if self.attrChange[id] == nil then
        self.attrChange[id] = self.finalAttr[id] or 0
    end
    self.finalAttr[id] = val
end

function AttrComp:updateAttr(id,val)
    local roots = self:getRoots()
    for k,v in pairs(roots) do
        v:onUpdateAttr(id,self.attrs[id],val)
    end
    self.attrs[id] = val
end

function AttrComp:sendRemAttr(root)
    root:onRemAttr(self.attrs)
    if table.getn(self.childComp) > 0 then
        for k,v in pairs(self.childComp) do
            v:sendRemAttr(root)
        end
    end
end

function AttrComp:sendAddAttr(root)
    root:onAddAttr(self.attrs)
    if table.getn(self.childComp) > 0 then
        for k,v in pairs(self.childComp) do
            v:sendAddAttr(root)
        end
    end
end

function AttrComp:getRoots(res)
    local r = false
    if res == nil then
        res = {}
        r = true
    end
    if table.getn(self.parentComp) == 0 then
        res[self.id] = self
        if r then
            return res
        else
            return
        end
    end
    for k,v in pairs(self.parentComp) do
        v:getRoots(res) 
    end
    if r then
        return res
    end
end

function AttrComp:onAddAttr(attrs)
    for k,v in pairs(attrs) do
        if type(v) == "table" then
            self.finalAttr[k] = v
        else
            if self.attrChange[k] == nil then
                self.attrChange[k] = self.finalAttr[k] or 0
            end
            if self.finalAttr[k] then
                self.finalAttr[k] = self.finalAttr[k] + v
            else
                self.finalAttr[k] = v
            end
        end
    end
end

function AttrComp:onRemAttr(attrs)
    for k,v in pairs(attrs) do
        if type(v) == "table" then
            self.finalAttr[k] = nil
        else
            if self.attrChange[k] == nil then
                self.attrChange[k] = self.finalAttr[k]
            end
            if self.finalAttr[k] then
                self.finalAttr[k] = self.finalAttr[k] - v
            end
        end
    end
end

function AttrComp:onUpdateAttr(id,oldval,newval)
    if self.finalAttr[id] == nil then
        self.finalAttr[id] = newval
        return
    end
    if self.attrChange[id] == nil then
        self.attrChange[id] = self.finalAttr[id]
    end
    self.finalAttr[id] = self.finalAttr[id] - oldval + newval;
end

function AttrComp:showAttrs()
    print(persent.block(self.finalAttr))
end

function AttrComp:clearChange()
    self.attrChange = {}
end

function AttrComp:showChnages()
    for k,v in pairs(self.attrChange) do
        print(k,v,self.finalAttr[k])
    end
    self:clearChange()
end

function AttrComp:calcAttrs()
    self.finalAttr = {}
    self:sendAddAttr(self)
    self:doAttrChangeFunc()
end