from nacl.signing import SigningKey
from nacl.encoding import RawEncoder

# 1. メッセージとチャレンジの定義
message = b"12345"
challenge = 8021736478792514890663833972174837831448181730803016400734754308028816293550
# 2. 秘密鍵と公開鍵の生成
signing_key = SigningKey.generate()
verify_key = signing_key.verify_key

# 公開鍵の座標を取得（pk[0], pk[1]）
def get_public_key_coords(verify_key):
    # 公開鍵を32バイトのバイト列に変換し、前半と後半をx, y座標に分割
    key_bytes = verify_key.encode(RawEncoder)
    pk_x = int.from_bytes(key_bytes[:16], "big")
    pk_y = int.from_bytes(key_bytes[16:], "big")
    return pk_x, pk_y

pk_x, pk_y = get_public_key_coords(verify_key)

# 3. EdDSA署名の生成
signature = signing_key.sign(message).signature

# 署名の一部からR8x, R8yを取得
def get_signature_coords(signature):
    # 署名をバイト列で受け取り、前半と後半をx, y座標に分割
    R8x = int.from_bytes(signature[:16], "big")
    R8y = int.from_bytes(signature[16:32], "big")
    return R8x, R8y

R8x, R8y = get_signature_coords(signature)

# Sを署名全体の整数値として設定
S = int.from_bytes(signature, "big")

# Circomの検証に使用するデータ
print("challenge:", challenge)
print("R8:", [R8x, R8y])
print("S:", S)
print("pk:", [pk_x, pk_y])

