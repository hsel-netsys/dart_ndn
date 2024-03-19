import "../tlv_element.dart";
import "../tlv_type.dart";

/// The SignatureNonce element adds additional assurances that a signature will
/// be unique.
///
/// The recommended minimum length for a [SignatureNonce] element is 8 octets.
// TODO: Introduce common base class for simple value elements like this one
final class SignatureNonce extends KnownTlvElement {
  const SignatureNonce(this.value);

  @override
  TlvType get tlvType => TlvType.signatureNonce;

  @override
  final List<int> value;
}
