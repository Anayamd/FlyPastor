---------------------------------------------------------------------------------
--
-- restart.lua
--
---------------------------------------------------------------------------------

--------------------------------------------------------------------------------------
-- REQUIRES
--------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local mydata = require( "mydata" )
local score = require( "score" )

--------------------------------------------------------------------------------------
-- CREATE
--------------------------------------------------------------------------------------

function scene:create( event )
	
	local sceneGroup = self.view
	
	local background = display.newImageRect("images/bg.png", display.viewableContentWidth, display.viewableContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)
	
	gameOver = display.newImageRect("images/gameOver.png",500,100)
	gameOver.anchorY = 0
	gameOver.x = display.contentCenterX 
	gameOver.y = display.contentCenterY - 400
	gameOver.alpha = 0
	sceneGroup:insert(gameOver)
	
	scoreBg = display.newImageRect("images/menuBg.png",480,393)
    scoreBg.x = display.contentCenterX
    scoreBg.y = display.contentHeight + 500
    sceneGroup:insert(scoreBg)
	
	restart = display.newImageRect("images/start_btn.png",300,65)
	restart.anchorY = 1
	restart.x = display.contentCenterX
	restart.y = display.contentCenterY + 400
	restart.alpha = 0
	sceneGroup:insert(restart)
	
	scoreText = display.newText(mydata.score,display.contentCenterX + 110,
	display.contentCenterY - 60, native.systemFont, 50)
	scoreText:setFillColor(0,0,0)
	scoreText.alpha = 0 
	sceneGroup:insert(scoreText)
	
	bestText = score.init({
	fontSize = 50,
	font = "Helvetica",
	x = display.contentCenterX + 70,
	y = display.contentCenterY + 85,
	maxDigits = 7,
	leadingZeros = false,
	filename = "scorefile.txt",
	})
	bestScore = score.get()
	bestText.text = bestScore
	bestText.alpha = 0
	bestText:setFillColor(0,0,0)
	sceneGroup:insert(bestText)

end

--------------------------------------------------------------------------------------
-- FUNCTIONS
--------------------------------------------------------------------------------------

function restartGame( event )
	if event.phase == "ended" then
		saveScore()
		composer.gotoScene( "start" )
	end
end

function showStart()
	startTransition = transition.to(restart,{time=200, alpha=1})
	scoreTextTransition = transition.to(scoreText,{time=600, alpha=1})
	scoreTextTransition = transition.to(bestText,{time=600, alpha=1})
end

function showScore()
	scoreTransition = transition.to(scoreBg,{time=600, y=display.contentCenterY,onComplete=showStart})
end

function showGameOver()
	fadeTransition = transition.to(gameOver,{time=600, alpha=1,onComplete=showScore})
end

function loadScore()
    
	local prevScore = score.load()
	if prevScore ~= nil then
		if prevScore <= mydata.score then
			score.set(mydata.score)
		else 
			score.set(prevScore)
		end
	else 
		score.set(mydata.score)
	end
end

function saveScore()
	score.save()
end

--------------------------------------------------------------------------------------
-- SCENES
--------------------------------------------------------------------------------------

function scene:show( event )
	
	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
		-- Do nothing
	elseif ( phase == "did" ) then
		composer.removeScene( "game" )
		restart:addEventListener("touch", restartGame)
		showGameOver()
		loadScore()
	end
end

--------------------------------------------------------
function scene:hide( event )
	
	local sceneGroup = self.view
	local phase = event.phase
	
	if ( phase == "will" ) then
		restart:removeEventListener("touch", restartGame)
		transition.cancel(fadeTransition)
		transition.cancel(scoreTransition)
		transition.cancel(scoreTextTransition)
		transition.cancel(startTransition)
	elseif ( phase == "did" ) then
		-- Do nothing
	end	
end

--------------------------------------------------------
function scene:destroy( event )
	
	local sceneGroup = self.view
	-- Do nothing
end

--------------------------------------------------------------------------------------
-- SCENES CREATION
--------------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

--------------------------------------------------------------------------------------

return scene