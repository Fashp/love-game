--Define variables
local tileset, tiletable, tileW, tileH, tiles
local floor = math.floor
local ceil = math.ceil

--Generates tileset and fills in tiles array automatically
function loadTiles(tW, tH, tilesetPath, tileMap)
	tileset = {}

	for i=1,#tilesetPath do
		tileset[i] = love.graphics.newImage(tilesetPath[i])
		tileset[i]:setFilter('nearest', 'nearest')
	end

	tiletable = tileMap

	tileW = tW
	tileH = tH
	
	local tsetW, tsetH = tileset[1]:getWidth(), tileset[1]:getHeight()

	--programatically get tiles
	local tileInfo = {}
	local index = 1
	for h=0, tsetH-1, tileH do
		for w=0, tsetW-1, tileW do
			tileInfo[index] = {w, ' ', h}
			index = index + 1
		end
	end

	--make tile quads
	--assumes all sheets are same size
	--TODO: Modify so quads generate correctly with different sized sheets per layer--
	tiles = {}
	tiles[0] = love.graphics.newQuad(tileInfo[7][1],tileInfo[7][3],tileW,tileH,tsetW,tsetH)
	for i=1, #tileInfo do
		tiles[i] = love.graphics.newQuad(tileInfo[i][1], tileInfo[i][3], tileW, tileH, tsetW, tsetH)
	end
end

--loads a map file, and runs it
function loadMap(path)
	love.filesystem.load(path)()
end

--returns tile in layer l at pos x, y
function getTileAt(l, x, y)
	row = tiletable[l][y]
	return row and row[x] or 0
end

--draw only tiles near the camera
function drawNearCam(camx, camy)
	camx,camy = floor(camx),floor(camy)
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	local minx,maxx = floor((camx-screen_w/(2*scale))/kTileSize),ceil((camx+screen_w/(2*scale))/kTileSize)
	local miny,maxy = floor((camy-screen_h/(2*scale))/kTileSize),ceil((camy+screen_h/(2*scale))/kTileSize)
	for l = 1,2 do
		for x = minx,maxx do
			for y = miny,maxy do
				local gfx = getTileAt(l, x, y)
				if (gfx) then 
					local sx = x*16 - camx + screen_w/(2*scale)
					local sy = y*16 - camy + screen_h/(2*scale)
					love.graphics.draw(tileset[l], tiles[gfx], sx, sy) -- x, y, r, sx, sy, ox, oy
				end
			end
		end
	end

end