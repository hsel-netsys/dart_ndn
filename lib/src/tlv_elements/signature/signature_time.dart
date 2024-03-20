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

  static Result<SignatureTime> fromValue(List<int> value) {
    switch (NonNegativeInteger.fromValue(value)) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        final signatureTime = DateTime.fromMillisecondsSinceEpoch(tlvElement);
        return Success(SignatureTime(signatureTime));
      case Fail(:final exception):
        return Fail(exception);
    }
  }

  final DateTime signatureTime;

  @override
  TlvType get tlvType => TlvType.signatureTime;

  @override
  List<int> get encodedValue =>
      NonNegativeInteger(signatureTime.millisecondsSinceEpoch).encode();
}
