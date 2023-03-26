package;

import hxlua.Lua;
import hxlua.LuaL;
import hxlua.Types;
import sys.io.File;

class Main
{
  public static function main():Void
  {
    sys.io.File.copy('../script.lua', 'script.lua');

    // create the new state
    var vm:cpp.RawPointer<Lua_State> = LuaL.newstate();

    // open the libs
    LuaL.openlibs(vm);

    // do the file
    var ret:Int = LuaL.dofile(vm, "script.lua");

    // check if isn't ok
    if (ret != Lua.OK)
    {
      trace("Lua Error: " + Lua.tostring(vm, ret));
      Lua.pop(vm, 1);
    }

    // call 'foo' function
    Lua.getglobal(vm, "foo");
    Lua.pushinteger(vm, 1);
    Lua.pushnumber(vm, 2.0);
    Lua.pushstring(vm, "three");
    Lua.pcall(vm, 3, 0, 1);

    // getting the gc memory count after the call
    trace('Lua GC Memory: ${Lua.gc(vm, Lua.GCCOUNT, [])} KB');

    // close the state
    Lua.close(vm);
    vm = null;
  }
}
