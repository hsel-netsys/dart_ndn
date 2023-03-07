// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:meta/meta.dart";

import "../extensions/int_encoding.dart";
import "name/name.dart";
import "name/name_component.dart";
import "nfd_management/control_parameters.dart";
import "nfd_management/control_response.dart";
import "nfd_management/status.dart";
import "nonce.dart";
import "packet/data_packet.dart";
import "packet/data_packet/content.dart";
import "packet/interest_packet.dart";
import "packet/lp_packet.dart";
import "packet/nack_packet.dart";
import "tlv_type.dart";

@immutable
abstract class TlvElement {
  const TlvElement();

  int get type;

  int get length => value.length;

  List<int> get value;

  Iterable<int> encode() sync* {
    yield* type.encodeAsNdnTlv();
    yield* length.encodeAsNdnTlv();
    yield* value;
  }

  @override
  int get hashCode => Object.hashAll([type, value]);

  @override
  bool operator ==(Object other) {
    if (other is! TlvElement) {
      return false;
    }

    final otherIterator = other.value.iterator;

    for (final byte in value) {
      if (!otherIterator.moveNext()) {
        return false;
      }

      if (byte != otherIterator.current) {
        return false;
      }
    }

    return true;
  }

  static TlvElement parse(int type, List<int> value) {
    final parsedTlvType = TlvType.tryParse(type);

    if (parsedTlvType == null) {
      return UnknownTlvElement(type, value);
    }

    // TODO: Create classes for all defined TlvElements...
    switch (parsedTlvType) {
      case TlvType.interest:
        return InterestPacket.fromValue(value);
      case TlvType.data:
        return DataPacket.fromValue(value);
      case TlvType.lpPacket:
        return LpPacket.fromValue(value);
      case TlvType.nack:
        return NackPacket.fromValue(value);
      case TlvType.name:
        return Name.fromValue(value);
      case TlvType.genericNameComponent:
        return GenericNameComponent.fromValue(value);
      case TlvType.nackReason:
        return NackReason.fromValue(value);
      case TlvType.nonce:
        return Nonce(value);
      case TlvType.controlParameters:
        return ControlParameters.fromValue(value);
      case TlvType.controlResponse:
        return ControlResponse.fromValue(value);
      case TlvType.statusCode:
        return StatusCode.fromValue(value);
      case TlvType.statusText:
        return StatusText.fromValue(value);
      case TlvType.content:
        return Content(value);
      case TlvType.implicitSha256DigestComponent:
      // TODO: Handle this case.
      case TlvType.parametersSha256DigestComponent:
      // TODO: Handle this case.
      case TlvType.keywordNameComponent:
      // TODO: Handle this case.
      case TlvType.segmentNameComponent:
      // TODO: Handle this case.
      case TlvType.byteOffsetNameComponent:
      // TODO: Handle this case.
      case TlvType.versionNameComponent:
      // TODO: Handle this case.
      case TlvType.timestampNameComponent:
      // TODO: Handle this case.
      case TlvType.sequenceNumNameComponent:
      // TODO: Handle this case.
      case TlvType.canBePrefix:
      // TODO: Handle this case.
      case TlvType.mustBeFresh:
      // TODO: Handle this case.
      case TlvType.forwardingHint:
      // TODO: Handle this case.
      case TlvType.interestLifetime:
      // TODO: Handle this case.
      case TlvType.hopLimit:
      // TODO: Handle this case.
      case TlvType.applicationParameters:
      // TODO: Handle this case.
      case TlvType.interestSignatureInfo:
      // TODO: Handle this case.
      case TlvType.interestSignatureValue:
      // TODO: Handle this case.
      case TlvType.metaInfo:
      // TODO: Handle this case.
      case TlvType.signatureInfo:
      // TODO: Handle this case.
      case TlvType.contentType:
      // TODO: Handle this case.
      case TlvType.freshnessPeriod:
      // TODO: Handle this case.
      case TlvType.finalBlockId:
      // TODO: Handle this case.
      case TlvType.signatureType:
      // TODO: Handle this case.
      case TlvType.keyLocator:
      // TODO: Handle this case.
      case TlvType.keyDigest:
      // TODO: Handle this case.
      case TlvType.signatureNonce:
      // TODO: Handle this case.
      case TlvType.signatureTime:
      // TODO: Handle this case.
      case TlvType.signatureSeqNum:
      // TODO: Handle this case.
      case TlvType.validityPeriod:
      // TODO: Handle this case.
      case TlvType.notBefore:
      // TODO: Handle this case.
      case TlvType.notAfter:
      // TODO: Handle this case.
      case TlvType.additionalDescription:
      // TODO: Handle this case.
      case TlvType.descriptionEntry:
      // TODO: Handle this case.
      case TlvType.descriptionKey:
      // TODO: Handle this case.
      case TlvType.descriptionValue:
      // TODO: Handle this case.
      case TlvType.fragment:
      // TODO: Handle this case.
      case TlvType.sequence:
      // TODO: Handle this case.
      case TlvType.fragIndex:
      // TODO: Handle this case.
      case TlvType.fragCount:
      // TODO: Handle this case.
      case TlvType.hopCount:
      // TODO: Handle this case.
      case TlvType.geoTag:
      // TODO: Handle this case.
      case TlvType.pitToken:
      // TODO: Handle this case.
      case TlvType.incomingFaceId:
      // TODO: Handle this case.
      case TlvType.nextHopFaceId:
      // TODO: Handle this case.
      case TlvType.cachePolicy:
      // TODO: Handle this case.
      case TlvType.cachePolicyType:
      // TODO: Handle this case.
      case TlvType.congestionMark:
      // TODO: Handle this case.
      case TlvType.ack:
      // TODO: Handle this case.
      case TlvType.txSequence:
      // TODO: Handle this case.
      case TlvType.nonDiscovery:
      // TODO: Handle this case.
      case TlvType.prefixAnnouncement:
      // TODO: Handle this case.
      case TlvType.signatureValue:
      // TODO: Handle this case.
    }

    return UnknownTlvElement(type, value);
  }
}

abstract class KnownTlvElement extends TlvElement {
  const KnownTlvElement();

  TlvType get tlvType;

  @override
  int get type => tlvType.number;
}

final class UnknownTlvElement extends TlvElement {
  const UnknownTlvElement(this.type, this.value);

  @override
  final int type;

  @override
  final List<int> value;
}
