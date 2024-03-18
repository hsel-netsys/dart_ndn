// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:typed_data";

extension type NonNegativeInteger(int value) implements int {
  // TODO: Could also be turned into a "tryParse" static method
  factory NonNegativeInteger.fromValue(List<int> value) {
    final int decodedValue;

    if (value.length == 1) {
      decodedValue = value.first;
    } else {
      final length = value.length;

      final ByteData byteData = Uint8List.fromList(value).buffer.asByteData();
      switch (length) {
        case 2:
          decodedValue = byteData.getUint16(0);
        case 4:
          decodedValue = byteData.getUint32(0);
        case 8:
          decodedValue = byteData.getUint64(0);
        default:
          throw FormatException(
            "Expected a byte length of either 1, 2, 4, or 8, "
            "encountered $length",
          );
      }
    }
    final result = NonNegativeInteger(decodedValue);

    if (!result.isValid) {
      throw FormatException(
        "Expected a non-negative integer, encountered $result",
      );
    }

    return result;
  }

  bool get isValid => !value.isNegative;

  /// Encodes this integer using the [Non-Negative Integer Encoding] defined
  /// in the NDN Packet Format Specification.
  ///
  /// Throws a [FormatException] if this integer is in fact negative.
  ///
  /// [Non-Negative Integer Encoding]: See https://docs.named-data.net/NDN-packet-spec/current/tlv.html#non-negative-integer-encoding
  List<int> encode() {
    if (!isValid) {
      throw FormatException("Expected a non-negative integer, found $this.");
    }

    if (this <= 252) {
      return [this];
    }

    if (this <= 65535) {
      // Encode as 2 bytes
      return Uint8List(2)..buffer.asByteData().setUint16(0, this);
    }

    if (this <= 4294967295) {
      // Encode as 4 bytes
      return Uint8List(4)..buffer.asByteData().setUint32(0, this);
    }

    // Encode as 8 bytes
    return Uint8List(8)..buffer.asByteData().setUint64(0, this);
  }
}
