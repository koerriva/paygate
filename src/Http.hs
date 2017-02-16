{-# LANGUAGE MagicHash, FlexibleContexts, DataKinds, TypeFamilies #-}
module Http(get,post) where

import Java

foreign import java unsafe "@static HttpsRequest.get"
  get :: String -> Maybe String
foreign import java unsafe "@static HttpsRequest.post"
  post :: String -> String -> Maybe String
