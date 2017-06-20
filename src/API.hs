module API where

data Model = Model {}

data Program =
    Program { init :: Model
            , update :: Model -> IO Model
            , draw :: Model -> IO ()
            }
