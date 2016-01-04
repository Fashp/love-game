--love.filesystem.load("tiledmap.lua")()
require 'player'
require 'map_helper'

playerSpawnTile = 8
playerSpeed = 8

kTileSize = 32

gCamX = 0
gCamY = 0

gKeyPressed = {}
world = {}
local directions = {}
directions["down"] = 0
directions["up"] = 1
directions["left"] = 2
directions["right"] = 3

--update key array on release
function love.keyreleased(key)
	gKeyPressed[key] = nil
end

--update key array on press
function love.keypressed(key, unicode) 
	gKeyPressed[key] = true 
	if (key == "escape") then 
		os.exit(0) 
	end
end

--main update function
function love.update(dt)
	--These directions are fucked too
	dirX, dirY, dir = 0, 0, 0
	if gKeyPressed.up then
		dirX = -1
		dir = directions["up"]
	elseif gKeyPressed.right then
		dirY = 1
		dir = directions["right"]
	elseif gKeyPressed.down then
		dirX = 1
		dir = directions["down"]
	elseif gKeyPressed.left then
		dirY = -1
		dir = directions["left"]
	end

	playerMove(dirX, dirY, dir)
end

--main load function
function love.load()
	--TiledMap_Load("maps/testmap1.tmx")
	love.filesystem.load("maps/lab1.lua")()
	gCamX, gCamY = playerSpawnTile * kTileSize, playerSpawnTile * kTileSize
	playerLoad(gCamX, gCamY, playerSpeed, playerSpawnTile)
end

--main render function
function love.draw()
	--TiledMap_DrawNearCam(gCamX, gCamY)
	--drawMap()
	drawNearCam(gCamX, gCamY)
	playerDraw()
	gCamX, gCamY = playerGetCoords()
end