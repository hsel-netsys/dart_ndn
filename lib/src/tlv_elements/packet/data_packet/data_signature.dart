// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:crypto/crypto.dart";
import "package:ecdsa/ecdsa.dart";
import "package:elliptic/elliptic.dart";
import "package:meta/meta.dart";

import "../../../extensions/int_encoding.dart";
import "../../tlv_element.dart";
import "../../tlv_type.dart";

// TODO: https://docs.named-data.net/NDN-packet-spec/current/signature.html#signature-elements
enum SignatureType {
  digestSha256(0),
  signatureSha256WithRsa(1),
  signatureSha256WithEcdsa(3),
  signatureHmacWithSha256(4),
  signatureEd25519(5),
  ;

  const SignatureType(this.numericValue);

  final int numericValue;

  int get type => tlvType.number;

  TlvType get tlvType => TlvType.signatureType;

  List<int> get value => numericValue.encodeAsNonNegativeInteger();

  int get length => value.length;

  List<int> encode() {
    return [
      ...type.encodeAsNdnTlv(),
      ...length.encodeAsNdnTlv(),
      ...value,
    ];
  }
}

@immutable
class DataSignature {
  // TODO: Implement actual signatures https://docs.named-data.net/NDN-packet-spec/current/signature.html#signature-elements
  const DataSignature(this.signatureInfo, this.signatureValue);

  factory DataSignature.create(
    List<int> value,
    SignatureType signatureType,
  ) {
    final signatureInfo = SignatureInfo(signatureType);

    final valueToSign = [...value, ...signatureInfo.value];

    final signatureValue = SignatureValue(valueToSign, signatureType);

    return DataSignature(signatureInfo, signatureValue);
  }

  final SignatureInfo signatureInfo;

  final SignatureValue signatureValue;

  List<int> encode() {
    return [
      ...signatureInfo.encode(),
      ...signatureValue.encode(),
    ];
  }
}

class SignatureInfo extends KnownTlvElement {
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

// TODO: This only implements DigestSha256 for now
class SignatureValue extends KnownTlvElement {
  SignatureValue(List<int> content, SignatureType signatureType)
      : value = _createSignature(content, signatureType);

  static List<int> _createSignature(
    List<int> content,
    SignatureType signatureType,
  ) {
    final hash = sha256.convert(content).bytes;

    switch (signatureType) {
      case SignatureType.digestSha256:
        return hash;
      case SignatureType.signatureSha256WithEcdsa:
        // TODO: Obtain private key from keystore?
        final ec = getP256();
        final priv = ec.generatePrivateKey();

        // TODO: Create digest of public key

        // final pub = priv.publicKey;
        // print(priv);
        // print(pub);
        // final keyDigest = [
        //   ...hex.decode(ec.publicKeyToHex(pub)),
        // ];

        final sig = signature(priv, hash);
        return sig.toCompact();

      default:
        throw UnimplementedError(
          "SignatureType $signatureType is not supported yet.",
        );
    }
  }

  @override
  TlvType get tlvType => TlvType.signatureValue;

  @override
  final List<int> value;
}
