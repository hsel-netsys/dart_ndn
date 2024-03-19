// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../name/name.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";

final class ControlParameters extends KnownTlvElement {
  const ControlParameters({
    this.name,
  });

  factory ControlParameters.fromValue(List<int> value) {
    final _ = value.toTvlElements();

    return const ControlParameters();
  }

  final Name? name;

  @override
  TlvType get tlvType => TlvType.controlParameters;

  @override
  List<int> get value {
    final encodedValue = <int>[];

    final name = this.name;
    if (name != null) {
      encodedValue.addAll(name.encode());
    }

    return encodedValue;
  }
}
