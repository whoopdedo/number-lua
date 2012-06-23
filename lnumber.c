#include <stdlib.h>

#include <openssl/bn.h>
#include <openssl/err.h>

#include "lua.h"
#include "lauxlib.h"

#define NUMBER_VERSION	"100"

int number_compile(lua_State *L)
{
    char buffer[512];
    const char *source;
    char *code;
    size_t codesize;
    BIGNUM *bytecode = NULL;

    lua_settop(L, 1);
    if (lua_isnil(L, 1))
	return luaL_argerror(L, 1, "string expected");
    lua_getglobal(L, "tostring");
    lua_pushvalue(L, 1);
    lua_call(L, 1, 1);
    source = lua_tolstring(L, -1, NULL);
    if (source == NULL)
	return luaL_argerror(L, 1, lua_pushfstring(L,
			     "string expected, got %s", luaL_typename(L, 1)));
    if (!BN_dec2bn(&bytecode, source) || !bytecode || BN_is_negative(bytecode))
	return luaL_error(L, "invalid number");
    codesize = BN_num_bytes(bytecode);
    if (codesize > sizeof(buffer))
	code = lua_newuserdata(L, codesize);
    else
	code = buffer;
    codesize = BN_bn2bin(bytecode, (unsigned char*)code);
    BN_free(bytecode);
    lua_pushlstring(L, code, codesize);
    return 1;
}

static int dumper(lua_State *L, const void* bytes, size_t size, void* buffer)
{
    (void)L;
    luaL_addlstring((luaL_Buffer*)buffer, (const char*)bytes, size);
    return 0;
}

int number_dump(lua_State *L)
{
    luaL_Buffer buffer;
    BIGNUM *bytecode;
    const char *code;
    size_t codesize;
    char *source;

    lua_settop(L, 1);
    switch (lua_type(L, 1))
    {
	case LUA_TFUNCTION:
	    luaL_buffinit(L, &buffer);
	    if (lua_dump(L, dumper, &buffer) != 0)
		return luaL_error(L, "unable to dump given function");
	    luaL_pushresult(&buffer);
	    lua_replace(L, 1);
	    break;
	case LUA_TSTRING:
	    break;
	default:
	    return luaL_argerror(L, 1, lua_pushfstring(L,
				"string or function expected, got %s",
				luaL_typename(L, 1)));
    }
    code = lua_tolstring(L, 1, &codesize);
    bytecode = BN_new();
    if (!bytecode)
	return luaL_error(L, "dump failed (%s)",
			  ERR_reason_error_string(ERR_get_error()));
    if (!BN_bin2bn((unsigned char*)code, codesize, bytecode))
    {
	BN_free(bytecode);
	return luaL_error(L, "dump failed (%s)",
			  ERR_reason_error_string(ERR_get_error()));
    }
    source = BN_bn2dec(bytecode);
    BN_free(bytecode);
    if (source == NULL)
	return luaL_error(L, "dump failed (%s)",
			  ERR_reason_error_string(ERR_get_error()));
    lua_pushstring(L, source);
    OPENSSL_free(source);
    return 1;
}

static const luaL_Reg number_functions[] = 
{
    {"compile", number_compile},
    {"dump", number_dump},
    {NULL, NULL}
};

LUALIB_API int luaopen_number(lua_State *L)
{
    ERR_load_BN_strings();
    luaL_newlib(L, number_functions);
    lua_pushliteral(L, "version");
    lua_pushliteral(L, NUMBER_VERSION);
    lua_settable(L, -3);
    return 1;
}
