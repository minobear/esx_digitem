# Description:
This plugin you can set an area to dig things just edit in the config

# Peview:
https://streamable.com/lfcxx8

# Config:
```
Config = {}

Config.Locale = "en" --en, tw

-- The unit is milliseconds
Config.SpawnWaitMin = 10000
Config.SpawnWaitMax = 30000

Config.DigTime = 10000

Config.Digs = {
	{
		digItem = {"clam", 1}, needTool = "shovel", digLabel = "蛤蠣", toolLabel = "鏟子",
		x = -2165.57, y = -462.55, areaRange = 8, maxSpawn = 10,
		breakToolPercent = 30, blips = true, blipName = "蛤蠣挖掘區"
	},
	
--[[
	{
		digItem = {"rice", 1}, needTool = "sickle", digLabel = "稻米", toolLabel = "鐮刀",
		x = 2604.84, y = 4440.52, areaRange = 35, maxSpawn = 50, 
		breakToolPercent = 10, blips = true, blipName = "稻米採集區"
	}
]]--
}
```
