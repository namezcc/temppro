local t = AttrTable

t[ATTR_CONF_ID.MS_SKILL_GEN_1] = {
    [1] = {
        attr = {
            [SKILL_ATTR.TYPE] = SKILL_TYPE.DMG,
        },
        comps = {
            {
                id = 2,
                attr = {
                    [COMM_ATTR.CAT_CONTROL_CD] = 5000,
                },
            },
            {
                id = 4,
                attr = {
                    [COMM_ATTR.CAT_MAKE_LEVEL] = 1,
                },
            },
            {
                id = 5,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = OBJ_ATTR.MP,
                                [EFF_ATTR.VAL2] = 15,
                            },
                        },
                    },
                },
            },
        },
    },
}

t[ATTR_CONF_ID.MS_S1_OBJ_BALL] = {
    [1] = {
        attr = {
            [OBJ_ATTR.OAT_SPEED] = 200,
        },
        comps = {
            {
                id = 6,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = 40,
                            },
                        },
                    },
                },
            },
            {
                id = 9,
                attr = {
                    [COMM_ATTR.CAT_MAKE_LEVEL] = 1,
                },
            },
        },
    },
}

t[ATTR_CONF_ID.MS_S1_BUFF_BALL] = {
    [1] = {
        comps = {
            {
                id = 2,
                attr = {
                    [COMM_ATTR.CAT_CHECK_TIME] = 3000,
                },
            },
            {
                id = 7,
                attr = {
                    [COMM_ATTR.CAT_MAKE_LEVEL] = 1,
                },
            },
        },
    },
}

t[ATTR_CONF_ID.MS_S1_BUFF_MOVE] = {
    [1] = {
        attr = {
            [OBJ_ATTR.OAT_SPEED] = 200,
        },
        comps = {
            {
                id = 7,
                attr = {
                    group = {
                        {
                            {
                                [EFF_ATTR.VAL1] = 45,
                            },
                        },
                    },
                },
            },
        },
    },
}