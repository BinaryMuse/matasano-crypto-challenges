def hex_to_str(str)
  [str].pack("H*")
end

def str_to_hex(str)
  str.unpack("H*").join
end

def base64_to_str(str)
  str.unpack("m0").join
end

def str_to_base64(str)
  [str].pack("m0")
end

def repeating_xor_cipher(plaintext, key)
  plain_bytes = plaintext.bytes
  key_cycle   = key.bytes
  key_bytes   = []
  plain_bytes.each do |byte|
    key_bytes << key_cycle[0]
    key_cycle.rotate!
  end

  zipped = plain_bytes.zip(key_bytes)
  zipped.map { |a, b| a ^ b }.map(&:chr).join
end
