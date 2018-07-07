#include "mtime.h"
#include <windows.h>

int64_t tick()
{
	static int64_t timeStamp = 0;
	if (timeStamp <= 0)
	{
		timeStamp = time(NULL) - GetTickCount() / 1000;
	}
	return timeStamp * 1000 + GetTickCount();
}

int32_t getSecond()
{
	return time(NULL);
}
void sleepSecond(int32_t sec)
{
	Sleep(sec*1000);
}
void sleepMillionSecond(int32_t mn)
{
	Sleep(mn);
}

int l_tick(lua_State* L)
{
	lua_pushinteger(L,tick());
	return 1;
}
int l_getSecond(lua_State* L)
{
	lua_pushinteger(L,getSecond());
	return 1;
}
int l_sleepSecond(lua_State* L)
{
	int32_t n = lua_tointeger(L,1);
	sleepSecond(n);
	return 0;
}
int l_sleepMillionSecond(lua_State* L)
{
	int32_t n = lua_tointeger(L,1);
	sleepMillionSecond(n);
	return 0;
}

int luaopen_mtime(lua_State* L)
{
	luaL_Reg reg[] = {
		{"getMSecond",l_tick},
		{"getSecond",l_getSecond},
		{"sleepSecond",l_sleepSecond},
		{"sleepMSecond",l_sleepMillionSecond},
		{NULL,NULL},
	};
	luaL_newlib(L, reg);
	return 1;
}