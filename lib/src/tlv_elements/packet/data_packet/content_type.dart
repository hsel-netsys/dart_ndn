// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../../extensions/non_negative_integer.dart";
import "../../../result/result.dart";
import "../../tlv_element.dart";
import "../../tlv_type.dart";

enum ContentTypeValue {
  blob(0),
  link(1),
  key(2),
  nack(3),
  ;

  const ContentTypeValue(this.value);

  static ContentTypeValue? tryParse(NonNegativeInteger nonNegativeInteger) =>
      _registry[nonNegativeInteger.value];

  static final _registry =
      Map.fromEntries(values.map((e) => MapEntry(e.value, e)));

  final int value;
}

final class ContentType extends NonNegativeIntegerTlvElement {
  const ContentType(super.value);

  static Result<ContentType> fromValue(List<int> value) {
    switch (NonNegativeInteger.fromValue(value)) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        return Success(ContentType(tlvElement));
      case Fail(:final exception):
        return Fail(exception);
    }
  }

  @override
  TlvType get tlvType => TlvType.contentType;

  ContentTypeValue? get contentTypeValue => ContentTypeValue.tryParse(value);
}
