// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../tlv_element.dart";
import "../tlv_type.dart";
import "key_locator.dart";
import "signature_nonce.dart";
import "signature_seq_num.dart";
import "signature_time.dart";
import "signature_type.dart";

final class InterestSignatureInfo extends KnownTlvElement {
  const InterestSignatureInfo(
    this.signatureType, {
    this.keyLocator,
    this.signatureNonce,
    this.signatureTime,
    this.signatureSeqNum,
  });

  final SignatureType signatureType;

  final KeyLocator? keyLocator;

  final SignatureNonce? signatureNonce;

  final SignatureTime? signatureTime;

  final SignatureSeqNum? signatureSeqNum;

  @override
  TlvType get tlvType => TlvType.interestSignatureInfo;

  @override
  List<int> get value {
    final result = signatureType.encode();

    final tlvElements = [
      keyLocator,
      signatureNonce,
      signatureTime,
      signatureSeqNum,
    ];

    for (final tlvElement in tlvElements) {
      if (tlvElement != null) {
        result.addAll(tlvElement.encode());
      }
    }

    return result;
  }
}
