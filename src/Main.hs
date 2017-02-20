module Main where

import Control.Monad
import Control.Monad.Writer
import Control.Monad.Reader
import Control.Monad.State
import Data.Maybe
import Service
import Http
import Xml
import Type

main = do
--     print $ runApp AppConfig{name="notify server",version=(1,0,0),port=3000} $ app >> ask
--     print $ trade record $ pay
    (ServiceResponse _ _ _ resp) <- query "20170214372419268805"
    print $ fromJust resp \-> xml
--     print $ genXml $ appid >> mch_id
--     print $ "<xml><appid><![CDATA[12xx]]></appid>\n\n<appid>12xx</appid></xml>\n<appid><![CDATA[]]></appid></xml>" \-> xml