local USWN = ... or {}
local counter = {[PLAYER_1]=0,[PLAYER_2]=0}

USWN.ButtonRedir = {
	-- cardinal directions
	Up			= "Down",
	Down		= "Down",
	Left		= "Down",
	Right		= "Down",
	-- ordinal directions
	UpLeft		= "Down",
	UpRight		= "Down",
	DownLeft	= "Down",
	DownRight	= "Down",
	-- center is center
	Center 		= "Center"
}
USWN.Rotate = {
	-- cardinal directions
	Up			= 180,
	Down		= 0,
	Left		= 90,
	Right		= -90,
	-- ordinal directions
	UpLeft		= 135,
	UpRight		= 225,
	DownLeft	= 45,
	DownRight	= -45,
	-- center is center
	Center 		= 0
}
USWN.PartsToRotate = {
	["Receptor"] = true,
	["Tap Explosion Bright"] = true,
	["Tap Explosion Dim"] = true,
	["Tap Note"] = true,
	["Tap Fake"] = true,
	["Tap Addition"] = true,
	["Hold Head Active"] = true,
	["Hold Head Inactive"] = true,
	["Roll Head Active"] = true,
	["Roll Head Inactive"] = true
}
USWN.Blank = {
	["Hold Tail Active"] = true,
	["Hold Tail Inactive"] = true,
	["Roll Tail Active"] = true,
	["Roll Tail Inactive"] = true,
	["Pit Tail Active"] = true,
	["Pit Tail Inactive"] = true
}

USWN.Load = function()
	local sButton = Var "Button"
	local sElement = Var "Element"
	local sPlayer = Var "Player"
	local Button = USWN.ButtonRedir[sButton] or "Center"

	if string.find(sElement,"Head") then sElement = "Tap Note" end

	local filePath = NOTESKIN:GetPath(Button,sElement)
	local t
	local smx = IsGame("smx")
	local zoom = smx and 0.85 or 1

	if smx and sButton == "Center" then zoom = zoom - 0.15 end
	if filePath:sub(-3) == "lua" then
		if sElement == "Receptor" then
			t = loadfile(filePath)(sPlayer,counter[sPlayer],-USWN.Rotate[sButton])..{InitCommand=function(self) self:basezoom(zoom) end}
			counter[sPlayer] = counter[sPlayer]+1
			if counter[sPlayer] >= GAMESTATE:GetCurrentStyle(sPlayer):ColumnsPerPlayer() then counter[sPlayer] = 0 end
		elseif string.find(sElement,"Tap") then
			t = loadfile(filePath)()..{InitCommand=function(self) self:basezoom(3/4*zoom) end}
		else
			t = loadfile(filePath)()..{InitCommand=function(self) self:basezoom(zoom) end}
		end
	else
		t = Def.Sprite{
			Texture=filePath,
			InitCommand=function(self) self:basezoom(zoom) end
		}
	end

	if USWN.Blank[sElement] then if Var "SpriteOnly" then t = Def.Sprite{Texture=NOTESKIN:GetPath("","_blank")} else t = Def.Actor{} end end
	if USWN.PartsToRotate[sElement] then t.BaseRotationZ = USWN.Rotate[sButton] or nil end
	if sElement == "Explosion" then t.BaseRotationZ = nil end

	return t
end

return USWN