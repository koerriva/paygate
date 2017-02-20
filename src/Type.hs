module Type where

import Control.Monad.Reader
import Control.Monad.State
import Control.Monad.Writer

type Amount = Int
type TradeNo = String
type OrderId = String
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
                 | WxRefundResponse (Maybe String)
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

type ApiUrl = String
type ApiParams = Params
data Api = WxApi ApiUrl ApiParams
         | AliApi ApiUrl ApiParams deriving(Show,Eq)