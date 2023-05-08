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
			["info"] = {"KAČEROV", "Kačerov", "Kačrov"}
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
