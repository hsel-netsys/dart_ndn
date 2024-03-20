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

  static Result<NdnPacket> tryParse(List<int> encodedPacket) {
    final tlvElements = encodedPacket.toTvlElements();

    switch (tlvElements.firstOrNull) {
      case Success(:final tlvElement):
        if (tlvElement is NdnPacket) {
          return Success(tlvElement);
        } else {
          return Fail(
            FormatException(
              "Encountered an unexcepted TlvElement ${tlvElement.runtimeType}",
            ),
          );
        }
      case Fail(:final exception):
        return Fail(exception);
      case null:
        return Fail(const FormatException("Encountered no TlvElement."));
    }
  }
}
