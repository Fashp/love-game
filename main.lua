require 'player'
require 'map_helper'
require 'maps/caveGen'

--player variables
playerSpawnTile = 1
playerSpeed = 4

--global scale
scale = 2

--size of all tiles (player and map)
kTileSize = 16

gCamX = 0
gCamY = 0

gKeyPressed = {}
world = {}

rSeed = 0

local directions = {}
directions["down"] = 0
directions["up"] = 1
directions["left"] = 2
directions["right"] = 3

local level = 1;

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
	if gKeyPressed.r then
		local g = {}
		generateCave(16, 16)
		level = level + 1
		gKeyPressed.r = false
	end

	--These directions are goofed too
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

function loadSeed()
	rSeed = love.math.random(0, tonumber('FFFFFFFF', 16))
	love.math.setRandomSeed(rSeed)
end

--main load function
function love.load()
	tt = {}
	loadSeed()
	generateCave(16, 16)
	gCamX, gCamY = playerSpawnTile * kTileSize, playerSpawnTile * kTileSize
	playerLoad(gCamX, gCamY, playerSpeed, playerSpawnTile)
end

--main render function
function love.draw()
	love.graphics.scale(scale,scale)
	drawNearCam(gCamX, gCamY)
	playerDraw()
	gCamX, gCamY = playerGetCoords()
end

function nextLevel()
	generateCave(16, 16)
end

function decToHex(IN)
    local B,K,OUT,I,D=16,"0123456789ABCDEF","",0
    while IN>0 do
        I=I+1
        IN,D=math.floor(IN/B),math.mod(IN,B)+1
        OUT=string.sub(K,D,D)..OUT
    end
    return OUT
end