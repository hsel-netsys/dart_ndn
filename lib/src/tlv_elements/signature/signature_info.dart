// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../../result/result.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";
import "key_locator.dart";
import "signature_type.dart";

final class SignatureInfo extends KnownTlvElement {
  const SignatureInfo(
    this.signatureType, {
    this.keyLocator,
  });

  static Result<SignatureInfo> fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    final SignatureType signatureType;

    switch (tlvElements.elementAtOrNull(0)) {
      case Success<SignatureType>(:final tlvElement):
        signatureType = tlvElement;
      case Fail(:final exception):
        return Fail(exception);
      default:
        return Fail(const FormatException("Missing SignatureType"));
    }

    final secondElement = tlvElements.elementAtOrNull(1);
    final KeyLocator? keyLocator;

    if (secondElement is Success<KeyLocator>) {
      keyLocator = secondElement.tlvElement;
    } else {
      keyLocator = null;
    }

    return Success(SignatureInfo(signatureType, keyLocator: keyLocator));
  }

  final SignatureType signatureType;

  final KeyLocator? keyLocator;

  @override
  TlvType get tlvType => TlvType.signatureInfo;

  @override
  List<int> get encodedValue {
    final result = signatureType.encode().toList();

    final keyLocator = this.keyLocator;

    if (keyLocator != null) {
      result.addAll(keyLocator.encode());
    }

    return result;
  }
}
