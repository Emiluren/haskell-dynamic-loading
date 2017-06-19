module API where

import qualified Data.Dynamic as Dynamic

data Null = Null { a, b :: Int} deriving (Dynamic.Typeable, Show)

null :: Null
null = Null { a = 42, b = 1 }
