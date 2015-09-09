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
	backImg.speed = 3
	sceneGroup:insert(backImg)
	
	backImg2 = display.newImageRect("images/backLarge.png", display.contentWidth, 87)
	backImg2.anchorX = 0
	backImg2.anchorY = 1
	backImg2.x = display.contentWidth
	backImg2.y = display.viewableContentHeight - 30
	backImg2.speed = 3
	sceneGroup:insert(backImg2)	
	
	-- Fondo de adelante
	frontImg = display.newImageRect("images/frontLarge.png", display.contentWidth, 58)
	frontImg.anchorX = 0
	frontImg.x = 0
	frontImg.y = display.viewableContentHeight - 50
	frontImg.speed = 9
	sceneGroup:insert(frontImg)
	
	frontImg2 = display.newImageRect("images/frontLarge.png", display.contentWidth, 58)
	frontImg2.anchorX = 0
	frontImg2.x = display.contentWidth
	frontImg2.y = display.viewableContentHeight - 50
	frontImg2.speed = 9
	sceneGroup:insert(frontImg2)
	
	-------------------------------------------------------------------
	-- PLAYER
	--[[
	local sheetData = {width = 224, height = 224, numFrames = 5, sheetContentWidth = 1120, sheetContentHeight = 224}
	local mySheet = graphics.newImageSheet("images/pastorSprite.png", sheetData)
	local secuenceData = {
		{name = "tacos", start = 1, count = 5, time = 7000, loopCount = 0, loopDirection = "forward"},
		{name = "hit", frames = { 2 }, time = 500}
	}
	player = display.newSprite( mySheet, secuenceData )
	player:scale( .35 , .35 )
	--]]
	player = display.newImageRect("images/player.png", 70, 70)
	player.x = 150
	player.y = display.contentCenterY
	player.collided = false
	player.myName = "player"
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
	physics.addBody(enemyL1, "static", {density=.1, bounce = 3, friction = .2, radius = 25 } )
	physics.addBody(enemyL2, "static", {density=.1, bounce = 3, friction = .2, radius = 25 } )
	physics.addBody(ceiling, "static", {density=.1, bounce = 0.1, friction = .2 } )
	physics.addBody(theFloor, "static", {density=.1, bounce = 0.1, friction = .2 } )
	physics.addBody(player, "static", {density=.1, bounce = 1, friction = .2, radius = 25 } )
	
	-------------------------------------------------------------------
	-- TEXT
	
	-- score
	scoreText = display.newText( sceneGroup, "0", display.contentCenterX, 30, native.systemFontBold, 40 )
	scoreText:setFillColor( .95, .33, 0 )
	scoreText.isVisible = false
		
	-- Initial Text
	InitText = display.newText( sceneGroup, "FlyPastor", display.contentCenterX, display.contentCenterY - 50, native.systemFontBold, 90 )
	HoldText = display.newText( sceneGroup, "Hold to play", display.contentCenterX, display.contentCenterY + 50, native.systemFontBold, 40 )	
	InitText:setFillColor( .95, .33, 0 )
	HoldText:setFillColor( .95, .33, 0 )
	
	-- Grab images
	instructions = display.newImageRect("images/instructions.png", 400,70)
	instructions.anchorY = 0
	instructions.x = display.contentCenterX + 15
	instructions.y = display.contentCenterY + 120
	
	-- Up score
	upScoreText = display.newText( sceneGroup, "0", display.contentCenterX, display.contentCenterY, native.systemFontBold, 25 )
	upScoreText:setFillColor( .95, .33, 0 )
	sceneGroup:insert(upScoreText)
	transition.to(upScoreText,{time=100,alpha=0})
	
	-------------------------------------------------------------------
	-- SUBGROUPS
	
	--Before play
	before = display.newGroup()
	before.anchorChildren = true
	before.anchorX = 0.5
	before.anchorY = 0.5
	before.x = display.contentCenterX
	before.y = display.contentCenterY
	sceneGroup:insert(before)
	before:insert(InitText)
	before:insert(HoldText)
	before:insert(instructions)
	
	-- Enemies Group
	elements = display.newGroup()
	elements.anchorChildren = true
	elements.anchorX = 0.5
	elements.anchorY = 0.5
	elements.x = 0
	elements.y = 0
	sceneGroup:insert(elements)
	
	-- Enemies Group
	coins = display.newGroup()
	coins.anchorChildren = true
	coins.anchorX = 0.5
	coins.anchorY = 0.5
	coins.x = 0
	coins.y = 0
	sceneGroup:insert(coins)
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
function fadeText(e)
  transition.to(upScoreText,{time=1000,alpha=0})
end

-------------------------------------------------------------------
function upScore( num )
	if not player.collided then
		mydata.score = mydata.score + num
		scoreText.text = mydata.score
		upScoreText.x, upScoreText.y = player.x + 100, player.y
		upScoreText.text = "+".. num
		print(upScoreText.text)
		transition.to( upScoreText, {time=0,alpha=1, onComplete=fadeText})
	end
end

-------------------------------------------------------------------
function moveCoins()
	if gameStarted then
		for j = coins.numChildren,1,-1  do
			if coins[j].x < (0 - display.contentWidth - 50) then
				coins:remove(coins[j])
				coins[j] = nil
			else
				coins[j].x = coins[j].x - coins[j].speed
			end
		end
	end
end

-------------------------------------------------------------------
function addCoin()
	probability = math.random(1,100)
	if (probability <= 10) then
		coin = display.newImageRect("images/ranch.png", 40, 50)
		coin.value = 10
	elseif probability <= 30 then
		coin = display.newImageRect("images/molcajete.png", 60, 50)
		coin.value = 5
	else
		coin = display.newImageRect("images/chile.png", 40, 70)
		coin.value = 1
	end
	coin.x = display.contentWidth + math.random(50,200)
	coin.y = display.contentCenterY + math.random(-300,300)
	coin.speed = 10
	coin.myName = "coin"
	physics.addBody(coin, "static", {density=.1, bounce = 1, friction = .2} )
	coin.isSensor = true
	coins:insert(coin)
end

-------------------------------------------------------------------
function moveEnemy()
	if gameStarted then
		for a = elements.numChildren,1,-1  do
			if elements[a].x < (0 - display.contentWidth - 50) then
				elements:remove(elements[a])
				elements[a] = nil
			else
				elements[a].x = elements[a].x - elements[a].speed
				elements[a].angle = elements[a].angle + .1
				elements[a].y = elements[a].amp * math.sin(elements[a].angle) + elements[a].initY
			end
		end
	end
end

-------------------------------------------------------------------
function addEnemy()
	enemy = display.newImageRect("images/mexican.png", 100, 100)
	enemy.x = display.contentWidth + math.random(50,1000)
	enemy.y = display.contentCenterY + math.random(-300,300)
	enemy.initY = enemy.y
	enemy.angle = math.random(1,360)
	if enemy.y > display.contentCenterY then
		enemy.amp = math.random(10,(display.viewableContentHeight - enemy.y - 15))
	else
		enemy.amp = math.random(10,enemy.y - 15)
	end
	enemy.speed = math.random(10,20)
	physics.addBody(enemy, "static", {density=.1, bounce = 1, friction = .2, radius = 33 } )
	elements:insert(enemy)
end

-------------------------------------------------------------------
function flyUp(event)
	if not gameStarted then
		gameStarted = true
		scoreText.isVisible = true		
		transition.fadeOut( before, { time=1000 } )
		before = nil
		player.bodyType = "dynamic"
		player.gravityScale = 0
		--player:play()
		addEnemyTimer = timer.performWithDelay(2000 - mydata.score * 5, addEnemy, -1)
		moveEnemyTimer = timer.performWithDelay(2, moveEnemy, -1)
		addCoinTimer = timer.performWithDelay(2000, addCoin, -1)
		moveCoinsTimer = timer.performWithDelay(2, moveCoins, -1)
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
function moveLinearly( self, event )
	if gameStarted then
		if self.x < (0 - display.contentWidth - 50) then
			self.x = display.contentWidth + math.random(50,200)
			self.y = display.contentCenterY + math.random(-400,400)
			self.speed = math.random(10,20)
		else
			self.x = self.x - self.speed
		end
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
			if event.object1.myName == "coin" or event.object2.myName == "coin" then
				if event.object1.myName == "coin" then
					upScore(event.object1.value)
					event.object1:removeSelf()
					event.object1 = nil
				else
					upScore(event.object2.value)
					event.object2:removeSelf()
					event.object2 = nil
				end
			else
				player.collided = true
				--player:setSequence("hit")
				player.bodyType = "static"
				explode()
				gameOverTimer = timer.performWithDelay( 1000, gameOver, 1 )
			end
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
				
		enemyL1.enterFrame = moveLinearly
		Runtime:addEventListener("enterFrame", enemyL1)
		
		enemyL2.enterFrame = moveLinearly
		Runtime:addEventListener("enterFrame", enemyL2)
		
		Runtime:addEventListener("collision", onCollision)
		
		memTimer = timer.performWithDelay( 2000, checkMemory, 0 )
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
		Runtime:removeEventListener("enterFrame", enemyL1)
		Runtime:removeEventListener("enterFrame", enemyL2)
		Runtime:removeEventListener("collision", onCollision)
		timer.cancel(gameOverTimer)
		timer.cancel(memTimer)
		timer.cancel(addEnemyTimer)
		timer.cancel(moveEnemyTimer)
		timer.cancel(addCoinTimer)
		timer.cancel(moveCoinsTimer)
		transition.cancel()		
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