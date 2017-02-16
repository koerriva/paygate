module Utils(safeMD5,md5) where

import Data.Maybe

foreign import java unsafe "@static Utils.getMD5"
    safeMD5 :: String -> Maybe String

md5 :: String -> String
md5 = fromJust . safeMD5
