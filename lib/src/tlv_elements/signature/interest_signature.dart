// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:meta/meta.dart";

import "interest_signature_info.dart";
import "interest_signature_value.dart";

@immutable
class InterestSignature {
  // TODO: Implement actual signatures https://docs.named-data.net/NDN-packet-spec/current/signature.html#signature-elements
  const InterestSignature(
    this.interestSignatureInfo,
    this.interestSignatureValue,
  );

  final InterestSignatureInfo interestSignatureInfo;

  final InterestSignatureValue interestSignatureValue;

  List<int> encode() {
    return [
      ...interestSignatureInfo.encode(),
      ...interestSignatureValue.encode(),
    ];
  }
}
