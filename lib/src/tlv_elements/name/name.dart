// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:collection/collection.dart";

import "../../extensions/bytes_encoding.dart";
import "../../extensions/tlv_element_encoding.dart";
import "../../result/result.dart";
import "../packet/interest_packet.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";
import "name_component.dart";

/// Represents an NDN Name consisting of a number of [NameComponent]s.
///
/// By implementing [Comparable], [Name]s and [NameComponent]s follow the
/// NDN Packet Specification with regard to the [canonical order] of NDN names.
///
/// [canonical order]: https://docs.named-data.net/NDN-packet-spec/current/name.html#canonical-order
final class Name extends KnownTlvElement implements Comparable<Name> {
  const Name(this.nameComponents);

  Name.fromString(String name) : nameComponents = name.toNameComponents();

  static Result<Name> fromValue(List<int> value) {
    // TODO: Deal with invalid nameComponents
    final nameComponents =
        value.toTvlElements().whereType<NameComponent>().toList();

    return Success(Name(nameComponents));
  }

  @override
  TlvType get tlvType => TlvType.name;

  final List<NameComponent> nameComponents;

  @override
  List<int> get encodedValue => nameComponents.encode().toList();

  Uri toUri() {
    final pathSegments = nameComponents.map((e) => e.toPathSegment());

    return Uri(
      scheme: "ndn",
      pathSegments: pathSegments,
    );
  }

  @override
  int compareTo(Name other) {
    for (final pairs in IterableZip([
      encodedValue,
      other.encodedValue,
    ])) {
      final difference = pairs.first - pairs[1];

      if (difference != 0) {
        return difference;
      }
    }

    return length - other.length;
  }
}
