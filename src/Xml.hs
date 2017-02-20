module Xml where

import Control.Monad
import Control.Monad.Writer
import Text.ParserCombinators.Parsec
import Type

xml :: Parser Params
xml = do
    string "<xml>"
    v <- manyTill tag $ (try $ string "</xml>")
    return v

tags :: Parser Params
tags = many tag

tag :: Parser Param
tag = do
    char '<'
    name <- manyTill (noneOf "</>") $ (try $ char '>')
    optional (string "<![CDATA[")
    value <- many (noneOf "</>]")
    optional (string "]]>")
    string "</"
    name <- manyTill (noneOf "</>") $ (try $ char '>')
    optional (many newline)
    return (name,value)

readXml :: String -> Parser a -> a
readXml xml p = case parse p xml xml of
    Left err -> error $ show err
    Right s -> s

(\->) :: String -> Parser a -> a
(\->) = readXml