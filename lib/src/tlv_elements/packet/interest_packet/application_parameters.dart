// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../../result/result.dart";
import "../../tlv_element.dart";
import "../../tlv_type.dart";

final class ApplicationParameters extends OctetTlvElement {
  const ApplicationParameters(super.value);

  static Result<ApplicationParameters, DecodingException> fromValue(
    List<int> value,
  ) {
    return Success(ApplicationParameters(value));
  }

  @override
  TlvType get tlvType => TlvType.applicationParameters;
}
