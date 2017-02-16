module Xml(readXml,content) where

import Text.ParserCombinators.Parsec

content :: Parser String
content = do
    string "<xml>"
    v <- many $ noneOf (string "</xml>")
    string "</xml>"
    return v

readXml :: String -> Parser a -> String
readXml xml p = case parse content xml xml of
    Left err -> error $ show err
    Right s -> s