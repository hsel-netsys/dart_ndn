// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:convert";

import "package:collection/collection.dart";
import "package:meta/meta.dart";

import "../nfd_management/control_parameters.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";

part "name_component/generic_name_component.dart";
part "name_component/implicit_sha_256_digest_component.dart";
part "name_component/other_type_component.dart";
part "name_component/parameters_sha_256_digest_component.dart";

enum TlvValueFormat {
  octet32,
  octetStar,
  nonNegativeInteger,
  ;
}

@immutable
sealed class NameComponent extends KnownTlvElement
    implements Comparable<NameComponent> {
  const NameComponent();

  TlvValueFormat get tlvValueFormat;

  static NameComponent? tryFromValue(List<int> value) {
    try {
      final nameComponentString = utf8.decode(value);
      return GenericNameComponent(nameComponentString);
    } on FormatException {
      return null;
    }
  }

  @override
  int compareTo(NameComponent other) {
    final otherType = other.type;
    final otherLength = other.length;

    if (type != otherType) {
      return type - otherType;
    }

    if (length != otherLength) {
      return type - otherLength;
    }

    for (final pair in IterableZip([value, other.value])) {
      final difference = pair.first - pair[1];
      if (difference != 0) {
        return difference;
      }
    }

    return 0;
  }
}
