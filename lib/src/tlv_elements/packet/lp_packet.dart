// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../../result/result.dart";
import "../tlv_type.dart";
import "nack_packet.dart";
import "ndn_packet.dart";

base class LpPacket extends NdnPacket {
  const LpPacket();

  // TODO: Refactor and actually implement...
  static Result<LpPacket> fromValue(List<int> value) {
    final tlvElements = value.toTvlElements().toList();

    switch (tlvElements.firstOrNull) {
      case Success<NackPacket>(:final tlvElement):
        return Success(tlvElement);
      case Fail(:final exception):
        return Fail(exception);
      default:
        return Success(const LpPacket());
    }
  }

  @override
  TlvType get tlvType => TlvType.lpPacket;

  @override
  // TODO: implement value
  List<int> get encodedValue => [];
}
