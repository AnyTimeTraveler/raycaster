-----------------------------------------------------------------------------------
--------Raycasting code written by Ben White (scutheotaku), 2012 ------------------
--------Based on code by Lode Vandevenne (http://lodev.org/cgtutor/raycasting.html)
-----------------------------------------------------------------------------------
-------
------
-----
----
---
--

--setup map
map={
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
  {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,3,0,0,0,3,0,0,0,1},
  {1,0,0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,2,2,0,2,2,0,0,0,0,3,0,3,0,3,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,0,0,0,5,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,4,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,4,4,4,4,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
};

function love.load()

	posX = 22

	posY = 12

	dirX = -1
	dirY = 0

	planeX = 0
	planeY = 0.66

	w = 800
	h = 600
	image = love.graphics.newImage('redbrick.png')
	imageHeight = image:getHeight()
	imageWidth  = image:getWidth()

	drawScreenLineStart = {}
	drawScreenLineEnd = {}
	drawScreenLineColor = {}
end

function love.update(dt)
	for x = 0, w, 1 do
		local cameraX = 2 * x / w - 1
		local rayPosX = posX
		local rayPosY = posY
		local rayDirX = dirX + planeX * cameraX
		local rayDirY = dirY + planeY * cameraX

		local mapX = math.floor(rayPosX)
		local mapY = math.floor(rayPosY)

		local sideDistX
		local sideDistY

		local deltaDistX = math.sqrt(1 + (rayDirY ^ 2) / (rayDirX ^ 2))
		local deltaDistY = math.sqrt(1 + (rayDirX ^ 2) / (rayDirY ^ 2))
		local perWallDist

		local stepX
		local stepY

		local hit = 0
		local side = 0

		if (rayDirX < 0) then
			stepX = -1
			sideDistX = (rayPosX - mapX) * deltaDistX
		else
			stepX = 1
			sideDistX = (mapX + 1.0 - rayPosX) * deltaDistX
		end
		if (rayDirY < 0) then
			stepY = -1
			sideDistY = (rayPosY - mapY) * deltaDistY
		else
			stepY = 1
			sideDistY = (mapY + 1.0 - rayPosY) * deltaDistY
		end
		while (hit == 0) do
			if (sideDistX < sideDistY) then
				sideDistX = sideDistX + deltaDistX
				mapX = mapX + stepX
				side = 0
			else
				sideDistY = sideDistY + deltaDistY
				mapY = mapY + stepY
				side = 1
			end

			if (map[mapX][mapY] > 0) then
				hit = 1
			end
			end

			if (side == 0)then
				perpWallDist = math.abs((mapX - rayPosX + (1 - stepX) / 2) / rayDirX)
			else
				perpWallDist = math.abs((mapY - rayPosY + (1 - stepY) / 2) / rayDirY)
			end

			lineHeight = math.abs(math.floor(h / perpWallDist))

			drawStart = -lineHeight / 2 + h / 2
			if (drawStart < 0) then drawStart = 0 end
			drawEnd = lineHeight / 2 + h / 2
			if (drawEnd >= h) then drawEnd = h - 1 end


			drawScreenLineStart[x] = drawStart
			drawScreenLineEnd[x] = drawEnd
		end

		moveSpeed = dt * 5.0
		rotSpeed = dt * 3.0
		strafeSpeed = dt * 5.0

		if love.keyboard.isDown("w") then
			if (map[math.floor(posX + dirX * moveSpeed)][math.floor(posY)] == 0) then
				posX = posX + dirX * moveSpeed
			end
			if (map[math.floor(posX)][math.floor(posY + dirY * moveSpeed)] == 0) then
				posY = posY + dirY * moveSpeed
			end
		end
		if love.keyboard.isDown("s") then
			if (map[math.floor(posX - dirX * moveSpeed)][math.floor(posY)] == 0) then
				posX = posX - dirX * moveSpeed
			end
			if (map[math.floor(posX)][math.floor(posY - dirY * moveSpeed)] == 0) then
				posY = posY - dirY * moveSpeed
			end
		end
		if love.keyboard.isDown("d") then
			if (map[math.floor(posX + planeX * moveSpeed)][math.floor(posY)] == 0) then
				posX = posX + planeX * strafeSpeed
			end
			if (map[math.floor(posX)][math.floor(posY + planeY * moveSpeed)] == 0) then
				posY = posY + planeY * strafeSpeed
			end
		end
		if love.keyboard.isDown("a") then
			if (map[math.floor(posX - planeX * moveSpeed)][math.floor(posY)] == 0) then
				posX = posX - planeX * strafeSpeed
			end
			if (map[math.floor(posX)][math.floor(posY - planeY * moveSpeed)] == 0) then
				posY = posY - planeY * strafeSpeed
			end
		end
		if love.keyboard.isDown("right") then
			oldDirX = dirX
			dirX = dirX * math.cos(-rotSpeed) - dirY * math.sin(-rotSpeed)
			dirY = oldDirX * math.sin(-rotSpeed) + dirY * math.cos(-rotSpeed)
			oldPlaneX = planeX
			planeX = planeX * math.cos(-rotSpeed) - planeY * math.sin(-rotSpeed)
			planeY = oldPlaneX * math.sin(-rotSpeed) + planeY * math.cos(-rotSpeed)
		end
		if love.keyboard.isDown("left") then
			oldDirX = dirX
			dirX = dirX * math.cos(rotSpeed) - dirY * math.sin(rotSpeed)
			dirY = oldDirX * math.sin(rotSpeed) + dirY * math.cos(rotSpeed)
			oldPlaneX = planeX
			planeX = planeX * math.cos(rotSpeed) - planeY * math.sin(rotSpeed)
			planeY = oldPlaneX * math.sin(rotSpeed) + planeY * math.cos(rotSpeed)
		end
	end

function love.draw()
	for x = 0, w, 1 do
		--[[for y = drawScreenLineStart[x], drawScreenLineEnd[x], 1 do
			love.graphics.setColor(image:getPixel(x % imageWidth, (y - drawScreenLineStart[x]) * imageHeight / (drawScreenLineEnd[x] - drawScreenLineStart[x] + 1) ))
			love.graphics.points(x,y)
		end]]--
		quad = love.graphics.newQuad(x % imageWidth, 0, 1, imageHeight, imageWidth, imageHeight)
		love.graphics.draw(image, quad, x, drawScreenLineStart[x], 0, 1, (drawScreenLineEnd[x] - drawScreenLineStart[x] + 1) / imageHeight,  0, 0)
	end
	love.graphics.setColor(255, 12, 12)
	love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10, 0, 3)
end

function love.keypressed(key, unicode)
     if key == " " then love.graphics.toggleFullscreen() end

end
