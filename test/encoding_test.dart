// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:dart_ndn/src/extensions/bytes_encoding.dart";
import "package:dart_ndn/src/extensions/int_encoding.dart";
import "package:dart_ndn/src/tlv_elements/tlv_element.dart";
import "package:test/test.dart";

void main() {
  group("TLV encoding", () {
    group("should work for", () {
      test("integers", () {
        expect(5.encodeAsNdnTlv(), [5]);
        expect(254.encodeAsNdnTlv(), [253, 0, 254]);
        expect(65539.encodeAsNdnTlv(), [254, 0, 1, 0, 3]);
        expect(
          6294967295.encodeAsNdnTlv(),
          [255, 0, 0, 0, 1, 119, 53, 147, 255],
        );
      });

      test("byte lists", () {
        final input = [
          // First element
          253,
          0,
          254,
          2,
          5,
          6,
          // Second element
          253,
          0,
          254,
          3,
          5,
          6,
          7,
        ];

        final tlvElements = input.toTvlElements();
        expect(tlvElements.length, 2);

        final firstElement = tlvElements.first;
        final secondElement = tlvElements.skip(1).first;
        expect(firstElement, const UnknownTlvElement(254, [5, 6]));
        expect(secondElement, const UnknownTlvElement(254, [5, 6, 7]));
      });
    });
  });
}
