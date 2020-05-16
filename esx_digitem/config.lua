Config = {}

Config.Locale = "en" --en, tw

-- The unit is milliseconds
Config.SpawnWaitMin = 10000
Config.SpawnWaitMax = 30000

Config.DigTime = 10000

Config.Digs = {
	{
		-- If you want to use random item please follow this example:
		-- digItem = {{"clam", 1, "蛤蠣"}, {"stone", 1, "石頭"}, ...},
		
		digItem = {{"clam", 1, "蛤蠣"}}, needTool = "shovel", toolLabel = "鏟子",
		x = -2165.57, y = -462.55, areaRange = 8, maxSpawn = 10, markerColor = {255, 179, 102},
		breakToolPercent = 10, blips = true, blipName = "蛤蠣挖掘區"
	},
--[[
	{
		digItem = {{"rice", 1, "稻米"}}, needTool = "sickle", toolLabel = "鐮刀",
		x = 2604.84, y = 4440.52, areaRange = 35, maxSpawn = 30, markerColor = {255, 140, 26}, 
		breakToolPercent = 10, blips = true, blipName = "稻米採集區"
	},
	
	{
		digItem = {{"watermelon", 1, "西瓜"}}, needTool = "sickle", toolLabel = "鐮刀",
		x = 2037.7, y = 4907.65, areaRange = 35, maxSpawn = 30, markerColor = {0, 255, 0},
		breakToolPercent = 10, blips = true, blipName = "西瓜採集區"
	},
	
	{
		digItem = {{"cotton", 1, "棉花"}}, needTool = "gloves", toolLabel = "採集手套",
		x = 2235.42, y = 5077.58, areaRange = 35, maxSpawn = 30, markerColor = {255, 255, 255},  
		breakToolPercent = 10, blips = true, blipName = "棉花採集區"
	}	
]]--
}
