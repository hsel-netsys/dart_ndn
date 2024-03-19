// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/non_negative_integer.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";

final class SignatureSeqNum extends KnownTlvElement {
  const SignatureSeqNum(this.sequenceNumber);

  final NonNegativeInteger sequenceNumber;

  @override
  TlvType get tlvType => TlvType.signatureSeqNum;

  @override
  List<int> get value => sequenceNumber.encode();
}
