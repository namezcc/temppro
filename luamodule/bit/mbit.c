#include "mbit.h"

int l_and(lua_State* L)
{
	lua_Integer v1 = luaL_checkinteger(L,1);
	lua_Integer v2 = luaL_checkinteger(L,2);
	lua_pushinteger(L,v1 & v2);
	return 1;
}

int l_or(lua_State* L)
{
	lua_Integer v1 = luaL_checkinteger(L,1);
	lua_Integer v2 = luaL_checkinteger(L,2);
	lua_pushinteger(L,v1 | v2);
	return 1;
}

int l_not(lua_State* L)
{
	lua_Integer v1 = luaL_checkinteger(L,1);
	lua_pushinteger(L, ~v1 );
	return 1;
}

int l_xor(lua_State* L)
{
	lua_Integer v1 = luaL_checkinteger(L,1);
	lua_Integer v2 = luaL_checkinteger(L,2);
	lua_pushinteger(L, v1 ^ v2 );
	return 1;
}

int l_movel(lua_State* L)
{
	lua_Integer v1 = luaL_checkinteger(L,1);
	lua_Integer m = luaL_checkinteger(L,2);
	lua_pushinteger(L, v1 << m );
	return 1;
}

int l_mover(lua_State* L)
{
	lua_Integer v1 = luaL_checkinteger(L,1);
	lua_Integer m = luaL_checkinteger(L,2);
	lua_pushinteger(L, v1 >> m );
	return 1;
}

int l_setbit(lua_State* L)
{
	lua_Integer v1 = luaL_checkinteger(L,1);
	lua_Integer i = luaL_checkinteger(L,2)-1;
	int b = lua_toboolean(L,3);
	if(b)
		v1|=((int64_t)1<<i);
	else
		v1&=~((int64_t)1<<i);
	lua_pushinteger(L, v1 );
	return 1;
}

int l_checkbit(lua_State* L)
{
	lua_Integer v1 = luaL_checkinteger(L,1);
	lua_Integer i = luaL_checkinteger(L,2)-1;
	int b = v1&((int64_t)1<<i);
	lua_pushboolean(L,b);
	return 1;
}

int luaopen_mbit(lua_State* L)
{
	luaL_Reg reg[] = {
		{"band",l_and},
		{"bor",l_or},
		{"bnot",l_not},
		{"bxor",l_xor},
		{"movel",l_movel},
		{"mover",l_mover},
		{"setbit",l_setbit},
		{"checkbit",l_checkbit},
		{NULL,NULL},
	};
	luaL_newlib(L, reg);
	return 1;
}