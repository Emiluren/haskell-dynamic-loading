{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Concurrent (threadDelay)
import Foreign.C.Types
import SDL.Vect
import qualified SDL
import System.Random

screenWidth, screenHeight :: CInt
(screenWidth, screenHeight) = (640, 480)

main :: IO ()
main = do
  SDL.initialize [SDL.InitVideo]

  window <- SDL.createWindow
    "Yolo med mycket swag"
    SDL.defaultWindow
    { SDL.windowInitialSize = V2 screenWidth screenHeight }

  SDL.showWindow window

  threadDelay 2000000

  SDL.destroyWindow window
  SDL.quit

randChallenge :: Int -> Int -> IO ()
randChallenge minv maxv = do
  stdGen <- newStdGen

  let tenRandom = take 10 $ randomRs (0 :: Int, 100) stdGen
      inInterval = filter (\x -> x >= minv && x <= maxv) tenRandom

  putStrLn $ "Picked values " ++ show tenRandom
  putStrLn $ show (length inInterval) ++ " values in interval: " ++ show inInterval

