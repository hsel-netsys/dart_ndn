// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:meta/meta.dart";

import "signature_info.dart";
import "signature_type.dart";
import "signature_value.dart";

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
