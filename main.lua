local map = {}
local player = {}

function map.setTile(x, y, t)
	map[y*map.w+x] = t
end

function map.init()
	map.w = 10
	map.h = 10
	for x = 0, map.w-1 do
		for y = 0, map.h-1 do
			map[y*map.w+x] = 1
		end
	end
	for x = 1, map.w-2 do
		for y = 1, map.h-2 do
			map[y*map.w+x] = 0
		end
	end
	map.setTile(4, 1, 1)
end

function map.draw2d(xo, yo)
	love.graphics.setColor(1, 1, 1, 1)
	for x = 0, map.w-1 do
		for y = 0, map.h-1 do
			local t = map[y*map.h+x]
			if t == 1 then
				love.graphics.rectangle("line", x*16+xo, y*16+yo, 16, 16)
			end
		end
	end

	local x = player.x * 16
	local y = player.y * 16
	local a = player.a
	local v = {
		x+math.cos(a)*8, y+math.sin(a)*8,
		x-math.cos(a-0.7)*8, y-math.sin(a-0.7)*8,
		x, y,
		x-math.cos(a+0.7)*8, y-math.sin(a+0.7)*8,
	}
	love.graphics.polygon("fill", v)
end

function player.init()
	player.x = 1.5
	player.y = 1.5
	player.a = math.pi
end

function map.draw3d()
	local dres = 4
	local width = love.graphics.getWidth()/dres
	local height = love.graphics.getHeight()
	for l = 0, width do
		local a = player.a-math.pi/4 + (l/width)*math.pi/2
		local d = 0
		local x = 0
		local y = 0
		for ld = 1, 400 do
			d = ld/20
			x = player.x + math.cos(a)*d
			y = player.y + math.sin(a)*d
			if x >= map.w or y >= map.h or x < 0 or y < 0 then break end
			local tx = math.min(math.floor(x), math.ceil(x))
			local ty = math.min(math.floor(y), math.ceil(y))
			if map[ty*map.w+tx] == 1 then break end
		end
		love.graphics.setColor(1, 0, 0, 1)
		local h = height/d/math.cos(a-player.a)
		if h > height then h = height end
		if h < 0 then h = 0 end
		love.graphics.rectangle("fill", l*dres, height/2-h/2, dres, h)
	end
end

function love.load()
	map.init()
	player.init()
end

function love.update(delta)
	local am = 0
	local xm = 0
	local ym = 0
	if love.keyboard.isDown("left") then am = -5 * delta end
	if love.keyboard.isDown("right") then am = 5 * delta end
	if love.keyboard.isDown("up", "down") then
		xm = math.cos(player.a) * 6 * delta
		ym = math.sin(player.a) * 6 * delta
		if love.keyboard.isDown("down") then
			xm = xm * -0.5
			ym = ym * -0.5
		end
	end
	player.x = player.x + xm
	player.y = player.y + ym
	player.a = player.a + am
end

function love.draw()
	map.draw3d()
	map.draw2d(0, 0)
end
