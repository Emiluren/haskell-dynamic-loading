{-# LANGUAGE MagicHash, UnboxedTuples #-}
module Main where

import qualified API

import GHC.Exts ( addrToAny# )
import GHC.Ptr ( Ptr(..) )
import System.Info ( os, arch )
import Encoding ( zEncodeString )
import GHCi.ObjLink

main :: IO ()
main = do
    initObjLinker
    loadObj "Game.o"
    _ret <- resolveObjs

    mPluginMain <- loadV "pluginMain"
    case mPluginMain of
        Nothing -> putStrLn "Couldn’t load pluginMain"
        Just pluginMain -> do
            prog <- pluginMain
            let model = API.init prog
            model' <- API.update prog model
            API.draw prog model'

loadV :: String -> IO (Maybe a)
loadV name = do
    ptr <- lookupSymbol (mangleSymbol Nothing "Game" name)
    return $ fmap getV ptr
    where
        getV (Ptr addr) = case addrToAny# addr of
                              (# hval #) -> hval

mangleSymbol :: Maybe String -> String -> String -> String
mangleSymbol pkg module' valsym =
  prefixUnderscore ++
  maybe "" (\p -> zEncodeString p ++ "_") pkg ++
  zEncodeString module' ++ "_" ++ zEncodeString valsym ++ "_closure"

prefixUnderscore :: String
prefixUnderscore =
  case (os,arch) of
    ("mingw32","x86_64") -> ""
    ("cygwin","x86_64") -> ""
    ("mingw32",_) -> "_"
    ("darwin",_) -> "_"
    ("cygwin",_) -> "_"
    _ -> ""
