package matasano

import sun.misc.BASE64Encoder

object StringImprovements {

  implicit class StringOps(val s: String) {
    val encoder = new BASE64Encoder

    def fromHex: String = {
      val grouped = s.grouped(2)
      val bytes = grouped.map(Integer.parseInt(_, 16))
      bytes.map(_.toChar).mkString
    }

    def toBase64: String = encoder.encode(s.getBytes)
  }

}
