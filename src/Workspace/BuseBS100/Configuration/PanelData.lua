--Availible commands for text edit:
--[[

*/i - inverses text
*/t - creates new line

]]

local data = {
	["cil"] = {
		{
			["id"]="1",
			["info"] = {"SÍDL.LIB.", "Sídliště Libuš", "Sídliště Libuššš"}
		},
		{
			["id"]="2",
			["info"] = {"KAČEROV", "*/iKačerov", "Kačrov"}
		},
		{
			["id"]="3",
			["info"] = {"HŘBITOV", "Havlíčkův Brod, Kopka,*/trocestí, hřbitov*/i", "*/iHavlíčkův Brod, Kopka,*/trocestí, hřbitov"}
		},
		{
			["id"]="4",
			["info"] = {"TEST", "First row front*/tSecond row front inverted*/i", "First row side inverted*/i*/tSecond row side default"}
		},
		{
			["id"]="5",
			["info"] = {"TEST2", "Text across front panel normal", "First row side default*/t*/iSecond row side inverted"}
		},
		{
			["id"]="6",
			["info"] = {"TEST3", "Text across front panel inverted", "Long text that will be automaticaly put on two lines"}
		},
		{
			["id"]="999",
			["info"] = {"MANIPULAČNÍ", "Manipulační jízda", "Manipulační jízda"}
		},
	},
	
	["linka"] = {
		["215"] = {
			{
				["smer"] = 1,
				["refCil"] = 1,
				["showedLineNum"] = "215",
			},
			{
				["smer"] = 2,
				["refCil"] = 2,
				["showedLineNum"] = "215",
			},
		}
	}
}

return data
