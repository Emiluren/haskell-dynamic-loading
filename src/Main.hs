{-# LANGUAGE OverloadedStrings, MagicHash, UnboxedTuples #-}
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
    loadObj "Plugin.o"
    _ret <- resolveObjs
    ptrF <- lookupSymbol (mangleSymbol Nothing "Plugin" "f")
    ptrG <- lookupSymbol (mangleSymbol Nothing "Plugin" "g")
    ptrH <- lookupSymbol (mangleSymbol Nothing "Plugin" "h")
    case ptrF of
        Nothing -> putStrLn "Couldn’t load f"
        Just (Ptr addr) -> case addrToAny# addr of
                               (# hval #) -> putStrLn (hval :: String)
    case ptrG of
        Nothing -> putStrLn "Couldn’t load g"
        Just (Ptr addr) -> case addrToAny# addr of
                               (# hval #) -> hval :: IO ()
    case ptrH of
        Nothing -> putStrLn "Couldn’t load h"
        Just (Ptr addr) -> case addrToAny# addr of
                               (# hval #) -> print (hval :: Int)

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
