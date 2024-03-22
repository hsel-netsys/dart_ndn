// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:collection/collection.dart";
import "package:crypto/crypto.dart";

import "tlv_elements/name/name.dart";
import "tlv_elements/name/name_component.dart";
import "tlv_elements/packet/interest_packet.dart";
import "tlv_elements/packet/interest_packet/application_parameters.dart";
import "tlv_elements/signature/interest_signature_info.dart";
import "tlv_elements/signature/interest_signature_value.dart";
import "tlv_elements/signature/signature_type.dart";

class Signer {
  Signer(this.signatureTypeValue);

  final SignatureTypeValue signatureTypeValue;

  InterestPacket signInterest(InterestPacket interestPacket) {
    final nameComponents = [...interestPacket.name.nameComponents]
        .whereNot((element) => element is ParametersSha256DigestComponent)
        .toList();
    final orginalName = Name(nameComponents);

    final applicationParameters =
        interestPacket.applicationParameters ?? const ApplicationParameters([]);

    final interestSignatureInfo =
        InterestSignatureInfo(SignatureType(signatureTypeValue));

    final yo = InterestPacket.fromName(
      orginalName,
      canBePrefix: interestPacket.canBePrefix,
      mustBeFresh: interestPacket.mustBeFresh,
      nonce: interestPacket.nonce?.encodedValue,
      forwardingHint: interestPacket.forwardingHint,
      applicationParameters: applicationParameters,
      interestSignatureInfo: interestSignatureInfo,
    );

    final List<int> signature;

    switch (signatureTypeValue) {
      case SignatureTypeValue.digestSha256:
        signature = sha256.convert(yo.encode()).bytes;
      default:
        throw UnimplementedError();
    }

    nameComponents.add(ParametersSha256DigestComponent(signature));

    return InterestPacket.fromName(
      orginalName,
      canBePrefix: interestPacket.canBePrefix,
      mustBeFresh: interestPacket.mustBeFresh,
      nonce: interestPacket.nonce?.encodedValue,
      forwardingHint: interestPacket.forwardingHint,
      applicationParameters: applicationParameters,
      interestSignatureInfo: interestSignatureInfo,
      interestSignatureValue: InterestSignatureValue(signature),
    );
  }
}
