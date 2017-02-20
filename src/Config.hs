module Config where
import Type
import Http
import Data.Char(toUpper)
import Utils

wxAppId :: Param
wxAppId = "appid" .- "wx9fb2f7af44615e6a"
wxNonceStr :: Param
wxNonceStr = "nonce_str" .- "a52715b50a0e4b11872478fed27728cb"
wxMchId :: Param
wxMchId = "mch_id" .- "1262986701"
wxOpUserId :: Param
wxOpUserId = "op_user_id" .- "1262986701"

wxAppSecret="67dabc477a500dac020384868e4f6c55"
wxPartnerKey="DAYupsgxysjlhhxszs09171435JACKok"

commonParams = [wxAppId,wxMchId,wxNonceStr]

unifiedOrder :: ApiParams -> Api
unifiedOrder params = WxApi "https://api.mch.weixin.qq.com/pay/unifiedorder" (sign $ params ++ commonParams)
orderQuery :: ApiParams -> Api
orderQuery params = WxApi "https://api.mch.weixin.qq.com/pay/orderquery" (sign $ params ++ commonParams)
unifiedRefund :: ApiParams -> Api
unifiedRefund params = WxApi "https://api.mch.weixin.qq.com/secapi/pay/refund" (sign $ params ++ commonParams)
refundQuery :: ApiParams -> Api
refundQuery params = WxApi "https://api.mch.weixin.qq.com/pay/refundquery" (sign $ params ++ commonParams)

toXml :: Params -> String
toXml ps = (\s -> "<xml>"++s++"</xml>") $ concat $ map (\(k,v) -> "<"++k++">"++v++"</"++k++">") ps

request :: Api -> Maybe String
request (WxApi url params) = post url (toXml params)
request (AliApi url params) = post url (toXml params)

sign :: Params -> Params
sign params = (params >+).("sign" .-).(map toUpper).md5.(\s -> s++"&key="++wxPartnerKey).toStr.sort $ params

(>+) :: Params -> Param -> Params
(>+) ps p = ps ++ [p]
(.-) :: String -> String -> Param
(.-) k v = (k,v)

sort :: Params -> Params
sort [] = []
sort (param:[]) = [param]
sort (p1:p2:ls) = if p1 < p2 then p1:(sort (p2:ls)) else p2:(sort (p1:ls))

toStr :: Params -> String
toStr [] = ""
toStr (param@(key,value):[]) = key++"="++value
toStr (param:ls) = toStr [param] ++ "&" ++ toStr ls