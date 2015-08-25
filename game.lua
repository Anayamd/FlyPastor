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

--------------------------------------------------------------------------------------
-- CREATE
--------------------------------------------------------------------------------------

function scene:create(event)
	
	local sceneGroup = self.view
	
	local background = display.newImageRect("images/bg.png", display.viewableContentWidth, display.viewableContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
	-------------------------------------------------------------------
	-- Ceiling
	ceiling1 = display.newImageRect("images/invisibleTile.png", 480, 25)
	ceiling1.anchorX = 0
	ceiling1.anchorY = 1
	ceiling1.x = 0
	ceiling1.y = 0
	sceneGroup:insert(ceiling1)
	
	ceiling2 = display.newImageRect("images/invisibleTile.png", 480, 25)
	ceiling2.anchorX = 0
	ceiling2.anchorY = 1
	ceiling2.x = 480
	ceiling2.y = 0
	sceneGroup:insert(ceiling2)
	
	ceiling3 = display.newImageRect("images/invisibleTile.png", 480, 25)
	ceiling3.anchorX = 0
	ceiling3.anchorY = 1
	ceiling3.x = 480 * 2
	ceiling3.y = 0
	sceneGroup:insert(ceiling3)
	
	-- theFloor
	theFloor1 = display.newImageRect("images/invisibleTile.png", 480, 25)
	theFloor1.anchorX = 0
	theFloor1.anchorY = 0
	theFloor1.x = 0
	theFloor1.y = display.viewableContentHeight
	sceneGroup:insert(theFloor1)
	
	theFloor2 = display.newImageRect("images/invisibleTile.png", 480, 25)
	theFloor2.anchorX = 0
	theFloor2.anchorY = 0
	theFloor2.x = 480
	theFloor2.y = display.viewableContentHeight
	sceneGroup:insert(theFloor2)
	
	theFloor3 = display.newImageRect("images/invisibleTile.png", 480, 25)
	theFloor3.anchorX = 0
	theFloor3.anchorY = 0
	theFloor3.x = 480 * 2
	theFloor3.y = display.viewableContentHeight
	sceneGroup:insert(theFloor3)
	
	-------------------------------------------------------------------
	-- Fondo de atrás
	backImg = display.newImageRect("images/backLarge.png", display.contentWidth, 87)
	backImg.anchorX = 0
	backImg.anchorY = 1
	backImg.x = 0
	backImg.y = display.viewableContentHeight - 30
	backImg.speed = .3
	sceneGroup:insert(backImg)
	
	backImg2 = display.newImageRect("images/backLarge.png", display.contentWidth, 87)
	backImg2.anchorX = 0
	backImg2.anchorY = 1
	backImg2.x = display.contentWidth
	backImg2.y = display.viewableContentHeight - 30
	backImg2.speed = .3
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
	enemy1.x = display.contentCenterX + 270 + math.random(50,400)
	enemy1.y = display.contentCenterY 
	enemy1.initY = enemy1.y
	enemy1.angle = math.random(1,360)
	enemy1.amp = math.random(20,70)
	enemy1.speed = math.random(3,4)
	
	-- enemy2
	enemy2 = display.newImageRect("images/mexican.png", 50, 50)
	enemy2.x = display.contentCenterX + 270 + math.random(50,200)
	enemy2.y = display.contentCenterY 
	enemy2.initY = enemy2.y
	enemy2.angle = math.random(1,360)
	enemy2.amp = math.random(20,70)
	enemy2.speed = math.random(2,5)
	
	-- enemy3
	enemy3 = display.newImageRect("images/mexican.png", 50, 50)
	enemy3.x = display.contentCenterX + 270 + math.random(200,300)
	enemy3.y = display.contentCenterY 
	enemy3.initY = enemy3.y
	enemy3.angle = math.random(1,360)
	enemy3.amp = math.random(20,70)
	enemy3.speed = math.random(2,3)
	
	-- enemyL1
	local knifeSheetData = {width = 219.25, height = 219, numFrames = 4, sheetContentWidth = 877, sheetContentHeight = 219}
	local knifeSheet = graphics.newImageSheet("images/knifeSprite.png", knifeSheetData)
	local knifeSecuenceData = {
		{name = "knifes",  start = 1, count = 4, time = 1000, loopCount = 0, loopDirection = "forward"}
	}
	enemyL1 = display.newSprite( knifeSheet, knifeSecuenceData )
	enemyL1:scale( .15 , .15 )
	enemyL1.x = display.contentCenterX + 270
	enemyL1.y = display.contentCenterY - 50
	enemyL1.speed = math.random(2,6)
	enemyL1:play()
	
	-- enemyL2
	enemyL2 = display.newSprite( knifeSheet, knifeSecuenceData )
	enemyL2:scale( .15 , .15 )
	enemyL2.x = display.contentCenterX + 270
	enemyL2.y = display.contentCenterY + 50
	enemyL2.speed = math.random(2,6)
	enemyL2:play()
	
	-- PHYSICS
	--physics.addBody(enemy1, "static", {density=.1, bounce = 1, friction = .2, radius = 14 } )
	--physics.addBody(enemy2, "static", {density=.1, bounce = 1, friction = .2, radius = 14 } )
	--physics.addBody(enemy3, "static", {density=.1, bounce = 1, friction = .2, radius = 14 } )
	--physics.addBody(enemyL1, "static", {density=.1, bounce = 3, friction = .2, radius = 12 } )
	--physics.addBody(enemyL2, "static", {density=.1, bounce = 3, friction = .2, radius = 12 } )
	--physics.addBody(ceiling, "static", {density=.1, bounce = 0.1, friction = .2 } )
	--physics.addBody(theFloor, "static", {density=.1, bounce = 0.1, friction = .2 } )
	--physics.addBody(player, "static", {density=.1, bounce = 1, friction = .2, radius = 12 } )	
	
	-- Group Insertion
	--insertaAlGrupo( screenGroup, background, backImg, backImg2, frontImg, frontImg2, player, enemy1, enemy2, enemy3, enemyL1, enemyL2 )
	--insertaAlGrupo( screenGroup, ceiling, theFloor, explosion)
	
	-- score
	--scoreText = display.newText( screenGroup, "0", display.contentCenterX, display.contentCenterY - 115, native.systemFontBold )
	--scoreText:setFillColor( .95, .33, 0 )
		
	-- Initial Text
	InitText = display.newText( sceneGroup, "FlyPastor", display.contentCenterX, display.contentCenterY - 50, native.systemFontBold, 90 )
	HoldText = display.newText( sceneGroup, "Hold to play", display.contentCenterX, display.contentCenterY + 50, native.systemFontBold, 40 )	
	InitText:setFillColor( .95, .33, 0 )
	HoldText:setFillColor( .95, .33, 0 )
	
	--SOUNDS
	soundTable = {
		scoreSound = audio.loadSound( "what_is_love_8_bit.mp3" ),
		explosionSound = audio.loadSound( "explosion.wav" )
	}
end


--------------------------------------------------------------------------------------
-- SCENES CREATION
--------------------------------------------------------------------------------------

scene:addEventListener("create", scene)

--------------------------------------------------------------------------------------

return scene