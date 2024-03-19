// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:crypto/crypto.dart";
import "package:ecdsa/ecdsa.dart";
import "package:elliptic/elliptic.dart";

import "../tlv_element.dart";
import "../tlv_type.dart";
import "signature_type.dart";

// TODO: This only implements DigestSha256 for now
final class SignatureValue extends KnownTlvElement {
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
