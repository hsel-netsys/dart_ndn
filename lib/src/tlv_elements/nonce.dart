// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:math";

import "../extensions/bytes_encoding.dart";
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
      : encodedValue =
            value ?? List.generate(4, (index) => Random().nextInt(256));

  static Result<Nonce> fromValue(List<int> value) {
    final isValid = _checkNonceValue(value);

    if (!isValid) {
      return Fail(const FormatException("Encountered invalid Nonce format"));
    }

    return Success(Nonce(value));
  }

  static bool _checkNonceValue(List<int> value) =>
      value.length == 4 &&
      value.fold(
        true,
        (wasValidBefore, valueElement) => wasValidBefore && valueElement.isByte,
      );

  @override
  bool get isValid => _checkNonceValue(encodedValue);

  @override
  TlvType get tlvType => TlvType.nonce;

  @override
  final List<int> encodedValue;
}

final class CanBePrefix extends FlagTlvElement {
  const CanBePrefix();

  // TODO: Refactor
  static Result<MustBeFresh> fromValue(List<int> value) {
    if (value.isNotEmpty) {
      return Fail(
        FormatException(
          "Expected an empty value, encountered ${value.length} bytes",
        ),
      );
    }

    return Success(const MustBeFresh());
  }

  @override
  TlvType get tlvType => TlvType.canBePrefix;
}

final class MustBeFresh extends FlagTlvElement {
  const MustBeFresh();

  static Result<MustBeFresh> fromValue(List<int> value) {
    if (value.isNotEmpty) {
      return Fail(
        FormatException(
          "Expected an empty value, encountered ${value.length} bytes",
        ),
      );
    }

    return Success(const MustBeFresh());
  }

  @override
  TlvType get tlvType => TlvType.canBePrefix;
}

final class ForwardingHint extends KnownTlvElement {
  const ForwardingHint(this.names);

  @override
  TlvType get tlvType => TlvType.forwardingHint;

  final List<Name> names;

  @override
  List<int> get encodedValue => names.encode().toList();

  static Result<ForwardingHint> fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    final List<Name> names = [];

    for (final tlvElement in tlvElements) {
      switch (tlvElement) {
        case Success<Name>(:final tlvElement):
          names.add(tlvElement);
        case Fail(:final exception):
          return Fail(exception);
        default:
          return Fail(
            const FormatException("Encountered a non-name TlvElement"),
          );
      }
    }

    return Success(ForwardingHint(names));
  }
}

final class InterestLifetime extends KnownTlvElement {
  const InterestLifetime(this.duration);

  @override
  TlvType get tlvType => TlvType.interestLifetime;

  final Duration duration;

  @override
  List<int> get encodedValue =>
      NonNegativeInteger(duration.inMilliseconds).encode();

  static Result<TlvElement> fromValue(List<int> value) {
    switch (NonNegativeInteger.fromValue(value)) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        final duration = Duration(milliseconds: tlvElement);
        return Success(InterestLifetime(duration));
      case Fail(:final exception):
        return Fail(exception);
    }
  }
}

final class HopLimit extends KnownTlvElement {
  const HopLimit(this.hopLimit);

  static Result<HopLimit> fromValue(List<int> value) {
    final length = value.length;
    if (length != 1) {
      Fail(FormatException("Expected length of 1, encountered $length"));
    }

    final byteValue = value.first;
    if (!byteValue.isByte) {
      Fail(
        FormatException(
          "Expected value to be in the range [0, 255], encountered $byteValue",
        ),
      );
    }

    return Success(HopLimit(byteValue));
  }

  @override
  bool get isValid => hopLimit.isByte;

  @override
  TlvType get tlvType => TlvType.hopLimit;

  final int hopLimit;

  @override
  List<int> get encodedValue => [hopLimit];
}
