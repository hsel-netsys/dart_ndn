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
  const StatusCode(super.code);

  factory StatusCode.fromValue(List<int> value) {
    final intValue = NonNegativeInteger.fromValue(value);

    return StatusCode(intValue);
  }

  @override
  TlvType get tlvType => TlvType.statusCode;

  @override
  String toString() => "StatusCode (type: $type): $nonNegativeInteger";
}

final class StatusText extends KnownTlvElement {
  const StatusText(this.text);

  factory StatusText.fromValue(List<int> value) {
    final text = utf8.decode(value);

    return StatusText(text);
  }

  final String text;

  @override
  TlvType get tlvType => TlvType.statusText;

  @override
  List<int> get value => utf8.encode(text);

  @override
  String toString() => "StatusText (type: $type): $text";
}
