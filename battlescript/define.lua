local function DefBeganWith(tab,num)
    for k,v in pairs(tab) do
        tab[k] = num + v
    end
end

local BEG_PAM_ATTR = 0
local BEG_OBJ_ATTR = 1000
local BEG_EFF_ATTR = 2000
local BEG_BUFF_ATTR = 3000
local BEG_SKILL_ATTR = 4000
local BEG_OBJ_TYPE = 5000
local BEG_SKILL_TYPE = 6000
local BEG_ATTR_CHANGE_TYPE = 7000
local BEG_COMP_TYPE = 8000
local BEG_CONTROL_TYPE = 9000
local BEG_TRIGGER_TYPE = 10000
local BEG_EFFECT_TYPE = 11000
local BEG_OBJ_STATE_TYPE = 12000
local BEG_OBJ_EVENT = 13000
local BEG_COMM_EVENT = 14000
local BEG_COMM_ATTR = 15000


PAM_ATTR = {
    OBJ_EFF_MAKER = 1,
    OBJ_EFF_TAKER = 2,
    PMA_OBJ_SELF = 3,
    --OBJECT_ATTR   = 4,
    NEW_OBJECT    = 5,
    --OBJECT_ID     = 6,
    PAT_HERO_SKILL = 7,
    NEW_OBJECT2   = 8,
    NEW_OBJECT3   = 9,
    APPEND_OBJ    = 10,
}
DefBeganWith(PAM_ATTR,BEG_PAM_ATTR)
-----------------------------------------------
OBJ_TYPE = {
    HERO = 1,
    SKILL = 2,
    BUFF = 3,
}
DefBeganWith(OBJ_TYPE,BEG_OBJ_TYPE)
-----------------------------------------------
OBJ_ATTR = {
    ATK_POWER = 1,
    MAGIC_POWER = 2,
    HP = 3,
    MP = 4,
    MAX_HP = 5,
    MAX_MP = 6,
    OBJ_STATE = 7,
    OAT_SPEED = 8,
    OAT_POS_X = 9,
    OAT_POS_Y = 10,
    OAT_DIR_X = 11,
    OAT_DIR_Y = 12,
    OAT_MDIR_X = 13,
    OAT_MDIR_Y = 14,
    OAT_LAST_UPDATE_STAMP = 15,
    OAT_CAMP = 16,
}
DefBeganWith(OBJ_ATTR,BEG_OBJ_ATTR)
-----------------------------------------------
EFF_ATTR = {
    VAL1 = 1,
    VAL2 = 2,
    VAL3 = 3,
    VAL4 = 4,
    VAL5 = 5,
}
DefBeganWith(EFF_ATTR,BEG_EFF_ATTR)
-----------------------------------------------
BUFF_ATTR = {
    LEVEL = 1,
    MAX_LEVEL = 2,
    ATTR_COMP = 3,
}
DefBeganWith(BUFF_ATTR,BEG_BUFF_ATTR)
-----------------------------------------------
SKILL_ATTR = {
    TYPE = 1,
}
DefBeganWith(SKILL_ATTR,BEG_SKILL_ATTR)
-----------------------------------------------
SKILL_TYPE = {
    DMG = 1,
    GOOD = 2,
    BAD = 3,
    OBJ = 4,
}
DefBeganWith(SKILL_TYPE,BEG_SKILL_TYPE)
-----------------------------------------------
ATTR_CHANGE_TYPE = {
    PLUS = 1,
    MINUS = 2,
}
DefBeganWith(ATTR_CHANGE_TYPE,BEG_ATTR_CHANGE_TYPE)
-----------------------------------------------
OBJ_EVENT = {
    DO_CONTROL = 1,
    DO_TRIGGER = 2,
    DO_LISTEN  = 3,
    DO_CHECK   = 4,
    DO_UPDATE  = 5,
    DO_APPEND_TO_OBJ = 6,
    DO_DESTROY_SELF = 7,
    DO_BEGIN_TRACK = 8,
    DO_EFF_GEN_SELF = 9,
    DO_BUFF_REPEAT = 10,
    DO_SHAPE_TRIGGER = 11,
    DO_EVENT_BRANCH = 12,
    DO_OPEN_CONTROL = 13,
    DO_CLOSE_CONTROL = 14,
    DO_SWITCH_CHECK = 15,
    DO_SWITCH_OPEN = 16,
    DO_SWITCH_CLOSE = 17,
    DO_OUTPUT_PARAM = 18,
    DO_INPUT_PARAM = 19,

    DO_CTL_JUMP_NEXT = 20,
    DO_CTL_JUMP_BEGIN = 21,

    DO_CTL_SUB_CONTROL = 22,

    DO_MOVE_TARGET_DESTROY = 23,

    DO_MAKE_OBJECT = 24,

    DO_TRIGGER_OBJ_EVENT = 25,
    DO_FUNCTION = 26,
    DO_CHECK_DISTANCE = 27,

    DO_NOTICE_LISTEN = 28,

    DO_OBJECT_DEAD = 29,

    DO_APPEND_BUFF = 30,

    DO_CTL_JUMP_INDEX = 31,
}
DefBeganWith(OBJ_EVENT,BEG_OBJ_EVENT)
-----------------------------------------------
COMM_EVENT = {
    BEFOR_TRIGGER = 1,
    AFTER_TRIGGER = 2,
    BEFOR_CHANGE_ATTR = 3,
    AFTER_CHANGE_ATTR = 4,
    ATTR_MAKER = 5,
    ATTR_TAKER = 6,
    TRIGGER_MAKER = 7,
    TRIGGER_TAKER = 8,
    BEFOR_CONTROL = 9,
    AFTER_CONTROL = 10,
    BEFOR_DESTROY = 11,
}
DefBeganWith(COMM_EVENT,BEG_COMM_EVENT)
-----------------------------------------------
COMP_TYPE = {
    CONTROL = 1,
    TRIGGER = 2,
    CPT_ListenSelf = 3,
    FOLLOW_DESTROY = 4,
    EVENT_DESTROY = 5,
    TIME_CHECK = 6,
    TIME_INTERVAL = 7,
    TIME_CHECK_DESTROY = 8,
    TRIGGER_AND_DESTROY_SELF = 9,
    CPT_ChooseRangeCheck = 10,
    CPT_DistanceCheck = 11,
    CPT_MoveComp = 12,
    CPT_PosBornMaker = 13,
    CPT_TrackerFollowDestroy = 14,
    CPT_BuffRepRefresh = 15,
    CPT_BuffRepReplace= 16,
    CPT_ShapeSector = 17,
    CPT_AttrMaker = 18,
    CPT_ShapeCircle = 19,
    CPT_SwitchComp = 20,
    CPT_DelayTimeInterval = 21,
    CPT_EventBranch = 22,
    CPT_ParamCollect = 23,
    CPT_ListenObject = 24,
    CPT_MoveTarget = 25,
    CPT_ObjectMaker = 26,
    CPT_TriggerEvent = 27,
    CPT_FuncTrigger = 28,
    CPT_TrackerLastPosition = 29,
    CPT_UpdateEvent = 30,
    CPT_BuffAppend = 31,
}
DefBeganWith(COMP_TYPE,BEG_COMP_TYPE)
-----------------------------------------------
COMM_ATTR = {
    CAT_ATTR_CFG_ID = 1,
    CAT_STRUCT_ID = 2,
    CAT_LEVEL = 3,
    CAT_DESTROY = 4,
    CAT_CHECK_INTERVAL = 5,
    CAT_CHECK_TIME = 6,
    CAT_BEEN_DESTROY = 7,
    CAT_CONTROL_CD = 8,
    CAT_MAKE_LEVEL = 9,
}
DefBeganWith(COMM_ATTR,BEG_COMM_ATTR)
-----------------------------------------------
CONTROL_TYPE = {
    CTL_CD = 1,
    CTL_SWITCH = 2,
    CTL_GROUP = 3,
    CTL_SUB = 4,
}
DefBeganWith(CONTROL_TYPE,BEG_CONTROL_TYPE)
-----------------------------------------------
TRIGGER_TYPE = {
    TRG_NORATK = 1,
    TRG_SKILL_DMG = 2,
    TRG_BUFF = 3,
    TRG_GEN_SKILL_OBJ = 4,
    TRG_EVENT = 5,
    TRG_GEN_BUFF_OBJ = 6,
    TRG_COST = 7,
    TRG_RECOVER = 8,
    TRG_BUFF_DMG = 9,
}
DefBeganWith(TRIGGER_TYPE,BEG_TRIGGER_TYPE)
-----------------------------------------------
EFFECT_TYPE = {
    EFT_RealDmg = 1,
    EFT_ObjectGen = 2,
    EFT_AppendBuff = 3,
    EFT_AddBuffLevel = 4,
    EFT_CheckLevel = 5,
    EFT_AttrEff = 6,
    EFT_EventEff = 7,
    EFT_CostEff = 8,
    EFT_RecoverEff = 9,
    EFT_CheckDiePassEff = 10,
}
DefBeganWith(EFFECT_TYPE,BEG_EFFECT_TYPE)
-----------------------------------------------
OBJ_STATE_TYPE = {
    DIZZY = 1,  --眩晕
}
DefBeganWith(OBJ_STATE_TYPE,BEG_OBJ_STATE_TYPE)
-----------------------------------------------
EVENT_LEVEL = {
    LEVEL_1 = 1,
    LEVEL_2 = 2,
    LEVEL_3 = 3,
    LEVEL_4 = 4,
    LEVEL_5 = 5,
    LEVEL_6 = 6,
    LEVEL_7 = 7,
    LEVEL_8 = 8,
    LEVEL_9 = 9,
    LEVEL_10 = 10,
}

ACTION_STATE = {
    ACT_NO_MOVE = 1,
    ACT_NO_USE_SKILL = 2,
    ACT_NO_NOR_ATK = 3,     --普攻
    ACT_NO_EFFECT = 4,    --能否被作用
    ACT_NO_CONTROL = 5,
}
-- 状态不能
OBJ_STATE_TO_ACT_STATE = {
    [OBJ_STATE_TYPE.DIZZY] = {
        ACTION_STATE.ACT_NO_CONTROL,
        ACTION_STATE.ACT_NO_NOR_ATK,
        ACTION_STATE.ACT_NO_USE_SKILL,
    },
}
local OSTAS = OBJ_STATE_TO_ACT_STATE
OBJ_STATE_TO_ACT_STATE = {}
-- 初始化状态
for st,v in pairs(OSTAS) do
    local s = 0
    for i,idx in ipairs(v) do
        Mbit.setbit(s,idx,true)
    end
    OBJ_STATE_TO_ACT_STATE[st] = s
end

CAMP_TYPE = {
    CMP_RED = 1,
    CMP_BLUE = 2,
    CMP_WILD = 3,
}

SHAPE_ATTR_MOD = {
    SAM_FROM_SELF = 1,
    SAM_FROM_MAKER = 2,
}