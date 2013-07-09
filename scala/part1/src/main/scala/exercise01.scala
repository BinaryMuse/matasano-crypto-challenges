// 1. Convert hex to base64 and back.
//
// The string:
//
//     49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d
//
// should produce:
//
//     SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t

import matasano.StringImprovements._

object Exercise01 extends App {
  val hex = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
  println(s"Converting: $hex")
  println(s"        to: ${hex.fromHex.toBase64}")
}
