CreateCompTable = {}

local C = CreateCompTable

C[COMP_TYPE.CONTROL] = function(cfg)
    return CreateControl(cfg)
end

C[COMP_TYPE.TRIGGER] = function(cfg)
    return CreateTrigger(cfg)
end

C[COMP_TYPE.TRIGGER_AND_DESTROY_SELF] = function(cfg)
    return CreateTrigger(cfg)
end

C[COMP_TYPE.CPT_ListenSelf] = function(cfg)
    return ListenSelf.new(cfg)
end

C[COMP_TYPE.CPT_ListenObject] = function(cfg)
    return ListenObject.new(cfg)
end

C[COMP_TYPE.FOLLOW_DESTROY] = function(cfg)
    return FollowDestroy.new(cfg.id,cfg.bigtype)
end

C[COMP_TYPE.EVENT_DESTROY] = function(cfg)
    return EventDestroy.new(cfg,cfg.id,cfg.bigtype)
end

C[COMP_TYPE.TIME_CHECK] = function(cfg)
    return TimeCheck.new(cfg,cfg.id,cfg.bigtype)
end

C[COMP_TYPE.TIME_INTERVAL] = function(cfg)
    return TimeInterval.new(cfg,cfg.id,cfg.bigtype)
end

C[COMP_TYPE.TIME_CHECK_DESTROY] = function(cfg)
    return TimeCheckDestroy.new(cfg,cfg.id,cfg.bigtype)
end

C[COMP_TYPE.CPT_ChooseRangeCheck] = function(cfg)
    return ChooseRangeCheck.new(cfg,cfg.id,cfg.bigtype)
end

C[COMP_TYPE.CPT_DistanceCheck] = function(cfg)
    return DistanceCheck.new(cfg,cfg.id,cfg.bigtype)
end

C[COMP_TYPE.CPT_MoveComp] = function(cfg)
    return MoveComp.new(cfg)
end

C[COMP_TYPE.CPT_PosBornMaker] = function(cfg)
    return PosBornMaker.new(cfg.id,cfg.bigtype)
end

C[COMP_TYPE.CPT_TrackerFollowDestroy] = function(cfg)
    return TrackerFollowDestroy.new(cfg)
end

C[COMP_TYPE.CPT_BuffRepRefresh] = function(cfg)
    return BuffRepRefresh.new(cfg.id,cfg.bigtype)
end

C[COMP_TYPE.CPT_BuffRepReplace] = function(cfg)
    return BuffRepReplace.new(cfg.id,cfg.bigtype)
end

C[COMP_TYPE.CPT_ShapeSector] = function(cfg)
    return ShapeSector.new(cfg)
end

C[COMP_TYPE.CPT_AttrMaker] = function(cfg)
    return AttrMaker.new(cfg)
end

C[COMP_TYPE.CPT_ShapeCircle] = function(cfg)
    return ShapeCircle.new(cfg)
end

C[COMP_TYPE.CPT_SwitchComp] = function(cfg)
    return SwitchComp.new(cfg)
end

C[COMP_TYPE.CPT_DelayTimeInterval] = function(cfg)
    return DelayTimeInterval.new(cfg)
end

C[COMP_TYPE.CPT_EventBranch] = function(cfg)
    return EventBranch.new(cfg)
end

C[COMP_TYPE.CPT_ParamCollect] = function(cfg)
    return ParamCollect.new(cfg)
end

C[COMP_TYPE.CPT_MoveTarget] = function(cfg)
    return MoveTarget.new(cfg)
end

C[COMP_TYPE.CPT_ObjectMaker] = function(cfg)
    return ObjectMaker.new(cfg)
end

C[COMP_TYPE.CPT_TriggerEvent] = function(cfg)
    return TriggerEvent.new(cfg)
end

C[COMP_TYPE.CPT_FuncTrigger] = function(cfg)
    return FuncTrigger.new(cfg)
end

C[COMP_TYPE.CPT_TrackerLastPosition] = function(cfg)
    return TrackerLastPosition.new(cfg)
end

C[COMP_TYPE.CPT_UpdateEvent] = function(cfg)
    return UpdateEvent.new(cfg)
end

C[COMP_TYPE.CPT_BuffAppend] = function(cfg)
    return BuffAppend.new(cfg)
end
