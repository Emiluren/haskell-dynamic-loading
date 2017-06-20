module Game (pluginMain) where

import Control.Concurrent (threadDelay)
import Foreign.C.Types
import SDL.Vect
import qualified SDL
import System.Random

import qualified API

screenWidth, screenHeight :: CInt
(screenWidth, screenHeight) = (640, 480)

pluginMain :: IO API.Program
pluginMain = do
    initModel <- gameInit
    return API.Program { API.init = initModel
                       , API.update = gameUpdate
                       , API.draw = gameDraw
                       }

gameInit :: IO API.Model
gameInit = do
    putStrLn "initing"
    return API.Model {}

gameUpdate :: API.Model -> IO API.Model
gameUpdate model = do
    putStrLn "hej"
    return model

gameDraw :: API.Model -> IO ()
gameDraw model = putStrLn "Drawing"

-- main :: IO ()
-- main = do
--   SDL.initialize [SDL.InitVideo]

--   window <- SDL.createWindow
--     "Yolo med mycket swag"
--     SDL.defaultWindow
--     { SDL.windowInitialSize = V2 screenWidth screenHeight }

--   SDL.showWindow window

--   threadDelay 2000000

--   SDL.destroyWindow window
--   SDL.quit
