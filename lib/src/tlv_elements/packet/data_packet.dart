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
import "../tlv_type.dart";
import "data_packet/content.dart";
import "ndn_packet.dart";

final class DataPacket extends NdnPacket {
  const DataPacket(
    this.name, {
    this.content,
  });

  static Result<DataPacket> fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    final tlvIterator = tlvElements.iterator..moveNext();

    final Name name;
    switch (tlvIterator.current) {
      case Success(:final tlvElement):
        if (tlvElement is Name) {
          name = tlvElement;
        } else {
          return Fail(
            FormatException(
              "Expected Name TlvElement, encountered ${tlvElement.runtimeType}",
            ),
          );
        }
      case Fail(:final exception):
        return Fail(exception);
      default:
        return Fail(Exception("Missing name in data packet"));
    }

    tlvIterator
      // Skip MetaInfo for now
      ..moveNext()
      ..moveNext();

    final List<int>? content;

    switch (tlvIterator.current) {
      case Success(:final tlvElement):
        content = tlvElement.encodedValue;
      // TODO: Handle missing content
      default:
        content = null;
    }

    final result = DataPacket(name, content: content);
    return Success(result);
  }

  final Name name;

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
