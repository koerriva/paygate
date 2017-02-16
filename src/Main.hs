module Main where

import Control.Monad.Writer
import Control.Monad.Reader
import Control.Monad.State
import Service
import Http
import Xml

main = do
--     print $ runApp AppConfig{name="notify server",version=(1,0,0),port=3000} $ app >> ask
--     print $ trade record $ pay
--     print $ trade record $ query
--     print $ genXml $ appid >> mch_id
    print $ readXml "<xml><appid><![CDATA[12xx]]></appid></xml>" content

-- monad 示例 --
data AppConfig = AppConfig {
    name::String,
    version::(Int,Int,Int),
    port::Int
} deriving(Show,Eq)
data AppState = RUNNING | STOP deriving(Show,Eq)
type App = ReaderT AppConfig (State AppState)

app :: App Int
app = do
    put RUNNING
    put STOP
    return 0

runApp config app = runState (runReaderT app config) STOP


type Param = (String,String)
type Xml = Writer [Param]

appid :: Xml ()
appid = do
    tell [("appid","122")]
    return ()
mch_id :: Xml Int
mch_id = do
    tell [("mch_id","122")]
    return 0

genXml :: Xml a -> [Param]
genXml = execWriter