#!/bin/sh
cd src
stack exec -- ghc -package ghc -rdynamic Game.hs -odir ../build -hidir ../build
stack exec -- ghc -package ghc -rdynamic Main.hs -odir ../build -hidir ../build -o ../build/gmae
