module Utils(safeMD5,md5) where

import Data.Maybe
import Type

foreign import java unsafe "@static Utils.getMD5"
    safeMD5 :: String -> Maybe String

md5 :: String -> String
md5 = fromJust . safeMD5


lookAhead :: Key -> Params -> Maybe Param
lookAhead k ls = let r = filter (\(k',v') -> k==k') ls in
    case length r  of
        0 -> Nothing
        _ -> Just (head r)