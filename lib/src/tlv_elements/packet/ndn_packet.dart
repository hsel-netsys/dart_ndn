// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:meta/meta.dart";

import "../../extensions/bytes_encoding.dart";
import "../tlv_element.dart";

@immutable
abstract base class NdnPacket extends KnownTlvElement {
  const NdnPacket();

  static NdnPacket? tryParse(List<int> encodedPacket) {
    final tlvElements = encodedPacket.toTvlElements();

    if (tlvElements.isEmpty) {
      return null;
    }

    final tlvElement = tlvElements.first;

    // FIXME: This needs be handled differently
    if (tlvElement is NdnPacket) {
      return tlvElement;
    }

    return null;
  }
}
