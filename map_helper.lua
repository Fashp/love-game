--Define variables
local tileset, tiletable, tileW, tileH, tiles
local floor = math.floor
local ceil = math.ceil

--Generates tileset and fills in tiles array automatically
function loadTiles(tW, tH, tilesetPath, tileMap)
	tileset = love.graphics.newImage(tilesetPath)
	tileset:setFilter('nearest', 'nearest')

	tiletable = tileMap

	tileW = tW
	tileH = tH
	
	local tsetW, tsetH = tileset:getWidth(), tileset:getHeight()

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
	tiles = {}
	tiles[0] = love.graphics.newQuad(tileInfo[5][1],tileInfo[5][3],tileW,tileH,tsetW,tsetH)
	for i=1, #tileInfo do
		tiles[i] = love.graphics.newQuad(tileInfo[i][1], tileInfo[i][3], tileW, tileH, tsetW, tsetH)
	end
end

--loads a map file, and runs it
function loadMap(path)
	love.filesystem.load(path)()
end

--renders the map with tiletables from map file
function drawMap()
	love.graphics.scale(2,2)
	for i=1,#tiletable do
		local row = tiletable[i]
		for j=1,#row do
			local ctile = row[j]
			love.graphics.draw(tileset, tiles[ctile], j * tileW, i * tileH)
		end
	end
	love.graphics.scale(.5,.5)
end

function getTileAt(x, y)
	row = tiletable[y]
	return row and row[x] or 0
end

function drawNearCam(camx, camy)
	camx,camy = floor(camx),floor(camy)
	local screen_w = love.graphics.getWidth()
	local screen_h = love.graphics.getHeight()
	local minx,maxx = floor((camx-screen_w/2)/kTileSize),ceil((camx+screen_w/2)/kTileSize)
	local miny,maxy = floor((camy-screen_h/2)/kTileSize),ceil((camy+screen_h/2)/kTileSize)
	for x = minx,maxx do
		for y = miny,maxy do
			local gfx = getTileAt(x, y)
			if (gfx) then 
				local sx = x*16 - camx + screen_w/2
				local sy = y*16 - camy + screen_h/2
				love.graphics.scale(2,2)
				love.graphics.draw(tileset, tiles[gfx], sx, sy) -- x, y, r, sx, sy, ox, oy
				love.graphics.scale(.5,.5)
			end
		end
	end

end