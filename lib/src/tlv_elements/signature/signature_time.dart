import "../../extensions/non_negative_integer.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";

final class SignatureTime extends KnownTlvElement {
  const SignatureTime(this.signatureTime);

  factory SignatureTime.fromValue(List<int> value) {
    final decodedValue = NonNegativeInteger.fromValue(value);

    final signatureTime = DateTime.fromMillisecondsSinceEpoch(decodedValue);

    return SignatureTime(signatureTime);
  }

  final DateTime signatureTime;

  @override
  TlvType get tlvType => TlvType.signatureTime;

  @override
  List<int> get value =>
      NonNegativeInteger(signatureTime.millisecondsSinceEpoch).encode();
}
