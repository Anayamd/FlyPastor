---------------------------------------------------------------------------------
--
-- game.lua
--
---------------------------------------------------------------------------------

function insertaAlGrupo( group, ... )
	for k, v in ipairs(arg) do group:insert( v ) end
end

local gameStarted = false

--------------------------------------------------------------------------------------
-- REQUIRES
--------------------------------------------------------------------------------------

local physics = require "physics"
physics.start()
--physics.setDrawMode("hybrid")

local composer = require( "composer" )
local scene = composer.newScene()

local mydata = require( "mydata" )

--------------------------------------------------------------------------------------
-- CREATE
--------------------------------------------------------------------------------------

function scene:create(event)
	
	local sceneGroup = self.view
	
	gameStarted = false
	mydata.score = 0
	
	local background = display.newImageRect("images/bg.png", display.viewableContentWidth, display.viewableContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
	-------------------------------------------------------------------
	-- Ceiling
	ceiling = display.newImageRect("images/invisibleTileLarge.png", 480, 25)
	ceiling.anchorX = 0
	ceiling.anchorY = 1
	ceiling.x = 0
	ceiling.y = 0
	sceneGroup:insert(ceiling)
	
	theFloor = display.newImageRect("images/invisibleTileLarge.png", 480, 25)
	theFloor.anchorX = 0
	theFloor.anchorY = 0
	theFloor.x = 0
	theFloor.y = display.viewableContentHeight
	sceneGroup:insert(theFloor)
	
	-------------------------------------------------------------------
	-- Fondo de atrás
	backImg = display.newImageRect("images/backLarge.png", display.contentWidth, 87)
	backImg.anchorX = 0
	backImg.anchorY = 1
	backImg.x = 0
	backImg.y = display.viewableContentHeight - 30
	backImg.speed = 1
	sceneGroup:insert(backImg)
	
	backImg2 = display.newImageRect("images/backLarge.png", display.contentWidth, 87)
	backImg2.anchorX = 0
	backImg2.anchorY = 1
	backImg2.x = display.contentWidth
	backImg2.y = display.viewableContentHeight - 30
	backImg2.speed = 1
	sceneGroup:insert(backImg2)	
	
	-- Fondo de adelante
	frontImg = display.newImageRect("images/frontLarge.png", display.contentWidth, 58)
	frontImg.anchorX = 0
	frontImg.x = 0
	frontImg.y = display.viewableContentHeight - 50
	frontImg.speed = 2
	sceneGroup:insert(frontImg)
	
	frontImg2 = display.newImageRect("images/frontLarge.png", display.contentWidth, 58)
	frontImg2.anchorX = 0
	frontImg2.x = display.contentWidth
	frontImg2.y = display.viewableContentHeight - 50
	frontImg2.speed = 2
	sceneGroup:insert(frontImg2)
	
	-------------------------------------------------------------------
	-- PLAYER
	local sheetData = {width = 224, height = 224, numFrames = 5, sheetContentWidth = 1120, sheetContentHeight = 224}
	local mySheet = graphics.newImageSheet("images/pastorSprite.png", sheetData)
	local secuenceData = {
		{name = "tacos", start = 1, count = 5, time = 7000, loopCount = 0, loopDirection = "forward"},
		{name = "hit", frames = { 2 }, time = 500}
	}
	player = display.newSprite( mySheet, secuenceData )
	player:scale( .35 , .35 )
	player.x = 150
	player.y = display.contentCenterY
	player.collided = false
	sceneGroup:insert(player)
	
	-------------------------------------------------------------------
	-- EXPLOSION
	local sheetDataExplosion = {width = 24, height = 23, numFrames = 8, sheetContentWidth = 192, sheetContentHeight = 23}
	local explosionSheet = graphics.newImageSheet("images/explosion.png", sheetDataExplosion)
	local secuenceDataExplosion = {
		{name = "expolosions", start = 1, count = 8, time = 500, loopCount = 1, loopDirection = "forward"}
	}
	explosion = display.newSprite( explosionSheet, secuenceDataExplosion )
	explosion:scale( 3 , 3 )
	explosion.x = display.contentCenterX
	explosion.y = display.contentCenterY
	explosion.isVisible = false
	sceneGroup:insert(explosion)
	
	-------------------------------------------------------------------
	--ENEMIES
	
	-- enemy1
	enemy1 = display.newImageRect("images/mexican.png", 100, 100)
	enemy1.x = display.contentWidth + math.random(50,500)
	enemy1.y = display.contentCenterY
	enemy1.initY = enemy1.y
	enemy1.angle = math.random(1,360)
	enemy1.amp = math.random(20,70)
	enemy1.speed = math.random(13,15)
	sceneGroup:insert(enemy1)
	
	-- enemy2
	enemy2 = display.newImageRect("images/mexican.png", 100, 100)
	enemy2.x = display.contentWidth + math.random(50,800)
	enemy2.y = display.contentCenterY
	enemy2.initY = enemy2.y
	enemy2.angle = math.random(1,360)
	enemy2.amp = math.random(20,70)
	enemy2.speed = math.random(12,15)
	sceneGroup:insert(enemy2)
	
	-- enemy3
	enemy3 = display.newImageRect("images/mexican.png", 100, 100)
	enemy3.x = display.contentWidth + math.random(200,1000)
	enemy3.y = display.contentCenterY
	enemy3.initY = enemy3.y
	enemy3.angle = math.random(1,360)
	enemy3.amp = math.random(20,70)
	enemy3.speed = math.random(15,18)
	sceneGroup:insert(enemy3)
	
	-- enemyL1
	local knifeSheetData = {width = 219.25, height = 219, numFrames = 4, sheetContentWidth = 877, sheetContentHeight = 219}
	local knifeSheet = graphics.newImageSheet("images/knifeSprite.png", knifeSheetData)
	local knifeSecuenceData = {
		{name = "knifes",  start = 1, count = 4, time = 700, loopCount = 0, loopDirection = "forward"}
	}
	enemyL1 = display.newSprite( knifeSheet, knifeSecuenceData )
	enemyL1:scale( .35 , .35 )
	enemyL1.x = display.contentWidth + 270
	enemyL1.y = display.contentCenterY - math.random(30, 400)
	enemyL1.speed = math.random(10,20)
	enemyL1:play()
	sceneGroup:insert(enemyL1)
	
	-- enemyL2
	enemyL2 = display.newSprite( knifeSheet, knifeSecuenceData )
	enemyL2:scale( .35 , .35 )
	enemyL2.x = display.contentWidth + 270
	enemyL2.y = display.contentCenterY + math.random(30, 400)
	enemyL2.speed = math.random(10,20)
	enemyL2:play()
	sceneGroup:insert(enemyL2)
	
	-------------------------------------------------------------------
	-- PHYSICS
	physics.addBody(enemy1, "static", {density=.1, bounce = 1, friction = .2, radius = 33 } )
	physics.addBody(enemy2, "static", {density=.1, bounce = 1, friction = .2, radius = 33 } )
	physics.addBody(enemy3, "static", {density=.1, bounce = 1, friction = .2, radius = 33 } )
	physics.addBody(enemyL1, "static", {density=.1, bounce = 3, friction = .2, radius = 25 } )
	physics.addBody(enemyL2, "static", {density=.1, bounce = 3, friction = .2, radius = 25 } )
	physics.addBody(ceiling, "static", {density=.1, bounce = 0.1, friction = .2 } )
	physics.addBody(theFloor, "static", {density=.1, bounce = 0.1, friction = .2 } )
	physics.addBody(player, "static", {density=.1, bounce = 1, friction = .2, radius = 25 } )
	
	-- score
	scoreText = display.newText( sceneGroup, "0", display.contentCenterX, 30, native.systemFontBold, 40 )
	scoreText:setFillColor( .95, .33, 0 )
	scoreText.isVisible = false
		
	-- Initial Text
	InitText = display.newText( sceneGroup, "FlyPastor", display.contentCenterX, display.contentCenterY - 50, native.systemFontBold, 90 )
	HoldText = display.newText( sceneGroup, "Hold to play", display.contentCenterX, display.contentCenterY + 50, native.systemFontBold, 40 )	
	InitText:setFillColor( .95, .33, 0 )
	HoldText:setFillColor( .95, .33, 0 )
	
	--[[SOUNDS
	soundTable = {
		scoreSound = audio.loadSound( "what_is_love_8_bit.mp3" ),
		explosionSound = audio.loadSound( "explosion.wav" )
	}
	--]]
end

--------------------------------------------------------------------------------------
-- FUNCTIONS
--------------------------------------------------------------------------------------

function groundScroller( self, event )
	if self.x < (0 - display.contentWidth + 3) then
		self.x = display.contentWidth
	else
		self.x = self.x - self.speed
	end
end

-------------------------------------------------------------------
function upScore()
	if not player.collided then
		mydata.score = mydata.score + 1
		scoreText.text = mydata.score
		--audio.play( soundTable["scoreSound"] )
	end
end

-------------------------------------------------------------------
function moveEnemy( self, event )
	if gameStarted then
		if self.x < (0 - display.contentWidth - 50) then
			self.x = display.contentWidth + math.random(50,1000)
			self.y = display.contentCenterY + math.random(-400,400)
			self.angle = math.random(1,360)
			self.amp = math.random(20,230)
			self.speed = math.random(10,20)
			upScore()
		else
			self.x = self.x - self.speed
			self.angle = self.angle + .1
			self.y = self.amp * math.sin(self.angle) + self.initY
		end
	end
end

-------------------------------------------------------------------
function getMax()
	if 1 == 500 then
		return 0
	end
	return 500 - 1
end

-------------------------------------------------------------------
function moveLinearly( self, event )
	if gameStarted then
		if self.x < (0 - display.contentWidth - 50) then
			self.x = display.contentWidth + math.random(50,200)
			self.y = display.contentCenterY + math.random(-400,400)
			self.speed = math.random(10,20)
			upScore()
		else
			self.x = self.x - self.speed
		end
	end
end

-------------------------------------------------------------------
function flyUp(event)
	if not gameStarted then
		gameStarted = true
		scoreText.isVisible = true		
		transition.fadeOut( InitText, { time=1000 } )
		transition.fadeOut( HoldText, { time=1000 } )
		player.bodyType = "dynamic"
		player.gravityScale = 0
		player:play()
	end
	if event.phase == "began" then
		player:setLinearVelocity(0, -400)
	end
	if event.phase == "ended" then
		Runtime:removeEventListener("enterFrame", player)
		player:setLinearVelocity(0, 400)
	end
end

-------------------------------------------------------------------
function explode()
	explosion.x = player.x
	explosion.y = player.y
	explosion.isVisible = true
	explosion:play()
end

-------------------------------------------------------------------
function gameOver()
	local options = { effect = "fade", time = 400 }
	composer.gotoScene("restart", options)
end

-------------------------------------------------------------------
function onCollision( event )
	if event.phase == "began" then
		if not player.collided then
			--audio.play( soundTable["explosionSound"] )
			player.collided = true
			player:setSequence("hit")
			player.bodyType = "static"
			explode()
			timer.performWithDelay( 1000, gameOver, 1 )
		end
	end
end

-------------------------------------------------------------------
local function checkMemory()
	collectgarbage( "collect" )
	local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
end

--------------------------------------------------------------------------------------
-- SCENES
--------------------------------------------------------------------------------------

function scene:show(event)
	
	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
		-- Do nothing
	elseif ( phase == "did" ) then
		-- Called when the scene is now on screen.
		-- Example: start timers, begin animation, play audio, etc.
		composer.removeScene( "restart" )
		
		Runtime:addEventListener("touch", flyUp)
		
		backImg.enterFrame = groundScroller
		Runtime:addEventListener("enterFrame", backImg)
		
		backImg2.enterFrame = groundScroller
		Runtime:addEventListener("enterFrame", backImg2)
		
		frontImg.enterFrame = groundScroller
		Runtime:addEventListener("enterFrame", frontImg)
		
		frontImg2.enterFrame = groundScroller
		Runtime:addEventListener("enterFrame", frontImg2)
		
		enemy1.enterFrame = moveEnemy
		Runtime:addEventListener("enterFrame", enemy1)
		
		enemy2.enterFrame = moveEnemy
		Runtime:addEventListener("enterFrame", enemy2)
		
		enemy3.enterFrame = moveEnemy
		Runtime:addEventListener("enterFrame", enemy3)
		
		enemyL1.enterFrame = moveLinearly
		Runtime:addEventListener("enterFrame", enemyL1)
		
		enemyL2.enterFrame = moveLinearly
		Runtime:addEventListener("enterFrame", enemyL2)
		
		Runtime:addEventListener("collision", onCollision)
		
		memTimer = timer.performWithDelay( 1000, checkMemory, 0 )
	end
end

--------------------------------------------------------
function scene:hide(event)
	
	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
		Runtime:removeEventListener("touch", flyUp)
		Runtime:removeEventListener("enterFrame", backImg)
		Runtime:removeEventListener("enterFrame", backImg2)
		Runtime:removeEventListener("enterFrame", frontImg)
		Runtime:removeEventListener("enterFrame", frontImg2)
		Runtime:removeEventListener("enterFrame", enemy1)
		Runtime:removeEventListener("enterFrame", enemy2)
		Runtime:removeEventListener("enterFrame", enemy3)
		Runtime:removeEventListener("enterFrame", enemyL1)
		Runtime:removeEventListener("enterFrame", enemyL2)
		Runtime:removeEventListener("collision", onCollision)
		--timer.cancel(gameOver)
	elseif ( phase == "did" ) then
		-- Do nothing
	end	
end

--------------------------------------------------------
function scene:destroy(event)
	-- Does nothing
end

--------------------------------------------------------------------------------------
-- SCENES CREATION
--------------------------------------------------------------------------------------

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

--------------------------------------------------------------------------------------

return scene