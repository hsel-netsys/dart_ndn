// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../../result/result.dart";
import "../name/name.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";

abstract base class KeyLocator extends KnownTlvElement {
  const KeyLocator();

  static Result<KeyLocator, DecodingException> fromValue(List<int> value) {
    final firstTlvElement = value.toTvlElements().firstOrNull;

    switch (firstTlvElement) {
      case Fail(:final exception):
        return Fail(exception);

      case Success(:final tlvElement):
        final KeyLocator keyLocator;

        switch (tlvElement) {
          case Name():
            keyLocator = NameKeyLocator(tlvElement);
          case KeyDigest():
            keyLocator = KeyDigestKeyLocator(tlvElement);
          default:
            return Fail(
              DecodingException(
                tlvElement.type,
                "Invalid value for KeyLocator.",
              ),
            );
        }

        return Success(keyLocator);

      default:
        // TODO: Check for length etc.
        return Fail(
          DecodingException(
            TlvType.keyLocator.number,
            "Missing value for KeyLocator",
          ),
        );
    }
  }

  @override
  TlvType get tlvType => TlvType.keyLocator;
}

final class NameKeyLocator extends KeyLocator {
  const NameKeyLocator(this.name);

  final Name name;

  @override
  List<int> get encodedValue => name.encode().toList();
}

final class KeyDigest extends OctetTlvElement {
  const KeyDigest(super.value);

  @override
  TlvType get tlvType => TlvType.keyDigest;
}

final class KeyDigestKeyLocator extends KeyLocator {
  const KeyDigestKeyLocator(this.keyDigest);

  final KeyDigest keyDigest;

  @override
  List<int> get encodedValue => keyDigest.encode().toList();
}
