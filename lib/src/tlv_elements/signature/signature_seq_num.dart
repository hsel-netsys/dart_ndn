// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/non_negative_integer.dart";
import "../../result/result.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";

final class SignatureSeqNum extends NonNegativeIntegerTlvElement {
  const SignatureSeqNum(super.sequenceNumber);

  static Result<SignatureSeqNum> fromValue(List<int> value) {
    switch (NonNegativeInteger.fromValue(value)) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        return Success(SignatureSeqNum(tlvElement));
      case Fail(:final exception):
        return Fail(exception);
    }
  }

  @override
  TlvType get tlvType => TlvType.signatureSeqNum;
}
