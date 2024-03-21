// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../../extensions/bytes_encoding.dart";
import "../../../result/result.dart";
import "../../name/name_component.dart";
import "../../tlv_element.dart";
import "../../tlv_type.dart";

final class FinalBlockId extends KnownTlvElement {
  const FinalBlockId(this.nameComponent);

  final NameComponent nameComponent;

  static Result<FinalBlockId> fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    NameComponent? nameComponent;

    for (final tlvElement in tlvElements) {
      switch (tlvElement) {
        case Success(:final tlvElement):
          if (tlvElement is NameComponent) {
            if (nameComponent == null) {
              nameComponent = tlvElement;
              continue;
            }

            return const Fail(
              FormatException("Encountered out-of-order NameComponent"),
            );
          }

          if (tlvElement.isCritical) {
            return const Fail(
              FormatException("Encountered unrecognized TlvElement"),
            );
          }

        case Fail(:final exception):
          return Fail(exception);
      }
    }

    if (nameComponent == null) {
      return const Fail(
        FormatException("Missing NameComponent in FinalBlockId"),
      );
    }

    return Success(FinalBlockId(nameComponent));
  }

  @override
  TlvType get tlvType => TlvType.finalBlockId;

  @override
  List<int> get encodedValue => throw UnimplementedError();
}
