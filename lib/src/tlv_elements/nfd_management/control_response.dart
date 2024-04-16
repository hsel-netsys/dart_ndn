// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../../extensions/tlv_element_encoding.dart";
import "../../result/result.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";
import "status.dart";

final class ControlResponse extends KnownTlvElement {
  const ControlResponse(
    this.statusCode,
    this.statusText, [
    this.body = const [],
  ]);

  static Result<ControlResponse, DecodingException> fromValue(List<int> value) {
    final tlvElements = value.toTvlElements().toList(growable: false);
    final List<TlvElement> body = [];

    final StatusCode statusCode;
    final decodingException = DecodingException(
      TlvType.controlResponse.number,
      "Invalid format for ControlResponse",
    );

    switch (tlvElements.firstOrNull) {
      case Success<StatusCode, DecodingException>(:final tlvElement):
        statusCode = tlvElement;
      case Fail<StatusCode, DecodingException>(:final exception):
        return Fail(exception);

      default:
        return Fail(decodingException);
    }

    final StatusText statusText;

    switch (tlvElements.elementAtOrNull(1)) {
      case Success<StatusText, DecodingException>(:final tlvElement):
        statusText = tlvElement;
      case Fail<StatusText, DecodingException>(:final exception):
        return Fail(exception);

      default:
        return Fail(decodingException);
    }

    if (tlvElements.length > 2) {
      for (final tlvElement in tlvElements.sublist(2)) {
        switch (tlvElement) {
          case Success(:final tlvElement):
            body.add(tlvElement);
          // TODO: Should this propagated?
          case Fail(:final exception):
            return Fail(exception);
        }
      }
    }

    return Success(
      ControlResponse(
        statusCode,
        statusText,
        body,
      ),
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
