module Game where

import Control.Concurrent (threadDelay)
import Foreign.C.Types
import SDL.Vect
import qualified SDL
import System.Random

screenWidth, screenHeight :: CInt
(screenWidth, screenHeight) = (640, 480)

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
