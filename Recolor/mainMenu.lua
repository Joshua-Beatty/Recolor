
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local function playButtonTouchListener( event )

	if ( event.phase == "began" ) then
		display.getCurrentStage():setFocus( event.target )
		event.target:setFillColor( 0.9 )

	elseif ( event.phase == "ended" ) then
		display.getCurrentStage():setFocus( nil )

	composer.gotoScene( "game" )
		event.target:setFillColor( 1 )

	end
end
local function playButtonTouchListener1( event )

	if ( event.phase == "began" ) then
		display.getCurrentStage():setFocus( event.target )
		event.target:setFillColor( 0.9 )

	elseif ( event.phase == "ended" ) then
		display.getCurrentStage():setFocus( nil )

	composer.gotoScene( "game1" )
		event.target:setFillColor( 1 )

	end
end



local highscore
local highscore1

local filePath = system.pathForFile( "highScore.txt", system.DocumentsDirectory )
local filePath1 = system.pathForFile( "highScore1.txt", system.DocumentsDirectory )

local function saveScores(pathOfFile, newscore)

	local file = io.open( pathOfFile, "w" )

	if file then
		file:write(newscore)
		io.close( file )
	end
end
local function loadScores(pathOfFile)

	local file = io.open( pathOfFile, "r" )

	if file then
		 newthing = file:read( "*a" )
		io.close( file ) 

	end

	if (newthing == nil) then
		saveScores(pathOfFile, 0)
		return loadScores(pathOfFile)

	end
	return newthing
end




--saveScores(filePath, 0) saveScores(filePath1, 0)

highscore = loadScores(filePath)
highscore1 = loadScores(filePath1)

--------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
		-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect(sceneGroup, "background.png",  display.actualContentHeight,  display.actualContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local playButton = display.newRoundedRect(sceneGroup,  display.contentCenterX, display.contentCenterY * .9, 600, 225, 75)
	playButton:addEventListener( "touch", playButtonTouchListener )
	playButton.strokeWidth = 8
	playButton:setStrokeColor(0)

	local playText = display.newText(sceneGroup, "Easy", display.contentCenterX, display.contentCenterY * 0.9, "Zekton Bold.ttf", 150 )
	playText:setFillColor(  0 )

	local playButton1 = display.newRoundedRect(sceneGroup,  display.contentCenterX, display.contentCenterY * 1.4, 600, 225, 75)
	playButton1:addEventListener( "touch", playButtonTouchListener1 )
	playButton1.strokeWidth = 8
	playButton1:setStrokeColor(0)

	local playText1 = display.newText(sceneGroup, "Hard", display.contentCenterX, display.contentCenterY * 1.4, "Zekton Bold.ttf", 150 )
	playText1:setFillColor(  0 )


	local highScoreText = display.newText(sceneGroup, "Highscore: " .. highscore1, display.contentCenterX, display.contentCenterY * 1.6, "Zekton Bold.ttf", 125 )
	highScoreText:setFillColor(  1 )

	local highScoreText = display.newText(sceneGroup, "Highscore: " .. highscore, display.contentCenterX, display.contentCenterY * 1.1, "Zekton Bold.ttf", 125 )
	highScoreText:setFillColor(  1 )

	local logo = display.newImageRect(sceneGroup, "logo.png",  800*1.2,  150*1.2)
	logo.x = display.contentCenterX
	logo.y = display.contentCenterY * .4 
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
