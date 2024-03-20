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

  static Result<NackPacket> fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    NackReason? nackReason;

    for (final tlvElement in tlvElements) {
      if (tlvElement is Success<NackReason>) {
        nackReason ??= tlvElement.tlvElement;
      }
      // TODO: Deal with critical fails
    }

    return Success(NackPacket(nackReason));
  }

  final NackReason? nackReason;

  @override
  TlvType get tlvType => TlvType.nack;

  @override
  List<int> get encodedValue => [];
}

enum NackReasonValue {
  none(NonNegativeInteger.fromInt(0)),
  congestion(NonNegativeInteger.fromInt(50)),
  duplicate(NonNegativeInteger.fromInt(100)),
  noRoute(NonNegativeInteger.fromInt(150)),
  ;

  const NackReasonValue(this.code);

  final NonNegativeInteger code;

  static final Map<int, NackReasonValue> _registry =
      Map.fromEntries(values.map((e) => MapEntry(e.code, e)));

  static NackReasonValue? tryParse(int code) => _registry[code];
}

final class NackReason extends KnownTlvElement {
  const NackReason([this._nackReasonValue]);

  static Result<NackReason> fromValue(List<int> value) {
    switch (NonNegativeInteger.fromValue(value)) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        final nackReasonValue = NackReasonValue.tryParse(tlvElement.value);
        return Success(NackReason(nackReasonValue));
      case Fail(:final exception):
        return Fail(exception);
    }
  }

  final NackReasonValue? _nackReasonValue;

  NackReasonValue get nackReasonValue =>
      _nackReasonValue ?? NackReasonValue.none;

  @override
  TlvType get tlvType => TlvType.nackReason;

  @override
  List<int> get encodedValue => nackReasonValue.code.encode();
}
