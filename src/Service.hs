module Service(trade,record,query,pay,sign) where

import Control.Monad.State
import Control.Monad.Reader
import Control.Monad.Writer
import Control.Monad.Trans(liftIO)
import Data.Char(toUpper)
import Type
import Http
import Utils
import Config

record :: TradeRecord
record = TradeRecord {
    tradeNo = "20170214372419268805",
    tradeAmount = 10,
    tradeType = ORDER,
    tradePayMethod = WX,
    tradePayChannel = TERMINAL,
    tradeRefundNo = Nothing,
    tradeDate = 1400678
}

order :: Trade PayResponse
order = do
    record <- ask
    put SUCCESS
    return UnifiedOrderResponse

refund :: Trade PayResponse
refund = do
    put FAIL
    return WxRefundResponse

charge :: Trade PayResponse
charge = do
    put FAIL
    return ChargeResponse

route :: TradeType -> Trade ServiceResponse
route ORDER = do
    resp <- order
    return (ServiceResponse OK Nothing Nothing Nothing)
route _ = return $ ServiceResponse ERR (Just 1002) (Just "Not Ready!") Nothing

pay :: Trade ServiceResponse
pay = route =<< (\record -> return (tradeType record)) =<< ask

query :: Trade ServiceResponse
query = do
    record <- ask
    put SUCCESS
    let resp = (post "https://api.mch.weixin.qq.com/pay/orderquery").toXml.(\r -> requestBody r config sign) $ record
    case resp of
        Nothing -> return $ ServiceResponse ERR (Just 1005) (Just "Network Timeout") Nothing
        Just r -> return $ ServiceResponse OK Nothing Nothing resp

trade :: TradeRecord -> Trade a -> (a,TradeState)
trade r t = runState (runReaderT t r) APPLY

requestBody :: TradeRecord -> AppConfig -> QueryRequest a -> Params
requestBody record cfg q = execWriter $ runReaderT q (record,cfg)

sign :: QueryRequest ()
sign = do
    (_,cfg) <- ask
    (_,params) <- listen wxReq
    (param "sign").(map toUpper).md5.(\s -> s++"&key="++(wxPartnerKey cfg)).str.sort $ params
    where
        wxReq :: QueryRequest ()
        wxReq = do
            (r,cfg) <- ask
            param "appid" $ wxAppId cfg
            param "mch_id" $ wxMchId cfg
            param "nonce_str" "a52715b50a0e4b11872478fed27728cb"
            param "out_trade_no" $ tradeNo r
        param :: String -> String -> QueryRequest ()
        param k v = tell [(k,v)]
        sort :: Params -> Params
        sort [] = []
        sort (param:[]) = [param]
        sort (p1:p2:ls) = if p1 < p2 then p1:(sort (p2:ls)) else p2:(sort (p1:ls))
        str :: Params -> String
        str [] = ""
        str (param@(key,value):[]) = key++"="++value
        str (param:ls) = str [param] ++ "&" ++ str ls

toXml :: Params -> String
toXml params = (\s -> "<xml>"++s++"</xml>") $ concat $ map (\(k,v) -> "<"++k++">"++v++"</"++k++">") params