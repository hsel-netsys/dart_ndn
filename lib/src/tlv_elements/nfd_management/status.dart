// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:convert";

import "../../extensions/non_negative_integer.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";

final class StatusCode extends NonNegativeIntegerTlvElement {
  const StatusCode(super.value);

  static Result<StatusCode> fromValue(List<int> value) {
    final intValue = NonNegativeInteger.fromValue(value);

    switch (intValue) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        return Success(StatusCode(tlvElement));
      case Fail(:final exception):
        return Fail(exception);
    }
  }

  @override
  TlvType get tlvType => TlvType.statusCode;

  @override
  String toString() => "StatusCode (type: $type): $value";
}

final class StatusText extends KnownTlvElement {
  const StatusText(this.text);

  static Result<StatusText> fromValue(List<int> value) {
    try {
      final text = utf8.decode(value);
      return Success(StatusText(text));
    } on Exception catch (exception) {
      return Fail(exception);
    }
  }

  final String text;

  @override
  TlvType get tlvType => TlvType.statusText;

  @override
  List<int> get encodedValue => utf8.encode(text);

  @override
  String toString() => "StatusText (type: $type): $text";
}
