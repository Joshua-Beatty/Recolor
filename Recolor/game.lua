
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------


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



--saveScores(0)
highscore = loadScores(filePath)
highscore1 = loadScores(filePath1)

-----------
local gameState = "starting"
local buttonArray = {}
local buttonArraySize = 0
composer.recycleOnSceneChange = true

local function setDefaultColor(buttonRefrence)
	buttonRefrence:setFillColor(  buttonRefrence.fillColor[1], buttonRefrence.fillColor[2], buttonRefrence.fillColor[3])
end



local function play(button)
	audio.play(button.sound)
	button:setFillColor(  button.fillColor[1] + .7, button.fillColor[2] + .7, button.fillColor[3] + .7 )
	local myClosure = function() return setDefaultColor( button ) end
	local tm = timer.performWithDelay(500, myClosure, 1)

end

local function tapBlock(event)
	return true

end

local function setText(textObject, text)
	textObject.text = text;
end
local function disable(object)
	object:removeSelf()
end


local function setgamestate(state)
	gameState = state
	print(state)
end

buttons = {}
wherePlayer = 1

local function listening()
	buttonArraySize = buttonArraySize + 1
	table.insert(buttonArray, math.random(1,4))

	clouseres = {}	
	for i, v in ipairs(buttonArray) do
		table.insert(clouseres, function() return play(buttons[v]) end)
		local tm = timer.performWithDelay(600 * i, clouseres[i], 1)
	end

	closer = function() return  setgamestate("playing") end
	local tm = timer.performWithDelay(600 * buttonArraySize + 500, closer)

	wherePlayer = 1
end
local function start(textObject)
	local myClosure1 = function() return setText( textObject, "2" ) end
	timer.performWithDelay(500, myClosure1, 1)
	local myClosure2 = function() return setText( textObject, "1") end
	timer.performWithDelay(1000, myClosure2, 1)
	local myClosure3 = function() return disable(textObject) end
	timer.performWithDelay(1500, myClosure3, 1)
	local myClosure4 = function() return listening() end
	timer.performWithDelay(1500, myClosure4)

end

local darkScreen1
local backbutton1
local backbuttontext1

local function setupGameEnd(darken, backButtonRef, back)
	darkScreen1 = darken
	backbutton1 = backButtonRef
	backbuttontext1 = back

end

local score
local function tada(thing)
	score = thing
end

local function gameEnding()
	darkScreen1.isVisible = true
	backbutton1.isVisible = true
	backbuttontext1.isVisible = true
	if(score.num > tonumber(highscore)) then
		highscore = tostring(score.num)
		saveScores(filePath, highscore)
		saveScores(filePath1, highscore1)

	end


end

began = false
local function playButtonTouchListener( event )
	
	if ( event.phase == "began" ) then
		display.getCurrentStage():setFocus( event.target )
		event.target:setFillColor( 0.9 )
		print("began")
		began = true

	elseif ( event.phase == "ended" and began) then
		display.getCurrentStage():setFocus( nil )
		event.target:setFillColor( 1 )
	composer.gotoScene( "mainMenu" )

	end
end


local function darken(event)
		if ( event.phase == "began" and gameState == "playing") then
		event.target.TouchStarted = true
		event.target:setFillColor(  event.target.fillColor[1] - .3 , event.target.fillColor[2] - .3, event.target.fillColor[3] - .3 )
		display.getCurrentStage():setFocus( event.target )

	elseif ( event.phase == "ended"  and gameState == "playing" and event.target.TouchStarted == true) then
		event.target.TouchStarted = false
		display.getCurrentStage():setFocus( nil )
		event.target:setFillColor( unpack(event.target.fillColor) )
		
		if(event.target.id == buttonArray[wherePlayer]) then


			wherePlayer = wherePlayer + 1
			audio.play(event.target.sound)

			if(wherePlayer == buttonArraySize + 1) then
				setgamestate("listening")

				local closure = function() return listening() end

				score.text = "Score: " .. tostring(wherePlayer - 1)
				score.num = wherePlayer - 1
				timer.performWithDelay(300, closure)
			end


		else
			audio.play(audio.loadSound("a-3.mp3"))
			audio.play(audio.loadSound("g3.mp3"))
			audio.play(audio.loadSound("f4.mp3"))
			setgamestate("ended")
			gameEnding()

		end

	end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	gameState = "starting"

	local background = display.newImageRect(sceneGroup, "background.png",  display.actualContentHeight,  display.actualContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local buttonOne = display.newRoundedRect(sceneGroup,  display.contentCenterX- 225, display.contentCenterY - 100, 400, 400, 100)
	buttonOne:addEventListener( "touch", darken )
	buttonOne.strokeWidth = 15
	buttonOne:setStrokeColor(0)
	buttonOne:setFillColor(1, 1, 0)
	buttonOne.fillColor = {1, 1, 0}
	buttonOne.id = 1
	buttonOne.sound = audio.loadSound("c4.mp3")

	local buttonTwo = display.newRoundedRect(sceneGroup,  display.contentCenterX+ 225, display.contentCenterY - 100, 400, 400, 100)
	buttonTwo:addEventListener( "touch", darken )
	buttonTwo.strokeWidth = 15
	buttonTwo:setStrokeColor(0)
	buttonTwo:setFillColor(0,0,1)
	buttonTwo.fillColor = {0, 0, 1}
	buttonTwo.id = 2
	buttonTwo.sound = audio.loadSound("d4.mp3")

	local buttonThree = display.newRoundedRect(sceneGroup,  display.contentCenterX- 225, display.contentCenterY + 350, 400, 400, 100)
	buttonThree:addEventListener( "touch", darken )
	buttonThree.strokeWidth = 15
	buttonThree:setStrokeColor(0)
	buttonThree:setFillColor(1,0,0)
	buttonThree.fillColor = {1, 0, 0}
	buttonThree.id = 3
	buttonThree.sound = audio.loadSound("e4.mp3")

	local buttonFour = display.newRoundedRect(sceneGroup,  display.contentCenterX+ 225, display.contentCenterY + 350, 400, 400, 100)
	buttonFour:addEventListener( "touch", darken )
	buttonFour.strokeWidth = 15
	buttonFour:setStrokeColor(0)
	buttonFour:setFillColor(0,1,0)
	buttonFour.fillColor = {0, 1, 0}
	buttonFour.id = 4
	buttonFour.sound = audio.loadSound("f4.mp3")

	local countDownText = display.newText(sceneGroup, "3", display.contentCenterX, display.contentCenterY, "Zekton Bold.ttf", 400 )
	countDownText:setFillColor(1)

	local darkenScreen = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentHeight, display.actualContentHeight)
	darkenScreen:setFillColor(0,0,0,.8)
	darkenScreen.isVisible = false
	darkenScreen:addEventListener("tap", tapBlock)
	darkenScreen:addEventListener("touch", tapBlock)

	local backButton = display.newRoundedRect(sceneGroup,  display.contentCenterX, display.contentCenterY * 1.33, 600, 225, 75)
	backButton:addEventListener( "touch", playButtonTouchListener )
	backButton.strokeWidth = 8
	backButton:setStrokeColor(0)
	backButton.isVisible = false

	local backText = display.newText(sceneGroup, "Back", display.contentCenterX, display.contentCenterY * 1.32, "Zekton Bold.ttf", 150 )
	backText:setFillColor(  0 )
	backText.isVisible = false

	setupGameEnd(darkenScreen, backButton, backText)

	local scoreText = display.newText(sceneGroup, "Score: 0", display.contentCenterX, 400, "Zekton Bold.ttf", 170 )
	scoreText:setFillColor(1)
	scoreText.num = 0
	tada(scoreText)


	buttons = {buttonOne, buttonTwo, buttonThree, buttonFour}

	start(countDownText)
	highscore = loadScores(filePath)
	highscore1 = loadScores(filePath1)
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
