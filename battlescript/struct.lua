ObjectStruct = {}

STRUCT_ID = {
    TEST_PLY = 1,
    BUFF_DIZZY = 2,
    SKILL_PS_ANNI = 3,
    SKILL_ANNI_GEN_1 = 4,
    SKILL_ANNI_OBJ_1 = 5,
    BUFF_GEN_DIZZY = 6,

    SKILL_ANNI_GEN_2 = 7,
    SKILL_ANNI_OBJ_2 = 8,

    SKILL_ANNI_GEN_3 = 9,
    SKILL_ANNI_OBJ_3 = 10,

    LJ_SKILL_GEN_1 = 11,
    LJ_SKILL_OBJ_1 = 12,
    LJ_BUFF_POISON = 13,

    MS_SKILL_GEN_1 = 14,
    MS_S1_OBJ_BALL = 15,
    MS_S1_BUFF_BALL = 16,
    MS_S1_BUFF_MOVE = 17,
}

local S = ObjectStruct

S[STRUCT_ID.TEST_PLY] = {
    type = OBJ_TYPE.HERO,
}

S[STRUCT_ID.BUFF_DIZZY] = {
    type = OBJ_TYPE.BUFF,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.CPT_ListenSelf,
            listen = {
                {
                    listenEvent = 
                    {
                        {OBJ_EVENT.DO_APPEND_TO_OBJ},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_TRIGGER,2}
                    },
                },
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_BUFF,
            group = {
                {
                    EFFECT_TYPE.EFT_AttrEff,
                },
            },
        },
        {
            id = 3,
            bigtype = COMP_TYPE.TIME_CHECK_DESTROY,
            doEvent = {}
        },
        {
            id = 4,
            bigtype = COMP_TYPE.CPT_BuffRepRefresh,
        },
    },
}

S[STRUCT_ID.SKILL_PS_ANNI] = {
    type = OBJ_TYPE.SKILL,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.CPT_ListenObject,
            target = PAM_ATTR.OBJ_EFF_TAKER,
            listen = {
                {
                    listenEvent = {
                        {COMM_EVENT.AFTER_CONTROL},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_TRIGGER,2}
                    },
                },
                {
                    listenEvent = {
                        {
                            COMM_EVENT.AFTER_TRIGGER,
                            TRIGGER_TYPE.TRG_GEN_SKILL_OBJ,
                            COMM_EVENT.TRIGGER_MAKER
                        },
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_TRIGGER,3}
                    },
                },
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_BUFF,
            group = {
                {
                    EFFECT_TYPE.EFT_AddBuffLevel,
                },
            },
        },
        {
            id = 3,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_BUFF,
            group = {
                {
                    EFFECT_TYPE.EFT_CheckLevel,
                    EFFECT_TYPE.EFT_ObjectGen,
                    EFFECT_TYPE.EFT_AppendBuff,
                },
            },
        },
        {
            id = 4,
            bigtype = COMP_TYPE.CPT_ListenSelf,
            listen = {
                {
                    listenEvent = {
                        {OBJ_EVENT.DO_APPEND_TO_OBJ},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_LISTEN,1},
                    },
                },
            },
        },
    },
}

S[STRUCT_ID.SKILL_ANNI_GEN_1] = {
    type = OBJ_TYPE.SKILL,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.CONTROL,
            type = CONTROL_TYPE.CTL_CD,
            doEvent = {
                {OBJ_EVENT.DO_TRIGGER,2}
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_GEN_SKILL_OBJ,
            group = {
                {
                    EFFECT_TYPE.EFT_ObjectGen,
                },
            },
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_ListenSelf,
            listen = {
                {
                    listenEvent = {
                        {COMM_EVENT.BEFOR_CONTROL,1},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_CHECK_DISTANCE},
                        {OBJ_EVENT.DO_TRIGGER,4},
                    },
                },
            },
        },
        {
            id = 4,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_COST,
            group = {
                {
                    EFFECT_TYPE.EFT_CostEff
                },
            },
        },
        {
            id = 5,
            bigtype = COMP_TYPE.CPT_ChooseRangeCheck,
            distance = 300, --范围
        },
    },
}

S[STRUCT_ID.SKILL_ANNI_OBJ_1] = {
    type = OBJ_TYPE.SKILL,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.TRIGGER_AND_DESTROY_SELF,
            type = TRIGGER_TYPE.TRG_SKILL_DMG,
            group = {
                {
                    EFFECT_TYPE.EFT_RealDmg,
                },
                {
                    EFFECT_TYPE.EFT_CheckDiePassEff,
                    EFFECT_TYPE.EFT_RecoverEff,
                },
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.CPT_PosBornMaker,
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_DistanceCheck,
            distance = 10,
            doEvent = {
                {OBJ_EVENT.DO_OUTPUT_PARAM},
                {OBJ_EVENT.DO_TRIGGER,1},
            },
        },
        {
            id = 4,
            bigtype = COMP_TYPE.CPT_MoveComp,
        },
        {
            id = 5,
            bigtype = COMP_TYPE.CPT_TrackerFollowDestroy,
        },
        {
            id = 6,
            bigtype = COMP_TYPE.CPT_ListenSelf,
            listen = {
                {
                    listenEvent = {
                        {OBJ_EVENT.DO_EFF_GEN_SELF},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_BEGIN_TRACK}
                    },
                },
            },
        },
        {
            id = 7,
            bigtype = COMP_TYPE.CPT_ParamCollect,
            config = {
                {get=PAM_ATTR.OBJ_EFF_MAKER,set=PAM_ATTR.OBJ_EFF_MAKER},
                {get=PAM_ATTR.OBJ_EFF_TAKER,set=PAM_ATTR.OBJ_EFF_TAKER},
            },
        },
    },
}

S[STRUCT_ID.BUFF_GEN_DIZZY] = {
    type = OBJ_TYPE.BUFF,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.CPT_ListenObject,
            target = PAM_ATTR.OBJ_EFF_TAKER,
            listen = {
                {
                    listenEvent = {
                        {
                            COMM_EVENT.AFTER_TRIGGER,
                            TRIGGER_TYPE.TRG_SKILL_DMG,
                        },
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_TRIGGER,2}
                    },
                },
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_GEN_BUFF_OBJ,
            group = {
                {
                    EFFECT_TYPE.EFT_ObjectGen,
                    EFFECT_TYPE.EFT_AppendBuff,
                },
            },
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_ListenSelf,
            listen = {
                {
                    listenEvent = {
                        {OBJ_EVENT.DO_APPEND_TO_OBJ},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_LISTEN,1},
                    },
                },
            },
        },
    },
}

S[STRUCT_ID.SKILL_ANNI_GEN_2] = {
    type = OBJ_TYPE.SKILL,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.CONTROL,
            type = CONTROL_TYPE.CTL_CD,
            doEvent = {
                {OBJ_EVENT.DO_TRIGGER,2}
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_GEN_SKILL_OBJ,
            group = {
                {
                    EFFECT_TYPE.EFT_ObjectGen,
                },
            },
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_ListenSelf,
            listen = {
                {
                    listenEvent = {
                        {COMM_EVENT.BEFOR_CONTROL,1},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_TRIGGER,4}
                    },
                },
            },
        },
        {
            id = 4,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_COST,
            group = {
                {
                    EFFECT_TYPE.EFT_CostEff
                },
            },
        },
    }
}

S[STRUCT_ID.SKILL_ANNI_OBJ_2] = {
    type = OBJ_TYPE.SKILL,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_SKILL_DMG,
            group = {
                {
                    EFFECT_TYPE.EFT_RealDmg,
                },
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.CPT_PosBornMaker,
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_AttrMaker,
            config = {
                {attrfrom=PAM_ATTR.PMA_OBJ_SELF,attrid=OBJ_ATTR.OAT_DIR_X},
                {attrfrom=PAM_ATTR.PMA_OBJ_SELF,attrid=OBJ_ATTR.OAT_DIR_Y},
            },
        },
        {
            id = 4,
            bigtype = COMP_TYPE.CPT_ShapeSector,
            doEvent = {
                {OBJ_EVENT.DO_TRIGGER,1},
            },
            selector = SELECT_TYPE.SL_ALIVE_ENEMY,
            radii = 300,
            angle = 30,
            posmod = SHAPE_ATTR_MOD.SAM_FROM_SELF,
            dirmod = SHAPE_ATTR_MOD.SAM_FROM_SELF,
        },
        {
            id = 5,
            bigtype = COMP_TYPE.CPT_ListenSelf,
            listen = {
                {
                    listenEvent = {
                        {OBJ_EVENT.DO_EFF_GEN_SELF},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_SHAPE_TRIGGER,4},
                        {OBJ_EVENT.DO_DESTROY_SELF},
                    },
                },
            },
        },
    },
}

S[STRUCT_ID.SKILL_ANNI_GEN_3] = {
    type = OBJ_TYPE.SKILL,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.CONTROL,
            type = CONTROL_TYPE.CTL_CD,
            doEvent = {
                {OBJ_EVENT.DO_TRIGGER,2}
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_GEN_SKILL_OBJ,
            group = {
                {
                    EFFECT_TYPE.EFT_ObjectGen,
                },
            },
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_ListenSelf,
            listen = {
                {
                    listenEvent = {
                        {COMM_EVENT.BEFOR_CONTROL,1},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_TRIGGER,4}
                    },
                },
            },
        },
        {
            id = 4,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_COST,
            group = {
                {
                    EFFECT_TYPE.EFT_CostEff
                },
            },
        },
    }
}

S[STRUCT_ID.SKILL_ANNI_OBJ_3] = {
    type = OBJ_TYPE.BUFF,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_BUFF_DMG,
            group = {
                {
                    EFFECT_TYPE.EFT_RealDmg,
                },
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.CPT_ShapeCircle,
            doEvent = {
                {OBJ_EVENT.DO_TRIGGER,1},
            },
            selector = SELECT_TYPE.SL_ALIVE_ENEMY,
            radii = 300,
            posmod = SHAPE_ATTR_MOD.SAM_FROM_MAKER,
        },
        {
            id = 3,
            bigtype = COMP_TYPE.TIME_INTERVAL,
            doEvent = {
                {OBJ_EVENT.DO_SHAPE_TRIGGER,2},
            },
            interval = 900,
        },
    },
}

S[STRUCT_ID.LJ_SKILL_GEN_1] = {
    type = OBJ_TYPE.SKILL,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_COST,
            group = {
                {
                    EFFECT_TYPE.EFT_CostEff,
                },
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_GEN_BUFF_OBJ,
            group = {
                {
                    EFFECT_TYPE.EFT_ObjectGen,
                },
            },
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_SwitchComp,
        },
        {
            id = 4,
            bigtype = COMP_TYPE.TIME_INTERVAL,
            interval = 500,
            doEvent = {
                {OBJ_EVENT.DO_SWITCH_CHECK,9},
                {OBJ_EVENT.DO_OUTPUT_PARAM},
                {OBJ_EVENT.DO_TRIGGER,2},
            },
        },
        {
            id = 5,
            bigtype = COMP_TYPE.CPT_DelayTimeInterval,
            interval = 1000,
            doEvent = {
                {OBJ_EVENT.DO_SWITCH_CHECK,3},
                {OBJ_EVENT.DO_OUTPUT_PARAM},
                {OBJ_EVENT.DO_EVENT_BRANCH,6},
            },
        },
        {
            id = 6,
            bigtype = COMP_TYPE.CPT_EventBranch,
            eventCheck = {
                {OBJ_EVENT.DO_TRIGGER,1},
            },
            eventFalse = {
                {OBJ_EVENT.DO_CLOSE_CONTROL},
            },
            eventTrue = {
                {OBJ_EVENT.DO_SWITCH_OPEN,9},
            },
        },
        {
            id = 7,
            bigtype = COMP_TYPE.CONTROL,
            type = CONTROL_TYPE.CTL_SWITCH,
            openEvent = {
                {OBJ_EVENT.DO_SWITCH_OPEN,3}
            },
            closeEvent = {
                {OBJ_EVENT.DO_SWITCH_CLOSE,3},
                {OBJ_EVENT.DO_SWITCH_CLOSE,9},
            },
        },
        {
            id = 8,
            bigtype = COMP_TYPE.CPT_ParamCollect,
        },
        {
            id = 9,
            bigtype = COMP_TYPE.CPT_SwitchComp,
        },
    }
}

S[STRUCT_ID.LJ_SKILL_OBJ_1] = {
    type = OBJ_TYPE.SKILL,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_GEN_BUFF_OBJ,
            group = {
                {
                    EFFECT_TYPE.EFT_ObjectGen,
                    EFFECT_TYPE.EFT_AppendBuff,
                },
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.CPT_ShapeCircle,
            selector = SELECT_TYPE.SL_ALIVE_ENEMY,
            radii = 300,
            posmod = SHAPE_ATTR_MOD.SAM_FROM_MAKER,
            doEvent = {
                {OBJ_EVENT.DO_OUTPUT_PARAM},
                {OBJ_EVENT.DO_TRIGGER,1},
            },
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_PosBornMaker,
        },
        {
            id = 4,
            bigtype = COMP_TYPE.CPT_ParamCollect,
            config = {
                {get=PAM_ATTR.OBJ_EFF_MAKER,set=PAM_ATTR.OBJ_EFF_MAKER}
            },
        },
        {
            id = 5,
            bigtype = COMP_TYPE.TIME_INTERVAL,
            interval = 500,
            doEvent = {
                {OBJ_EVENT.DO_SHAPE_TRIGGER,2}
            },
        },
    }
}

S[STRUCT_ID.LJ_BUFF_POISON] = {
    type = OBJ_TYPE.BUFF,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_BUFF_DMG,
            group = {
                {
                    EFFECT_TYPE.EFT_RealDmg,
                },
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.CPT_ParamCollect,
            config = {
                {get=PAM_ATTR.OBJ_EFF_MAKER,set=PAM_ATTR.OBJ_EFF_MAKER},
                {get=PAM_ATTR.OBJ_EFF_TAKER,set=PAM_ATTR.OBJ_EFF_TAKER},
            },
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_DelayTimeInterval,
            interval = 1000,
            doEvent = {
                {OBJ_EVENT.DO_OUTPUT_PARAM},
                {OBJ_EVENT.DO_TRIGGER,1},
            },
        },
        {
            id = 4,
            bigtype = COMP_TYPE.CPT_BuffRepRefresh,
        },
    }
}

S[STRUCT_ID.MS_SKILL_GEN_1] = {
    type = OBJ_TYPE.SKILL,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.CONTROL,
            type = CONTROL_TYPE.CTL_GROUP,
            eventGroup = {
                {OBJ_EVENT.DO_CTL_SUB_CONTROL,2},
                {OBJ_EVENT.DO_CTL_SUB_CONTROL,3},
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.CONTROL,
            type = CONTROL_TYPE.CTL_SUB,
            doEvent = {
                {OBJ_EVENT.DO_MAKE_OBJECT,4},
            },
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CONTROL,
            type = CONTROL_TYPE.CTL_SUB,
            doEvent = {
                {OBJ_EVENT.DO_NOTICE_LISTEN,1}, -- 触发下面监听的
                {OBJ_EVENT.DO_CTL_JUMP_BEGIN,1},
            },
        },
        {
            id = 4,
            bigtype = COMP_TYPE.CPT_ObjectMaker,
            structid = STRUCT_ID.MS_S1_OBJ_BALL,
        },
        {
            id = 5,
            bigtype = COMP_TYPE.TRIGGER,
            type = TRIGGER_TYPE.TRG_COST,
            group = {
                {
                    EFFECT_TYPE.EFT_CostEff,
                },
            },
        },
        {
            id = 6,
            bigtype = COMP_TYPE.CPT_ListenSelf,
            listen = {
                {
                    listenEvent = {
                        {COMM_EVENT.BEFOR_CONTROL,2},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_TRIGGER,5},
                    },
                },
                {
                    listenEvent = {
                        {COMM_EVENT.BEFOR_CONTROL,3},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_TRIGGER,5},
                    },
                },
            },
        },
    },
}

S[STRUCT_ID.MS_S1_OBJ_BALL] = {
    type = OBJ_TYPE.SKILL,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.CPT_ParamCollect,
            config = {
                {get=PAM_ATTR.OBJ_EFF_MAKER,set=PAM_ATTR.OBJ_EFF_MAKER},
                {get=PAM_ATTR.PAT_HERO_SKILL,set=PAM_ATTR.PAT_HERO_SKILL},
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.CPT_PosBornMaker,
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_AttrMaker,
            config = {
                {attrfrom=PAM_ATTR.PMA_OBJ_SELF,attrid=OBJ_ATTR.OAT_DIR_X},
                {attrfrom=PAM_ATTR.PMA_OBJ_SELF,attrid=OBJ_ATTR.OAT_DIR_Y},
            },
        },
        {
            id = 4,
            bigtype = COMP_TYPE.CPT_MoveComp,
            length = 500,
        },
        {
            id = 5,
            bigtype = COMP_TYPE.CPT_ShapeCircle,
            selector = SELECT_TYPE.SL_ALIVE_ENEMY,
            radii = 30,
            posmod = SHAPE_ATTR_MOD.SAM_FROM_SELF,
            doEvent = {
                {OBJ_EVENT.DO_OUTPUT_PARAM},
                {OBJ_EVENT.DO_TRIGGER,6},
                {OBJ_EVENT.DO_EVENT_BRANCH,7},
            },
        },
        {
            id = 6,
            bigtype = COMP_TYPE.TRIGGER_AND_DESTROY_SELF,
            type = TRIGGER_TYPE.TRG_SKILL_DMG,
            group = {
                {
                    EFFECT_TYPE.EFT_RealDmg,
                },
            },
        },
        {
            id = 7,
            bigtype = COMP_TYPE.CPT_EventBranch,
            eventCheck = {
                {OBJ_EVENT.DO_FUNCTION,8},
            },
            eventFalse = {
                {OBJ_EVENT.DO_MAKE_OBJECT,9},
                {OBJ_EVENT.DO_APPEND_BUFF},
                {OBJ_EVENT.DO_TRIGGER_OBJ_EVENT,10},
                {OBJ_EVENT.DO_TRIGGER_OBJ_EVENT,11},
            },
        },
        {
            id = 8,
            bigtype = COMP_TYPE.CPT_FuncTrigger,
            group = {
                {
                    id = FUNC_ID.F_CHECK_DEAD,
                    val1 = PAM_ATTR.OBJ_EFF_TAKER,
                },
            },
        },
        {
            id = 9,
            bigtype = COMP_TYPE.CPT_ObjectMaker,
            structid = STRUCT_ID.MS_S1_BUFF_BALL,
            pamval = PAM_ATTR.NEW_OBJECT,
        },
        {
            id = 10,
            bigtype = COMP_TYPE.CPT_TriggerEvent,
            target = PAM_ATTR.NEW_OBJECT,
            doEvent = {
                {OBJ_EVENT.DO_LISTEN,4},
                {OBJ_EVENT.DO_LISTEN,5},
            },
        },
        {
            id = 11,
            bigtype = COMP_TYPE.CPT_TriggerEvent,
            target = PAM_ATTR.PAT_HERO_SKILL,
            doEvent = {
                {OBJ_EVENT.DO_CTL_JUMP_NEXT,1},
            },
        },
        {
            id = 12,
            bigtype = COMP_TYPE.CPT_UpdateEvent,
            doEvent = {
                {OBJ_EVENT.DO_OUTPUT_PARAM},
                {OBJ_EVENT.DO_SHAPE_TRIGGER,5},
            },
        },
        {
            id = 13,
            bigtype = COMP_TYPE.CPT_BuffAppend,
            buff = PAM_ATTR.NEW_OBJECT,
            target = PAM_ATTR.PAT_HERO_SKILL,
        },
    },
}

S[STRUCT_ID.MS_S1_BUFF_BALL] = {
    type = OBJ_TYPE.BUFF,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.CPT_ParamCollect,
            config = {
                {get=PAM_ATTR.OBJ_EFF_MAKER,set=PAM_ATTR.OBJ_EFF_MAKER},
                {get=PAM_ATTR.PAT_HERO_SKILL,set=PAM_ATTR.PAT_HERO_SKILL},
                {get=PAM_ATTR.OBJ_EFF_TAKER,set=PAM_ATTR.OBJ_EFF_TAKER},
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.TIME_CHECK_DESTROY,
            doEvent = {
                {OBJ_EVENT.DO_TRIGGER_OBJ_EVENT,3},
            },
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_TriggerEvent,
            target = PAM_ATTR.PAT_HERO_SKILL,
            doEvent = {
                {OBJ_EVENT.DO_CTL_JUMP_BEGIN,1},
            },
        },
        {
            id = 4,
            bigtype = COMP_TYPE.CPT_ListenObject,
            target = PAM_ATTR.PAT_HERO_SKILL,
            listen = {
                {
                    listenEvent = {
                        {OBJ_EVENT.DO_NOTICE_LISTEN,1},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_OUTPUT_PARAM},
                        {OBJ_EVENT.DO_CHECK_DISTANCE},
                        {OBJ_EVENT.DO_MAKE_OBJECT,7},
                        {OBJ_EVENT.DO_APPEND_BUFF},
                        {OBJ_EVENT.DO_TRIGGER_OBJ_EVENT,10},
                        {OBJ_EVENT.DO_DESTROY_SELF},
                    },
                },
            },
        },
        {
            id = 5,
            bigtype = COMP_TYPE.CPT_ListenObject,
            target = PAM_ATTR.OBJ_EFF_TAKER,
            listen = {
                {
                    listenEvent = {
                        {OBJ_EVENT.DO_OBJECT_DEAD},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_TRIGGER_OBJ_EVENT,3},
                        {OBJ_EVENT.DO_DESTROY_SELF},
                    },
                },
            },
        },
        {
            id = 6,
            bigtype = COMP_TYPE.CPT_ChooseRangeCheck,
            distance = 500,
        },
        {
            id = 7,
            bigtype = COMP_TYPE.CPT_ObjectMaker,
            structid = STRUCT_ID.MS_S1_BUFF_MOVE,
            pamval = PAM_ATTR.NEW_OBJECT,
        },
        {
            id = 8,
            bigtype = COMP_TYPE.CPT_BuffRepReplace,
        },
        {
            id = 9,
            bigtype = COMP_TYPE.CPT_BuffAppend,
            buff = PAM_ATTR.NEW_OBJECT,
            target = PAM_ATTR.OBJ_EFF_MAKER,
        },
        {
            id = 10,
            bigtype = COMP_TYPE.CPT_TriggerEvent,
            target = PAM_ATTR.NEW_OBJECT,
            doEvent = {
                {OBJ_EVENT.DO_NOTICE_LISTEN,1},
            },
        },
    },
}

S[STRUCT_ID.MS_S1_BUFF_MOVE] = {
    type = OBJ_TYPE.BUFF,
    comps = {
        {
            id = 1,
            bigtype = COMP_TYPE.CPT_ParamCollect,
            config = {
                {get=PAM_ATTR.OBJ_EFF_MAKER,set=PAM_ATTR.OBJ_EFF_MAKER},
                {get=PAM_ATTR.PAT_HERO_SKILL,set=PAM_ATTR.PAT_HERO_SKILL},
                {get=PAM_ATTR.OBJ_EFF_TAKER,set=PAM_ATTR.OBJ_EFF_TAKER},
            },
        },
        {
            id = 2,
            bigtype = COMP_TYPE.CPT_MoveTarget,
            target = PAM_ATTR.OBJ_EFF_MAKER,
        },
        {
            id = 3,
            bigtype = COMP_TYPE.CPT_TrackerLastPosition,
            tracker = PAM_ATTR.OBJ_EFF_MAKER,
        },
        {
            id = 4,
            bigtype = COMP_TYPE.CPT_ListenSelf,
            listen = {
                {
                    listenEvent = {
                        {OBJ_EVENT.DO_NOTICE_LISTEN,1},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_LISTEN,5},
                        {OBJ_EVENT.DO_BEGIN_TRACK},
                    },
                },
            },
        },
        {
            id = 5,
            bigtype = COMP_TYPE.CPT_ListenObject,
            target = PAM_ATTR.OBJ_EFF_MAKER,
            listen = {
                {
                    listenEvent = {
                        {OBJ_EVENT.DO_MOVE_TARGET_DESTROY},
                    },
                    doEvent = {
                        {OBJ_EVENT.DO_MOVE_TARGET_DESTROY},
                    },
                },
            },
        },
        {
            id = 6,
            bigtype = COMP_TYPE.CPT_DistanceCheck,
            distance = 30,
            target = PAM_ATTR.OBJ_EFF_TAKER,
            checker = PAM_ATTR.OBJ_EFF_MAKER,
            doEvent = {
                {OBJ_EVENT.DO_OUTPUT_PARAM},
                {OBJ_EVENT.DO_TRIGGER,7},
            },
        },
        {
            id = 7,
            bigtype = COMP_TYPE.TRIGGER_AND_DESTROY_SELF,
            type = TRIGGER_TYPE.TRG_SKILL_DMG,
            group = {
                {
                    EFFECT_TYPE.EFT_RealDmg,
                },
            },
        },
        {
            id = 8,
            bigtype = COMP_TYPE.CPT_BuffRepReplace,
        },
    },
}