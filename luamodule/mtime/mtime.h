#ifndef MTIME_H
#define MTIME_H

#include <time.h>
#include <stdint.h>
//#include "lua.hpp"
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

int64_t tick();
int32_t getSecond();
void sleepSecond(int32_t sec);
void sleepMillionSecond(int32_t mn);

static int l_tick(lua_State* L);
static int l_getSecond(lua_State* L);
static int l_sleepSecond(lua_State* L);
static int l_sleepMillionSecond(lua_State* L);

//"C" _declspec(dllexport)
extern _declspec(dllexport) int luaopen_mtime(lua_State* L);

#endif