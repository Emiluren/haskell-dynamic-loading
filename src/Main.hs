{-# LANGUAGE OverloadedStrings, MagicHash, UnboxedTuples #-}
module Main where

import qualified API

import Foreign.C.String ( withCString, CString )
import GHC.Exts ( addrToAny# )
import GHC.Ptr ( Ptr(..), nullPtr )
import System.Info ( os, arch )
import Encoding ( zEncodeString )
import Data.Maybe ( fromMaybe )

main :: IO ()
main = do
    mF <- loadFunction Nothing "Main" "f" :: IO (Maybe String)
    print mF

    mG <- loadFunction Nothing "Main" "g" :: IO (Maybe (IO ()))
    fromMaybe (putStrLn "Could not load g") mG

f :: String
f = "works"

g :: IO ()
g = putStrLn "hej"

loadFunction :: Maybe String -> String -> String -> IO (Maybe a)
loadFunction mpkg m valsym = do
    c_initLinker
    let symbol = prefixUnderscore
            ++ maybe "" (\p -> zEncodeString p ++ "_") mpkg
            ++ zEncodeString m ++ "_" ++ zEncodeString valsym
            ++ "_closure"
    ptr@(Ptr addr) <- withCString symbol c_lookupSymbol
    if ptr == nullPtr then
        return Nothing
    else
        case addrToAny# addr of
            (# hval #) -> return ( Just hval )
    where
        prefixUnderscore = case (os, arch) of
            ("mingw32", "x86_64") -> ""
            ("cygwin" , "x86_64") -> ""
            ("mingw32", _       ) -> "_"
            ("darwin" , _       ) -> "_"
            ("cygwin" , _       ) -> "_"
            _ -> ""

foreign import ccall safe "lookupSymbol" c_lookupSymbol :: CString -> IO (Ptr a)
foreign import ccall safe "initLinker" c_initLinker :: IO ()
