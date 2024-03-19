// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../name/name.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";

abstract base class KeyLocator extends KnownTlvElement {
  const KeyLocator();

  factory KeyLocator.fromValue(List<int> value) {
    // TODO: Check for length etc.
    final tlvElement = value.toTvlElements().firstOrNull;

    switch (tlvElement) {
      case Name():
        return NameKeyLocator(tlvElement);
      case KeyDigest():
        return KeyDigestKeyLocator(tlvElement);
      default:
        // TODO: Improve error handling
        throw const FormatException("Invalid value for KeyLocator.");
    }
  }

  @override
  TlvType get tlvType => TlvType.keyLocator;
}

final class NameKeyLocator extends KeyLocator {
  const NameKeyLocator(this.name);

  final Name name;

  @override
  List<int> get value => name.encode().toList();
}

final class KeyDigest extends KnownTlvElement {
  const KeyDigest(this.value);

  @override
  TlvType get tlvType => TlvType.keyDigest;

  @override
  final List<int> value;
}

final class KeyDigestKeyLocator extends KeyLocator {
  const KeyDigestKeyLocator(this.keyDigest);

  final KeyDigest keyDigest;

  @override
  List<int> get value => keyDigest.encode().toList();
}
