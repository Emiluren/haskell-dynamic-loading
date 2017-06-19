module TestPlugin ( resource, resourceDyn ) where

import API
import Data.Dynamic
import Prelude hiding (null)

resource :: Null
resource = null

resourceDyn :: Dynamic
resourceDyn = toDyn resource
