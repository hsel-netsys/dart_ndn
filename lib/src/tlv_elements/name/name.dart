// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:collection/collection.dart";
import "package:convert/convert.dart";

import "../../extensions/bytes_encoding.dart";
import "../../extensions/tlv_element_encoding.dart";
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
class Name extends KnownTlvElement implements Comparable<Name> {
  const Name(this.nameComponents);

  factory Name.fromValue(List<int> value) {
    final nameComponents =
        value.toTvlElements().whereType<NameComponent>().toList();

    return Name(nameComponents);
  }

  Name.fromString(String name) : nameComponents = name.toNameComponents();

  // Name.fromValue(List<int> value) : nameComponents = [] {
  //   throw UnimplementedError();
  // }

  @override
  TlvType get tlvType => TlvType.name;

  final List<NameComponent> nameComponents;

  @override
  List<int> get value => nameComponents.encode().toList();

  Uri toUri() {
    final pathSegments = <String>[];

    for (final nameComponent in nameComponents) {
      final value = nameComponent.value;
      final String pathSegmentValue;
      switch (nameComponent.tlvValueFormat) {
        case TlvValueFormat.octetStar:
          pathSegmentValue = percent.encode(value);
        case TlvValueFormat.octet32:
          pathSegmentValue = hex.encode(value);
        case TlvValueFormat.nonNegativeInteger:
          throw UnimplementedError();
      }

      final String pathSegment;

      if (nameComponent is GenericNameComponent) {
        pathSegment = pathSegmentValue;
      } else {
        pathSegment = [
          nameComponent.type.toString(),
          pathSegmentValue,
        ].join("=");
      }

      pathSegments.add(pathSegment);
    }

    return Uri(
      scheme: "ndn",
      pathSegments: pathSegments,
    );
  }

  @override
  int compareTo(Name other) {
    for (final pairs in IterableZip([
      value,
      other.value,
    ])) {
      final difference = pairs.first - pairs[1];

      if (difference != 0) {
        return difference;
      }
    }

    return length - other.length;
  }
}
