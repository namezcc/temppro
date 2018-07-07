#ifndef MBIT_H
#define MBIT_H

#include <stdint.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"


static int l_and(lua_State* L);
static int l_or(lua_State* L);
static int l_not(lua_State* L);
static int l_xor(lua_State* L);
static int l_movel(lua_State* L);
static int l_mover(lua_State* L);
static int l_setbit(lua_State* L);
static int l_checkbit(lua_State* L);

extern _declspec(dllexport) int luaopen_mbit(lua_State* L);

#endif