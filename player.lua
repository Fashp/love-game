--variables
local tileX, tileY = 16, 16
local dx, dy = 0, 0

--Player object
local p = {}

--loads the player 
function playerLoad(xPos, yPos, speed, spawnTile)
	--movement stuff
	p.x = xPos
	p.y = yPos
	p.speed = speed/kTileSize/scale
	p.distance = 0
	p.moving = false
	p.direction = 0 --0 down, 1 up, 2 left, 3 right

	--player starting tile
	p.tx, p.ty = spawnTile, spawnTile

	--load player sprite sheet
	p.sheet = love.graphics.newImage("images/player.png")
	p.sheet:setFilter('nearest', 'nearest')

	p.step = 0
	local width, height = p.sheet:getDimensions()
	p.animationSteps = width / kTileSize
	local sheetHeight = height / kTileSize

	--sprites are in order down, up, left, right
	p.sprites = {}
	for j=0, sheetHeight do	
		for i=0, p.animationSteps do
			p.sprites[p.animationSteps*j + i] = love.graphics.newQuad(i*kTileSize, j*kTileSize, kTileSize, kTileSize, width, height)
		end
	end
end

--renders the player
function playerDraw()
	spriteMap = (p.animationSteps * p.direction) + p.step
	xPos = love.graphics.getWidth()/(2*scale)
	yPos = love.graphics.getHeight()/(2*scale)
	love.graphics.draw(p.sheet, p.sprites[spriteMap], xPos, yPos)
	
	--Debug messages
	--love.graphics.print(p.x .. ' ' .. p.y,10, 30)
	--love.graphics.print(decToHex(rSeed), 10, 10)
	--love.graphics.print(getTileAt(1, p.ty, p.tx), 10, 30)
	--love.graphics.print(getTileAt(2, p.ty, p.tx), 10, 50)
end

--Checks to make sure the player wont collide after moving
function canMove()
	local targetTile = getTileAt(2, p.ty, p.tx)
	--local targetTile = 0
	if (targetTile > 0 and getTileAt(3, p.ty, p.tx) == 0) then
		return false
	end
	return true
end

--moves the player
function playerMove(dirX, dirY, dir)
	if (p.moving == false and p.distance == 0) then
		if (dirX ~= 0 or dirY ~= 0) then
			--update movement vars
			p.moving = true
			dx = dirX
			dy = dirY
			p.ty = p.ty + dirY
			p.tx = p.tx + dirX
			p.direction = dir
			
			--make sure move is valid
			if (canMove() == false) then
				p.moving = false
				dx = 0
				dy = 0
				p.ty = p.ty - dirY
				p.tx = p.tx - dirX
			end
		end
	elseif (p.moving and p.distance < kTileSize) then
		--do the move
		p.x = p.x + (dx * p.speed)
		p.y = p.y + (dy * p.speed)
		p.distance = p.distance + math.abs(dx * p.speed)
		p.distance = p.distance + math.abs(dy * p.speed)

		--animation stuff
		if (p.distance % (kTileSize/p.animationSteps) == 0) then
			p.step = (p.step + 1) % p.animationSteps
		end
	else
		--back to idle
		p.moving = false
		dx = 0
		dy = 0
		p.distance = 0
		p.step = 0

		if getTileAt(3, p.ty, p.tx) > 0 then
			nextLevel()
		end
	end
end

--returns the player's coordinates
--FIX ME--
--FIGURE OUT WHY Y AND X ARE SWAPPED--
function playerGetCoords()
 return p.y, p.x
end

