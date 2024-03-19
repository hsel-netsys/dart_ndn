// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";
import "key_locator.dart";
import "signature_type.dart";

final class SignatureInfo extends KnownTlvElement {
  const SignatureInfo(
    this.signatureType, {
    this.keyLocator,
  });

  factory SignatureInfo.fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    final firstElement = tlvElements.elementAtOrNull(0);
    final secondElement = tlvElements.elementAtOrNull(1);

    final KeyLocator? keyLocator;

    // TODO: Revisit nullable type
    if (firstElement == null || firstElement is! SignatureType) {
      throw const FormatException("Invalid or missing SignatureType");
    }

    if (secondElement is KeyLocator) {
      keyLocator = secondElement;
    } else {
      keyLocator = null;
    }

    return SignatureInfo(firstElement as SignatureType, keyLocator: keyLocator);
  }

  final SignatureType signatureType;

  final KeyLocator? keyLocator;

  @override
  TlvType get tlvType => TlvType.signatureInfo;

  @override
  List<int> get value {
    final result = signatureType.encode();

    final keyLocator = this.keyLocator;

    if (keyLocator != null) {
      result.addAll(keyLocator.encode());
    }

    return result;
  }
}
