// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:typed_data";

extension EncodeOctects on int {
  // TODO: Differentiate between TLV-TYPE and TLV-LENGTH
  // See https://docs.named-data.net/NDN-packet-spec/current/tlv.html
  List<int> encodeAsNdnTlv() {
    if (this < 0) {
      throw StateError("Must be a natural number");
    }

    if (this <= 252) {
      return [this];
    }

    if (this <= 65535) {
      // First Byte: 253
      // Encode as 2 bytes
      final bytes = Uint8List(2)..buffer.asByteData().setUint16(0, this);

      return [253, ...bytes];
    }

    if (this <= 4294967295) {
      // First Byte: 254
      // Encode as 4 bytes
      final bytes = Uint8List(4)..buffer.asByteData().setUint32(0, this);

      return [254, ...bytes];
    }

    // First Byte: 255
    // Encode as 8 bytes
    final bytes = Uint8List(8)..buffer.asByteData().setUint64(0, this);
    return [255, ...bytes];
  }
}
