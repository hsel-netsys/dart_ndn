// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../../result/result.dart";
import "../../tlv_element.dart";
import "../../tlv_type.dart";

final class Content extends KnownTlvElement {
  const Content(this.encodedValue);

  static Result<Content> fromValue(List<int> value) {
    return Success(Content(value));
  }

  @override
  final List<int> encodedValue;

  @override
  TlvType get tlvType => TlvType.content;
}
