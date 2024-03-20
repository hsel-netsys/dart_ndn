// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../../extensions/bytes_encoding.dart";
import "../../../extensions/non_negative_integer.dart";
import "../../../result/result.dart";
import "../../name/name_component.dart";
import "../../tlv_element.dart";
import "../../tlv_type.dart";

final class MetaInfo extends KnownTlvElement {
  const MetaInfo({
    this.contentType,
    this.freshnessPeriod,
    this.finalBlockId,
  });

  final NonNegativeInteger? contentType;

  final Duration? freshnessPeriod;

  final NameComponent? finalBlockId;

  static Result<MetaInfo> fromValue(List<int> value) {
    // TODO: Process tlvElements
    final _ = value.toTvlElements().iterator..moveNext();

    return Success(const MetaInfo());
  }

  @override
  List<int> get encodedValue {
    final List<int> result = [];

    final contentType = this.contentType;
    if (contentType != null) {
      result.addAll(contentType.encode());
    }

    final freshnessPeriod = this.freshnessPeriod;

    if (freshnessPeriod != null) {
      result
          .addAll(NonNegativeInteger(freshnessPeriod.inMilliseconds).encode());
    }

    final finalBlockId = this.finalBlockId;

    if (finalBlockId != null) {
      result.addAll(finalBlockId.encode());
    }

    return result;
  }

  @override
  TlvType get tlvType => TlvType.metaInfo;
}
