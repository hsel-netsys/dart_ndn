// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/bytes_encoding.dart";
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

  factory DataPacket.fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    final tlvIterator = tlvElements.iterator;

    final missingNameException = Exception("Missing name in data packet");

    if (!tlvIterator.moveNext()) {
      throw missingNameException;
    }

    final name = tlvIterator.current;

    if (name is! Name) {
      throw missingNameException;
    }

    tlvIterator
      // Skip MetaInfo for now
      ..moveNext()
      ..moveNext();

    final List<int>? contentValue;

    final content = tlvIterator.current;

    if (content is Content) {
      contentValue = content.value;
    } else {
      contentValue = null;
    }

    return DataPacket(name, content: contentValue);
  }

  final Name name;

  final List<int>? content;

  @override
  TlvType get tlvType => TlvType.data;

  @override
  List<int> get value {
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
