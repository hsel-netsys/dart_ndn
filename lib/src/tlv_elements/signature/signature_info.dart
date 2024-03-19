import "../tlv_element.dart";
import "../tlv_type.dart";
import "signature_type.dart";

final class SignatureInfo extends KnownTlvElement {
  // TODO: Add KeyLocator
  const SignatureInfo(this.signatureType);

  final SignatureType signatureType;

  @override
  TlvType get tlvType => TlvType.signatureInfo;

  @override
  // 0 is DigestSha256
  List<int> get value => [
        ...signatureType.encode(),
      ];
}
