
local m = require("component").modem
local event = require("event")
_G.port = _G.port or 27091
_G.maxNN = _G.maxNN or 19

local function g(...)
	m.broadcast(_G.port, "nanomachines", ...)
	return {event.pull(6, "modem_message")}
end

local function init()
	g("setResponsePort", _G.port)
  m.open(_G.port)
  _G.maxNN = g("getTotalInputcount")[8]
end

local function clear()
  print("Clearing ".._G.maxNN.." inputs")
  for i=1, _G.maxNN do
    print("Turning off "..i)
    g("setInput", i, false)
  end
end

local function getActive()
  active = g("getActiveEffects")[8]
  if active then
    print("Active Effects:")
    print(active)
  end
end

local function set(a,b)
  if a == nil then
    print("a was not")
    return
  end
  print("Setting "..a)
  g("setInput", a, true)
  if b ~= nil then
    print("Setting "..b)
    g("setInput", b, true)
  end
  getActive()
end

local function list()
  print(
    "\n  GOOD:\n",
    "2: fireResist\n",
    "6: Jump\n",
    "10: resist\n",
    "2.7: fireResist\n",
    "     waterBreathing\n",
    "5.18: Magnet\n",
    "9.14: Dig\n",
    "15.17: Damage Boost\n",
    "  BAD:\n",
    "4.13: DEATH")
end

local function listCommands(cmnds)
  print("commands:")
  for k,v in pairs(cmnds) do
    print("  "..k)
  end
end

local commands = {
  ["clear"] = clear,
  ["set"] = set,
  ["list"] = list,
  ["active"] = getActive,
  ["commands"] = function()
    listCommands(self)
  end
}


args = {...}
cmd = args[1]
table.remove(args, 1)
for i=1,#args do
  if tonumber(args[i]) then
    args[i] = tonumber(args[i])
  end
end
if cmd then
  print("running "..cmd)
  commands[cmd](table.unpack(args))
else
  init()
end







