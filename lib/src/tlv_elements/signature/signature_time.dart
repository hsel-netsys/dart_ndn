// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

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
