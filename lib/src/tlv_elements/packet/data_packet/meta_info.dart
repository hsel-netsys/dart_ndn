// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../../extensions/bytes_encoding.dart";
import "../../../extensions/non_negative_integer.dart";
import "../../../result/option.dart";
import "../../../result/result.dart";
import "../../name/name_component.dart";
import "../../tlv_element.dart";
import "../../tlv_type.dart";
import "content_type.dart";
import "final_block_id.dart";
import "freshness_period.dart";

final class MetaInfo extends KnownTlvElement {
  const MetaInfo({
    this.contentType,
    this.freshnessPeriod,
    this.finalBlockId,
  });

  @override
  TlvType get tlvType => TlvType.metaInfo;

  static Result<MetaInfo, DecodingException> fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    Option<ContentType>? maybeContentType;
    Option<FreshnessPeriod>? maybeFreshnessPeriod;
    Option<FinalBlockId>? maybeFinalBlockId;

    for (final tlvElement in tlvElements) {
      switch (tlvElement) {
        case Success<ContentType, DecodingException>(:final tlvElement):
          if (maybeContentType == null) {
            maybeContentType = Some(tlvElement);
            continue;
          }
          return Fail(
            DecodingException(
              tlvElement.type,
              "Encountered out-of-order ContentType",
            ),
          );
        case Success<FreshnessPeriod, DecodingException>(:final tlvElement):
          maybeContentType ??= const None();
          if (maybeFreshnessPeriod == null) {
            maybeFreshnessPeriod = Some(tlvElement);
            continue;
          }
          return Fail(
            DecodingException(
              tlvElement.type,
              "Encountered out-of-order FreshnessPeriod",
            ),
          );
        case Success<FinalBlockId, DecodingException>(:final tlvElement):
          maybeContentType ??= const None();
          maybeFreshnessPeriod ??= const None();
          if (maybeFinalBlockId == null) {
            maybeFinalBlockId = Some(tlvElement);
            continue;
          }
          return Fail(
            DecodingException(
              tlvElement.type,
              "Encountered out-of-order FinalBlockId",
            ),
          );
        case Success(:final tlvElement):
          if (tlvElement.isCritical) {
            return Fail(
              DecodingException(
                tlvElement.type,
                "Encountered unrecognized TlvElement",
              ),
            );
          }
        case Fail(:final exception):
          return Fail(exception);
      }
    }

    return Success(
      MetaInfo(
        contentType: maybeContentType?.unwrapOrNull()?.value,
        freshnessPeriod: maybeFreshnessPeriod?.unwrapOrNull()?.duration,
        finalBlockId: maybeFinalBlockId?.unwrapOrNull()?.nameComponent,
      ),
    );
  }

  final NonNegativeInteger? contentType;

  final Duration? freshnessPeriod;

  final NameComponent? finalBlockId;

  @override
  List<int> get encodedValue {
    final List<int> result = [];

    final contentType = this.contentType;
    if (contentType != null) {
      result.addAll(ContentType(contentType).encode());
    }

    final freshnessPeriod = this.freshnessPeriod;
    if (freshnessPeriod != null) {
      result.addAll(FreshnessPeriod(freshnessPeriod).encode());
    }

    final finalBlockId = this.finalBlockId;

    if (finalBlockId != null) {
      result.addAll(finalBlockId.encode());
    }

    return result;
  }
}
