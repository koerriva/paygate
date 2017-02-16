module Type where

import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer
-- import Data.HashMap
-- import Data.Binary.Generic

data TradeState = APPLY | SUCCESS | FAIL | EXCEPT deriving(Show,Eq)
data TradeType = ORDER | REFUND | CHARGE deriving(Show,Eq)
data PayMethod = WX | ALI | BALANCE deriving(Show,Eq)
data PayChannel = H5 | APP | TERMINAL deriving(Show,Eq)
data TradeRecord = TradeRecord {
    tradeNo::String,
    tradeAmount::Int,
    tradeType::TradeType,
    tradePayMethod::PayMethod,
    tradePayChannel::PayChannel,
    tradeRefundNo::Maybe String,
    tradeDate::Integer
} deriving(Show,Eq)

type Trade = ReaderT TradeRecord (State TradeState)

data ServiceState = OK | ERR deriving(Show,Eq)
type ServiceErrNo = Maybe Int
type ServiceErrMsg = Maybe String
type ServiceData = Maybe String

data ServiceResponse = ServiceResponse ServiceState ServiceErrNo ServiceErrMsg ServiceData
                    deriving(Show,Eq)

data PayResponse = UnifiedOrderResponse
                 | WxRefundResponse
                 | AliPayResponse
                 | BalancePayResponse
                 | ChargeResponse
                 deriving(Show,Eq)

data QueryResponse = OrderQueryResponse Params
                 deriving(Show,Eq)

data PayRequest = UnifiedOrder Params
                deriving(Show,Eq)

type Key = String
type Value = String
type Param = (Key,Value)
type Params = [Param]
type RequestBody = Writer Params

data AppConfig = AppConfig {
    wxAppId::String,
    wxAppSecret::String,
    wxPartnerKey::String,
    wxMchId::String
} deriving(Show,Eq)

type QueryRequest = ReaderT (TradeRecord,AppConfig) RequestBody

-- class Xml a where
--     toXml :: a -> String
--     fromXml :: String -> a
--
-- instance Xml QueryResponse where
--     toXml (OrderQueryResponse params) = (\s -> "<xml>"++s++"</xml>") $ concat $ map (\(k,v) -> "<"++k++">"++v++"</"++k++">") params
--     fromXml xml = OrderQueryResponse []
--
-- instance Xml QueryRequest where
--     toXml (OrderQuery params) = (\s -> "<xml>"++s++"</xml>") $ concat $ map (\(k,v) -> "<"++k++">"++v++"</"++k++">") params
--     fromXml xml = OrderQuery []