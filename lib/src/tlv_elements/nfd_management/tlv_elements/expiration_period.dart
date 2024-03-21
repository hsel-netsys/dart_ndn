// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../tlv_element.dart";
import "../../tlv_type.dart";

final class ExpirationPeriod extends NonNegativeIntegerTlvElement {
  const ExpirationPeriod(super.value);

  @override
  TlvType get tlvType => TlvType.expirationPeriod;
}
