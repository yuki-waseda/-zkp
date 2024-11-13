from nacl.signing import SigningKey
from nacl.encoding import RawEncoder

# 鍵ペアの生成
signing_key = SigningKey.generate()
verify_key = signing_key.verify_key

# メッセージ（チャレンジ値）の設定
message = b"1234567890"

# 署名の生成
signature = signing_key.sign(message, encoder=RawEncoder).signature

# 公開鍵の取得
public_key_bytes = verify_key.encode(encoder=RawEncoder)

# R8とSの取得
# R8は署名の前半と後半を使って表現する
R8 = [signature[:len(signature)//2].hex(), signature[len(signature)//2:].hex()]

# Sとして署名全体を使用
S = signature.hex()

# 公開鍵（pk）を前半と後半に分割
pk = [public_key_bytes[:len(public_key_bytes)//2].hex(), public_key_bytes[len(public_key_bytes)//2:].hex()]

# 結果の出力
print("R8:", R8)
print("S:", S)
print("pk:", pk)

