import "../tlv_elements/tlv_element.dart";

extension TlvElementsEncoding on Iterable<TlvElement> {
  Iterable<int> encode() sync* {
    for (final tlvElement in this) {
      yield* tlvElement.encode();
    }
  }
}
