AttrTable = {}

ATTR_CONF_ID = {
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

require "Attr_ms"

local t = AttrTable

t[ATTR_CONF_ID.TEST_PLY] = {
    [1] = {
        attr = {
            [OBJ_ATTR.MAX_HP] = 90,
            [OBJ_ATTR.MAX_MP] = 100,
        },
    },
    [2] = {
        attr = {
            [OBJ_ATTR.MAX_HP] = 200,
            [OBJ_ATTR.MAX_MP] = 200,
        },
    },
    [3] = {
        attr = {
            [OBJ_ATTR.MAX_HP] = 300,
            [OBJ_ATTR.MAX_MP] = 300,
        },
    },
}

t[ATTR_CONF_ID.BUFF_DIZZY] = {
    [1] = {
        comps = {
            {
                id = 2,
                attr = {
                    group = {
                        [1] = {
                            [1] = {
                                [OBJ_ATTR.OBJ_STATE] = OBJ_STATE_TYPE.DIZZY,
                            },
                        },
                    },
                },
            },
            {
                id = 3,
                attr = {
                    [COMM_ATTR.CAT_CHECK_TIME] = 1500,  --1.5秒
                },
            },
        },
    },
}

t[ATTR_CONF_ID.BUFF_GEN_DIZZY] = {
    [1] = {
        comps = {
            {
                id = 2,
                attr = {
                    group = {
                        [1] = {
                            [1] = {
                                [EFF_ATTR.VAL1] = STRUCT_ID.BUFF_DIZZY,
                                [EFF_ATTR.VAL2] = ATTR_CONF_ID.BUFF_DIZZY,
                                [EFF_ATTR.VAL3] = 1,    --等级
                                [EFF_ATTR.VAL4] = PAM_ATTR.APPEND_OBJ,
                            },
                            [2] = {
                                [EFF_ATTR.VAL1] = PAM_ATTR.APPEND_OBJ,
                                [EFF_ATTR.VAL2] = PAM_ATTR.OBJ_EFF_TAKER,
                            },
                        },
                    },
                },
            },
        },
    },
}

t[ATTR_CONF_ID.SKILL_PS_ANNI] = {
    [1] = {
        attr = {
            [BUFF_ATTR.LEVEL] = 0,
            [BUFF_ATTR.MAX_LEVEL] = 1,
        },
        comps = {
            {
                id = 3,
                attr = {
                    group = {
                        [1] = {
                            [1] = {
                                [EFF_ATTR.VAL1] = PAM_ATTR.NEW_OBJECT,
                            },
                            [2] = {
                                [EFF_ATTR.VAL1] = STRUCT_ID.BUFF_GEN_DIZZY,
                                [EFF_ATTR.VAL2] = ATTR_CONF_ID.BUFF_GEN_DIZZY,
                                [EFF_ATTR.VAL3] = 1,    --等级
                                [EFF_ATTR.VAL4] = PAM_ATTR.APPEND_OBJ,
                            },
                            [3] = {
                                [EFF_ATTR.VAL1] = PAM_ATTR.APPEND_OBJ,
                                [EFF_ATTR.VAL2] = PAM_ATTR.NEW_OBJECT,
                            },
                        },
                    },
                },
            },
        },
    },
}

t[ATTR_CONF_ID.SKILL_ANNI_GEN_1] = {
    [1] = {
        attr = {
            [SKILL_ATTR.TYPE] = SKILL_TYPE.DMG,
        },
        comps = {
            {
                id = 1,
                attr = {
                    [COMM_ATTR.CAT_CONTROL_CD] = 1000,
                },
            },
            {
                id = 2,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = STRUCT_ID.SKILL_ANNI_OBJ_1,
                                [EFF_ATTR.VAL2] = ATTR_CONF_ID.SKILL_ANNI_OBJ_1,
                                [EFF_ATTR.VAL3] = 1,    --等级
                                [EFF_ATTR.VAL4] = PAM_ATTR.NEW_OBJECT,
                            },
                        },
                    },
                },
            },
            {
                id = 5,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = OBJ_ATTR.MP,
                                [EFF_ATTR.VAL2] = 10,
                            },
                        },
                    },
                },
            },
        },
    },
}

t[ATTR_CONF_ID.SKILL_ANNI_OBJ_1] = {
    [1] = {
        attr = {
            [SKILL_ATTR.TYPE] = SKILL_TYPE.DMG,
            [OBJ_ATTR.OAT_SPEED] = 250,
        },
        comps = {
            {
                id = 1,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = 30,
                            },
                        },
                        {
                            {
                                [EFF_ATTR.VAL1] = PAM_ATTR.OBJ_EFF_TAKER,
                            },
                            {
                                [EFF_ATTR.VAL1] = OBJ_ATTR.MP,
                                [EFF_ATTR.VAL2] = 10,
                            },
                        },
                    },
                },
            },
        },
    },
}

t[ATTR_CONF_ID.SKILL_ANNI_GEN_2] = {
    [1] = {
        attr = {
            [SKILL_ATTR.TYPE] = SKILL_TYPE.DMG,
        },
        comps = {
            {
                id = 1,
                attr = {
                    [COMM_ATTR.CAT_CONTROL_CD] = 1000,
                },
            },
            {
                id = 2,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = STRUCT_ID.SKILL_ANNI_OBJ_2,
                                [EFF_ATTR.VAL2] = ATTR_CONF_ID.SKILL_ANNI_OBJ_2,
                                [EFF_ATTR.VAL3] = 1,    --等级
                                [EFF_ATTR.VAL4] = PAM_ATTR.NEW_OBJECT,
                            },
                        },
                    },
                },
            },
            {
                id = 5,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = OBJ_ATTR.MP,
                                [EFF_ATTR.VAL2] = 20,
                            },
                        },
                    },
                },
            },
        },
    },
}

t[ATTR_CONF_ID.SKILL_ANNI_OBJ_2] = {
    [1] = {
        attr = {
            [SKILL_ATTR.TYPE] = SKILL_TYPE.DMG,
        },
        comps = {
            {
                id = 1,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = 50,
                            }
                        },
                    },
                },
            },
        },
    },
}

t[ATTR_CONF_ID.SKILL_ANNI_GEN_3] = {
    [1] = {
        attr = {
            [SKILL_ATTR.TYPE] = SKILL_TYPE.DMG,
        },
        comps = {
            {
                id = 1,
                attr = {
                    [COMM_ATTR.CAT_CONTROL_CD] = 1000,
                },
            },
            {
                id = 2,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = STRUCT_ID.SKILL_ANNI_OBJ_3,
                                [EFF_ATTR.VAL2] = ATTR_CONF_ID.SKILL_ANNI_OBJ_3,
                                [EFF_ATTR.VAL3] = 1,    --等级
                                [EFF_ATTR.VAL4] = PAM_ATTR.NEW_OBJECT,
                            },
                        },
                    },
                },
            },
            {
                id = 5,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = OBJ_ATTR.MP,
                                [EFF_ATTR.VAL2] = 20,
                            },
                        },
                    },
                },
            },
        },
    },
}

t[ATTR_CONF_ID.SKILL_ANNI_OBJ_3] = {
    [1] = {
        comps = {
            {
                id = 1,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = 10,
                            }
                        },
                    },
                },
            },
            {
                id = 3,
                attr = {
                    [COMM_ATTR.CAT_CHECK_TIME] = 5000,
                },
            },
        },
    },
}

t[ATTR_CONF_ID.LJ_SKILL_GEN_1] = {
    [1] = {
        attr = {
            [SKILL_ATTR.TYPE] = SKILL_TYPE.OBJ,
        },
        comps = {
            {
                id = 1,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = OBJ_ATTR.MP,
                                [EFF_ATTR.VAL2] = 40,
                            },
                        },
                    },
                },
            },
            {
                id = 2,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = STRUCT_ID.LJ_SKILL_OBJ_1,
                                [EFF_ATTR.VAL2] = ATTR_CONF_ID.LJ_SKILL_OBJ_1,
                                [EFF_ATTR.VAL3] = 1,    --等级
                            },
                        },
                    },
                },
            },
            {
                id = 7,
                attr = {
                    [COMM_ATTR.CAT_CONTROL_CD] = 1000,
                },
            },
        },
    },
}

t[ATTR_CONF_ID.LJ_SKILL_OBJ_1] = {
    [1] = {
        comps = {
            {
                id = 1,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = STRUCT_ID.LJ_BUFF_POISON,
                                [EFF_ATTR.VAL2] = ATTR_CONF_ID.LJ_BUFF_POISON,
                                [EFF_ATTR.VAL3] = 1,    --等级
                                [EFF_ATTR.VAL4] = PAM_ATTR.NEW_OBJECT,
                            },
                            {
                                [EFF_ATTR.VAL1] = PAM_ATTR.NEW_OBJECT,
                                [EFF_ATTR.VAL2] = PAM_ATTR.OBJ_EFF_TAKER,
                            },
                        },
                    },
                },
            },
            {
                id = 5,
                attr = {
                    [COMM_ATTR.CAT_CHECK_TIME] = 3000,
                },
            },
        },
    },
}

t[ATTR_CONF_ID.LJ_BUFF_POISON] = {
    [1] = {
        comps = {
            {
                id = 1,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = 10,
                            },
                        },
                    },
                },
            },
            {
                id = 3,
                attr = {
                    [COMM_ATTR.CAT_CHECK_TIME] = 3000,
                },
            },
        },
    },
}