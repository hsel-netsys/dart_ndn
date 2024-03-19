// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:math";

import "../extensions/non_negative_integer.dart";
import "../extensions/tlv_element_encoding.dart";
import "name/name.dart";
import "tlv_element.dart";
import "tlv_type.dart";

extension ByteExtension on int {
  bool get isByte => this >= 0 && this <= 255;
}

final class Nonce extends KnownTlvElement {
  Nonce([List<int>? value])
      : value = value ?? List.generate(4, (index) => Random().nextInt(256));

  bool get isValid =>
      value.length == 4 &&
      value.fold(
        true,
        (wasValidBefore, valueElement) => wasValidBefore && valueElement.isByte,
      );

  @override
  TlvType get tlvType => TlvType.nonce;

  @override
  final List<int> value;
}

final class CanBePrefix extends KnownTlvElement {
  @override
  TlvType get tlvType => TlvType.canBePrefix;

  @override
  List<int> get value => const [];
}

final class MustBeFresh extends KnownTlvElement {
  @override
  TlvType get tlvType => TlvType.mustBeFresh;

  @override
  List<int> get value => const [];
}

final class ForwardingHint extends KnownTlvElement {
  const ForwardingHint(this.names);

  @override
  TlvType get tlvType => TlvType.forwardingHint;

  final List<Name> names;

  @override
  List<int> get value => names.encode().toList();
}

final class InterestLifetime extends KnownTlvElement {
  const InterestLifetime(this.duration);

  @override
  TlvType get tlvType => TlvType.interestLifetime;

  final Duration duration;

  @override
  List<int> get value => NonNegativeInteger(duration.inMilliseconds).encode();
}

final class HopLimit extends KnownTlvElement {
  const HopLimit(this.hopLimit);

  @override
  TlvType get tlvType => TlvType.hopLimit;

  // TODO: Assert that hopLimit can only be in the range [0, 255]
  final int hopLimit;

  @override
  List<int> get value => [hopLimit];
}
