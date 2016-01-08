require 'maps/smoother'

--variables
local spriteLayers = {"images/caveGround.png", "images/caveWalls.png", "images/doors.png"}
local tWidth, tHeight = 16, 16
local width
local height

--layer1 is ground
--layer2 is walls

--do generation for layer 1
local function layer1(x, y)
	return 9
end

--do generation for layer 2
local function layer2(x, y)
	if x == 0 or y == 0 or x == width or y == height then
		return 4
	end

	if love.math.random() > .85 then
		return 4
	end

	return 0
end

local function layer3(x, y)
	if x == 8 and y == 0 then
		return 1
	end

	return 0
end

--generate a map with size xSize by ySize
function generateCave(xSize, ySize)
	width = xSize
	height = ySize
	tileTable = {}

	for l=1,#spriteLayers do
		local layer = {}
		table.insert(tileTable, layer)

		for y=0, ySize do
			layer[y] = {}
			for x=0, xSize do
				if l == 1 then
					layer[y][x] = layer1(x, y)
				elseif l == 2 then
					layer[y][x] = layer2(x, y)
				elseif l == 3 then
					layer[y][x] = layer3(x, y)
				end
			end

		end
	end

	tileTable = smooth(tileTable)
	loadTiles(tWidth, tHeight, spriteLayers, tileTable)
end