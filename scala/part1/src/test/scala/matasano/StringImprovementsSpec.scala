import org.scalatest.FunSpec
import matasano.StringImprovements._

class StringImprovementsSpec extends FunSpec {
  describe("A string") {

    it("can convert from hex") {
      val s = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
      assert(s.fromHex === "I'm killing your brain like a poisonous mushroom")
    }

    it("can convert to base64") {
      val s = "I'm killing your brain like a poisonous mushroom"
      assert(s.toBase64 === "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t")
    }

  }
}
