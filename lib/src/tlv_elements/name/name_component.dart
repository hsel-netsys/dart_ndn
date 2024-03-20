// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:collection/collection.dart";
import "package:convert/convert.dart";
import "package:meta/meta.dart";

import "../../extensions/non_negative_integer.dart";
import "../../result/result.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";

part "name_component/generic_name_component.dart";
part "name_component/implicit_sha_256_digest_component.dart";
part "name_component/other_type_component.dart";
part "name_component/parameters_sha_256_digest_component.dart";

@immutable
sealed class NameComponent extends KnownTlvElement
    implements Comparable<NameComponent> {
  const NameComponent();

  @internal
  // TODO: Revisit percent encoding
  String get percentEncodedValue {
    final encodingResult = percent.encode(encodedValue);

    switch (encodingResult) {
      case ".":
        return "...";
      case "..":
        return "....";
      default:
        return encodingResult;
    }
  }

  String toPathSegment() => "$type=$percentEncodedValue";

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

    for (final pair in IterableZip([encodedValue, other.encodedValue])) {
      final difference = pair.first - pair[1];
      if (difference != 0) {
        return difference;
      }
    }

    return 0;
  }
}
