// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../../extensions/non_negative_integer.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";
import "lp_packet.dart";

final class NackPacket extends LpPacket {
  const NackPacket([this.nackReason]);

  factory NackPacket.fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    NackReason? nackReason;

    for (final tlvElement in tlvElements) {
      if (tlvElement is NackReason) {
        nackReason ??= tlvElement;
      }
    }

    return NackPacket(nackReason);
  }

  final NackReason? nackReason;

  @override
  TlvType get tlvType => TlvType.nack;

  @override
  List<int> get encodedValue => [];
}

enum NackReasonValue {
  none(0),
  congestion(50),
  duplicate(100),
  noRoute(150),
  ;

  const NackReasonValue(this._code);

  final int _code;

  NonNegativeInteger get code => NonNegativeInteger(_code);

  static final Map<int, NackReasonValue> _registry =
      Map.fromEntries(values.map((e) => MapEntry(e.code, e)));

  static NackReasonValue? tryParse(int code) => _registry[code];
}

final class NackReason extends KnownTlvElement {
  const NackReason([this._nackReasonValue]);

  factory NackReason.fromValue(List<int> value) {
    final nonNegativeInteger = NonNegativeInteger.fromValue(value);

    final nackReasonValue = NackReasonValue.tryParse(nonNegativeInteger);

    return NackReason(nackReasonValue);
  }

  final NackReasonValue? _nackReasonValue;

  NackReasonValue get nackReasonValue =>
      _nackReasonValue ?? NackReasonValue.none;

  @override
  TlvType get tlvType => TlvType.nackReason;

  @override
  List<int> get encodedValue => nackReasonValue.code.encode();
}
