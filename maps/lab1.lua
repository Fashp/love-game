--the map
local TileTable = {
	{5,5,5,5,5,5,5,5,5,5,5,5,5,5,5},
	{5,2,3,1,1,1,1,1,1,1,1,1,1,1,5},
	{5,6,7,1,1,1,1,1,1,1,1,1,1,1,5},
	{5,1,1,1,1,1,1,1,1,1,1,1,1,1,5},
	{5,1,1,1,1,1,1,1,1,1,1,1,1,1,5},
	{5,2,3,1,1,1,1,1,1,1,1,1,1,1,5},
	{5,6,7,1,1,1,1,1,1,1,1,1,1,1,5},
	{5,1,1,1,1,1,1,1,1,1,1,1,1,1,5},
	{5,1,1,1,1,1,1,1,1,1,1,1,1,1,5},
	{5,2,3,1,1,1,1,1,1,1,1,1,1,1,5},
	{5,6,7,1,1,4,1,1,1,1,1,1,1,1,5},
	{5,1,1,1,1,8,1,1,1,1,1,1,1,1,5},
	{5,5,5,5,5,5,5,5,5,5,5,5,5,5,5}
}

--load up the tiles
loadTiles(32, 32, 'images/lab.png', TileTable)
	