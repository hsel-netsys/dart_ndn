// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../../extensions/tlv_element_encoding.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";
import "status.dart";

final class ControlResponse extends KnownTlvElement {
  const ControlResponse(
    this.statusCode,
    this.statusText, [
    this.body = const [],
  ]);

  factory ControlResponse.fromValue(List<int> value) {
    final tlvElements = value.toTvlElements().toList(growable: false);
    final List<TlvElement> body = [];

    final statusCode = tlvElements.firstOrNull;
    final statusText = tlvElements.elementAtOrNull(1);

    if (statusCode is! StatusCode || statusText is! StatusText) {
      throw const FormatException("Invalid format for ControlResponse");
    }

    if (tlvElements.length > 2) {
      body.addAll(tlvElements.sublist(2));
    }

    return ControlResponse(
      statusCode,
      statusText,
      body,
    );
  }

  final StatusCode statusCode;

  final StatusText statusText;

  final List<TlvElement> body;

  @override
  TlvType get tlvType => TlvType.controlResponse;

  @override
  List<int> get encodedValue => [
        ...statusCode.encode(),
        ...statusText.encode(),
        ...body.encode(),
      ];

  @override
  String toString() {
    const indentation = "\n  ";
    return "ControlResponse$indentation${[statusCode, statusText].join(
      indentation,
    )}";
  }
}
