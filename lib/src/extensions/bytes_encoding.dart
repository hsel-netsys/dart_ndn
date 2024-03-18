// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:typed_data";

import "../tlv_elements/tlv_element.dart";

extension BytesDecoder on List<int> {
  Iterable<TlvElement> toTvlElements() sync* {
    int? type;
    int? typeLength;
    final typeBytes = <int>[];
    int? length;
    int? lengthLength;
    final lengthBytes = <int>[];
    final value = <int>[];

    for (final byte in this) {
      if (type == null) {
        if (typeLength != null) {
          typeBytes.add(byte);
          typeLength--;

          if (typeLength == 0) {
            final typeByteData =
                Uint8List.fromList(typeBytes).buffer.asByteData();

            if (typeBytes.length == 2) {
              type = typeByteData.getUint16(0);
            } else {
              type = typeByteData.getUint32(0);
            }

            typeLength = null;
            typeBytes.clear();
          }
          continue;
        }

        if (byte <= 252) {
          type = byte;
          continue;
        }

        switch (byte) {
          case 253:
            typeLength = 2;
          case 254:
            typeLength = 4;
        }
        // TODO: Handle invalid cases

        continue;
      }

      if (length == null) {
        if (lengthLength != null) {
          lengthBytes.add(byte);
          lengthLength--;

          if (lengthLength == 0) {
            final lengthByteData =
                Uint8List.fromList(lengthBytes).buffer.asByteData();

            if (lengthBytes.length == 2) {
              length = lengthByteData.getUint16(0);
            } else if (lengthBytes.length == 4) {
              length = lengthByteData.getUint32(0);
            } else {
              length = lengthByteData.getUint64(0);
            }

            lengthLength = null;
            lengthBytes.clear();
          }
          continue;
        }

        if (byte == 0) {
          yield TlvElement.parse(type, value);
          type = null;
          length = null;
          continue;
        } else if (byte <= 252) {
          length = byte;
          continue;
        }

        switch (byte) {
          case 253:
            lengthLength = 2;
          case 254:
            lengthLength = 4;
          case 255:
            lengthLength = 8;
        }
        // TODO: Handle invalid cases

        continue;
      }

      if (length > 0) {
        value.add(byte);
        length--;
      }

      if (length == 0) {
        yield TlvElement.parse(type, value);
        type = null;
        length = null;
        value.clear();
      }
    }
  }

  int? get tlvTypeLength {
    if (isEmpty) {
      return null;
    }

    final first = this.first;
    if (first <= 252) {
      return 1;
    }

    switch (first) {
      case 253:
        return 2;
      case 254:
        return 4;
      default:
        // TODO: Should this be an error?
        return null;
    }
  }

  // TODO: Should an error be thrown for invalid encodings?
  int? get tlvType {
    final tlvTypeLength = this.tlvTypeLength;

    if (tlvTypeLength == null) {
      return null;
    }

    if (tlvTypeLength == 1) {
      return first;
    }

    if (length < tlvTypeLength + 1) {
      return null;
    }

    final bytes = Uint8List(tlvTypeLength)..setAll(1, take(tlvTypeLength));
    final byteData = bytes.buffer.asByteData();

    if (tlvTypeLength == 2) {
      return byteData.getUint16(0);
    } else {
      return byteData.getUint32(0);
    }
  }

  int? get tlvLength {
    final tlvTypeLength = this.tlvTypeLength;

    if (tlvTypeLength == null) {
      return null;
    }

    final firstByte = firstOrNull;

    if (firstByte == null) {
      return null;
    }

    if (firstByte <= 252) {
      return firstByte;
    }

    final int tlvLengthNumberLength;

    switch (firstByte) {
      case 253:
        tlvLengthNumberLength = 2;
      case 254:
        tlvLengthNumberLength = 4;
      case 255:
        tlvLengthNumberLength = 8;
      default:
        return null;
    }

    if (length < tlvLengthNumberLength + 1) {
      return null;
    }

    final tlvLengthNumberBytes = sublist(1, tlvLengthNumberLength);

    final bytes = Uint8List(tlvLengthNumberLength)
      ..setAll(0, tlvLengthNumberBytes);
    final byteData = bytes.buffer.asByteData();

    switch (tlvLengthNumberLength) {
      case 2:
        return byteData.getUint16(0);
      case 4:
        return byteData.getUint32(0);
      case 8:
        return byteData.getUint64(0);
    }

    return null;
  }

  /// Obtains the length of the type and the length bytes before the actual
  /// value.
  int? get preValueLength => 0;
}
