--maps are hash maps noting which adjacent tiles are walls
--1000 -> below
--0100 -> above
--0010 -> left
--0001 -> right
--so 1001 would have a wall below and to the right
--these then map onto position on sprite sheet
local groundMap = {}
--4 sides
groundMap[1111] = 6

--3 sides
groundMap[1110] = 12
groundMap[1101] = 14
groundMap[1011] = 18
groundMap[0111] = 4

--2 sides
groundMap[0110] = 1
groundMap[0101] = 3
groundMap[0011] = 11
groundMap[1100] = 13
groundMap[1010] = 15
groundMap[1001] = 17

--1 side
groundMap[0100] = 2
groundMap[0010] = 8
groundMap[0001] = 10
groundMap[1000] = 16

--0 sides
groundMap[0000] = 9

---------------------------
local wallMap = {}
--4 sides
wallMap[1111] = 12

--3 sides
wallMap[1110] = 13
wallMap[1101] = 11
wallMap[1011] = 5
wallMap[0111] = 19

--2 sides
wallMap[0110] = 17
wallMap[0101] = 15
wallMap[0011] = 2
wallMap[1100] = 8
wallMap[1010] = 3
wallMap[1001] = 1

--1 side
wallMap[0100] = 8
wallMap[0010] = 2
wallMap[0001] = 2
wallMap[1000] = 8

--0 sides
wallMap[0000] = 4

local tilesMap = {groundMap, wallMap}
local tTable = {}

function isTileBelow(l, x, y)
	row = tTable[l][y+1]
	return row and (row[x] and (row[x] > 0 and 1000 or 0) or 0) or 0
end

function isTileAbove(l, x, y)
	row = tTable[l][y-1]
	return row and (row[x] and (row[x] > 0 and 100 or 0) or 0) or 0
end

function isTileLeft(l, x, y)
	row = tTable[l][y]
	return row and (row[x-1] and (row[x-1] > 0 and 10 or 0) or 0) or 0
end

function isTileRight(l, x, y)
	row = tTable[l][y]
	return row and (row[x+1] and (row[x+1] > 0 and 1 or 0) or 0) or 0
end

function getAdjacencyValue(l, x, y)
	 return isTileBelow(l, x, y) + isTileAbove(l, x, y) + isTileLeft(l, x, y) + isTileRight(l, x, y)
end

--put in correct tiles when adjacent to walls
function smooth(tileTable)
	tTable = tileTable

	for l=1, #tTable do
		for y=0, #tTable[l] do
			local row = tTable[l][y]

			for x=0, #row do
				if row[x] > 0 then
					row[x] = tilesMap[l][getAdjacencyValue(2, x, y)]
				end
			end
		end
	end

	return tTable
end

