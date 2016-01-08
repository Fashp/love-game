--Define variables
local tileset, tiletable, tileW, tileH, tiles
local floor = math.floor
local ceil = math.ceil
local layerCount = 0

--Generates tileset and fills in tiles array automatically
function loadTiles(tW, tH, tilesetPath, tileMap)
	tiletable = tileMap
	tilesets = {}
	tiles = {}

	layerCount = #tilesetPath

	for l=1, layerCount do

		--load image to tileset
		tileset = love.graphics.newImage(tilesetPath[l])
		tileset:setFilter('nearest', 'nearest')

		tileW = tW
		tileH = tH
		
		local tsetW, tsetH = tileset:getWidth(), tileset:getHeight()

		--get width and height for tiles in the layer

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
		local layerTiles = {}
		layerTiles[0] = love.graphics.newQuad(tileInfo[7][1],tileInfo[7][3],tileW,tileH,tsetW,tsetH)
		for i=1, #tileInfo do
			layerTiles[i] = love.graphics.newQuad(tileInfo[i][1], tileInfo[i][3], tileW, tileH, tsetW, tsetH)
		end

		table.insert(tilesets, tileset)
		table.insert(tiles, layerTiles)
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
	for l = 1,layerCount do
		for x = minx,maxx do
			for y = miny,maxy do
				local gfx = getTileAt(l, x, y)
				if (gfx) then 
					local sx = x*16 - camx + screen_w/(2*scale)
					local sy = y*16 - camy + screen_h/(2*scale)
					if gfx > 0 then
						love.graphics.draw(tilesets[l], tiles[l][gfx], sx, sy) -- x, y, r, sx, sy, ox, oy
					end
				end
			end
		end
	end

end