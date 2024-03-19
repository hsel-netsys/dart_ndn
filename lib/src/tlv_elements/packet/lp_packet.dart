// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../tlv_type.dart";
import "nack_packet.dart";
import "ndn_packet.dart";

base class LpPacket extends NdnPacket {
  const LpPacket();

  // TODO: Refactor
  factory LpPacket.fromValue(List<int> value) {
    final tlvElements = value.toTvlElements().toList();

    if (tlvElements.isEmpty) {
      return const LpPacket();
    }

    final type = TlvType.tryParse(tlvElements.first.type);

    if (type == null) {
      return const LpPacket();
    }

    switch (type) {
      case TlvType.nack:
        return const NackPacket();
      default:
        return const LpPacket();
    }
  }

  @override
  TlvType get tlvType => TlvType.lpPacket;

  @override
  // TODO: implement value
  List<int> get encodedValue => [];
}
