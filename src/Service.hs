module Service(trade,record,query,pay,sign) where

import Control.Monad.State
import Control.Monad.Reader
import Control.Monad.Writer
import Control.Monad.Trans(liftIO)
import Type
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

refund :: OrderId -> Amount -> IO PayResponse
refund orderId amount = do
    record <- findPaidRecord orderId
    let resp = request.unifiedRefund $ ["out_trade_no" .- (tradeNo record)
                                       ,"out_refund_no" .- "2017lll"
                                       ,"total_fee" .- (show $ tradeAmount record)
                                       ,"refund_fee" .- (show amount)
                                       ,wxOpUserId]
    return $ WxRefundResponse resp

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

query :: String -> IO ServiceResponse
query tradeNo = do
    let resp = request.orderQuery $ ["out_trade_no" .- tradeNo]
    case resp of
        Nothing -> return $ ServiceResponse ERR (Just 1005) (Just "Network Timeout") Nothing
        Just r -> return $ ServiceResponse OK Nothing Nothing resp

trade :: TradeRecord -> Trade a -> (a,TradeState)
trade r t = runState (runReaderT t r) APPLY

findPaidRecord :: String -> IO TradeRecord
findPaidRecord no = return (TradeRecord {
    tradeNo = no,
    tradeAmount = 10,
    tradeType = ORDER,
    tradePayMethod = WX,
    tradePayChannel = TERMINAL,
    tradeRefundNo = Nothing,
    tradeDate = 1400678
})