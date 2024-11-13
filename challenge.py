from nacl.signing import SigningKey
message = b"1234567890"
print([int.from_bytes(message, "big")])
