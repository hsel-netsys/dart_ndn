// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
import "../../result/result.dart";
import "../name/name.dart";
import "../signature/data_signature.dart";
import "../signature/signature_type.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";
import "data_packet/content.dart";
import "data_packet/meta_info.dart";
import "ndn_packet.dart";

final class DataPacket extends NdnPacket {
  const DataPacket(
    this.name, {
    this.content,
    this.metaInfo,
  });

  // TODO: Make decoding more robust.
  static Result<DataPacket, DecodingException> fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    final tlvIterator = tlvElements.iterator..moveNext();

    final Name name;
    switch (tlvIterator.current) {
      case Success(:final tlvElement):
        if (tlvElement is Name) {
          name = tlvElement;
        } else {
          return Fail(
            DecodingException(
              tlvElement.type,
              "Expected Name TlvElement, encountered ${tlvElement.runtimeType}",
            ),
          );
        }
      case Fail(:final exception):
        return Fail(exception);
    }

    tlvIterator.moveNext();

    final MetaInfo? metaInfo;

    switch (tlvIterator.current) {
      case Success<MetaInfo, DecodingException>(:final tlvElement):
        metaInfo = tlvElement;
      // TODO: Handle missing content
      default:
        metaInfo = null;
    }

    tlvIterator.moveNext();

    final List<int>? content;

    switch (tlvIterator.current) {
      case Success(:final tlvElement):
        content = tlvElement.encodedValue;
      // TODO: Handle missing content
      default:
        content = null;
    }

    final result = DataPacket(
      name,
      metaInfo: metaInfo,
      content: content,
    );
    return Success(result);
  }

  final Name name;

  final MetaInfo? metaInfo;

  final List<int>? content;

  @override
  TlvType get tlvType => TlvType.data;

  @override
  List<int> get encodedValue {
    final result = name.encode().toList();

    final content = this.content;
    if (content != null) {
      result.addAll(Content(content).encode());
    }

    const signatureType = SignatureType(SignatureTypeValue.digestSha256);
    final dataSignature = DataSignature.create(content ?? [], signatureType);

    result.addAll(dataSignature.encode());

    return result;
  }
}
