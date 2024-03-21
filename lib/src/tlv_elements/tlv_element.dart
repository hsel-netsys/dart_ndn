// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:meta/meta.dart";

import "../extensions/int_encoding.dart";
import "../extensions/non_negative_integer.dart";
import "../result/result.dart";
import "name/name.dart";
import "name/name_component.dart";
import "nfd_management/control_parameters.dart";
import "nfd_management/control_response.dart";
import "nfd_management/status.dart";
import "nonce.dart";
import "packet/data_packet.dart";
import "packet/data_packet/content.dart";
import "packet/data_packet/content_type.dart";
import "packet/data_packet/final_block_id.dart";
import "packet/data_packet/freshness_period.dart";
import "packet/data_packet/meta_info.dart";
import "packet/interest_packet.dart";
import "packet/interest_packet/application_parameters.dart";
import "packet/lp_packet.dart";
import "packet/nack_packet.dart";
import "signature/interest_signature_info.dart";
import "signature/interest_signature_value.dart";
import "signature/key_locator.dart";
import "signature/signature_info.dart";
import "signature/signature_nonce.dart";
import "signature/signature_seq_num.dart";
import "signature/signature_time.dart";
import "signature/signature_type.dart";
import "signature/signature_value.dart";
import "tlv_type.dart";

@immutable
abstract base class TlvElement {
  const TlvElement();

  int get type;

  bool get isCritical => type <= 31 || type & 1 == 1;

  int get length => encodedValue.length;

  List<int> get encodedValue;

  List<int> encode() => [
        ...type.encodeAsNdnTlv(),
        ...length.encodeAsNdnTlv(),
        ...encodedValue,
      ];

  @override
  int get hashCode => Object.hashAll([type, encodedValue]);

  @override
  bool operator ==(Object other) {
    if (other is! TlvElement) {
      return false;
    }

    final otherIterator = other.encodedValue.iterator;

    for (final byte in encodedValue) {
      if (!otherIterator.moveNext()) {
        return false;
      }

      if (byte != otherIterator.current) {
        return false;
      }
    }

    return true;
  }

  static Result<TlvElement> parse(int type, List<int> value) {
    final parsedTlvType = TlvType.tryParse(type);

    if (parsedTlvType == null) {
      return Success(UnknownTlvElement(type, value));
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
        return Nonce.fromValue(value);
      case TlvType.controlParameters:
        return ControlParameters.fromValue(value);
      case TlvType.controlResponse:
        return ControlResponse.fromValue(value);
      case TlvType.statusCode:
        return StatusCode.fromValue(value);
      case TlvType.statusText:
        return StatusText.fromValue(value);
      case TlvType.content:
        return Content.fromValue(value);
      case TlvType.keyLocator:
        return KeyLocator.fromValue(value);
      case TlvType.keyDigest:
        return Success(KeyDigest(value));
      case TlvType.signatureValue:
        return Success(SignatureValue(value));
      case TlvType.signatureType:
        return SignatureType.fromValue(value);
      case TlvType.hopLimit:
        return HopLimit.fromValue(value);
      case TlvType.signatureTime:
        return SignatureTime.fromValue(value);
      case TlvType.mustBeFresh:
        return MustBeFresh.fromValue(value);
      case TlvType.implicitSha256DigestComponent:
        return ImplicitSha256DigestComponent.fromValue(value);
      case TlvType.parametersSha256DigestComponent:
        return ParametersSha256DigestComponent.fromValue(value);
      case TlvType.keywordNameComponent:
        return KeywordNameComponent.fromValue(value);
      case TlvType.canBePrefix:
        return CanBePrefix.fromValue(value);
      case TlvType.segmentNameComponent:
        return SegmentNameComponent.fromValue(value);
      case TlvType.byteOffsetNameComponent:
        return ByteOffsetNameComponent.fromValue(value);
      case TlvType.versionNameComponent:
        return VersionNameComponent.fromValue(value);
      case TlvType.timestampNameComponent:
        return TimestampNameComponent.fromValue(value);
      case TlvType.sequenceNumNameComponent:
        return SequenceNumNameComponent.fromValue(value);
      case TlvType.forwardingHint:
        return ForwardingHint.fromValue(value);
      case TlvType.interestLifetime:
        return InterestLifetime.fromValue(value);
      case TlvType.applicationParameters:
        return ApplicationParameters.fromValue(value);
      case TlvType.interestSignatureInfo:
        return InterestSignatureInfo.fromValue(value);
      case TlvType.interestSignatureValue:
        return InterestSignatureValue.fromValue(value);
      case TlvType.metaInfo:
        return MetaInfo.fromValue(value);
      case TlvType.signatureInfo:
        return SignatureInfo.fromValue(value);
      case TlvType.contentType:
        return ContentType.fromValue(value);
      case TlvType.freshnessPeriod:
        return FreshnessPeriod.fromValue(value);
      case TlvType.finalBlockId:
        return FinalBlockId.fromValue(value);
      case TlvType.signatureNonce:
        return SignatureNonce.fromValue(value);
      case TlvType.signatureSeqNum:
        return SignatureSeqNum.fromValue(value);
      // case TlvType.validityPeriod:
      //   return ValidatyPeriod.fromValue(value);
      // case TlvType.notBefore:
      //   return NotBefore.fromValue(value);
      // case TlvType.notAfter:
      //   return NotAfter.fromValue(value);
      // case TlvType.additionalDescription:
      //   return AdditionalDescription.fromValue(value);
      // case TlvType.descriptionEntry:
      //   return DescriptionEntry.fromValue(value);
      // case TlvType.descriptionKey:
      //   return DescriptionKey.fromValue(value);
      // case TlvType.descriptionValue:
      //   return DescriptionValue.fromValue(value);
      // case TlvType.fragment:
      //   return Fragment.fromValue(value);
      // case TlvType.sequence:
      //   return Sequence.fromValue(value);
      // case TlvType.fragIndex:
      //   return FragIndex.fromValue(value);
      // case TlvType.fragCount:
      //   return FragCount.fromValue(value);
      // case TlvType.hopCount:
      //   return HopCount.fromValue(value);
      // case TlvType.geoTag:
      //   return GeoTag.fromValue(value);
      // case TlvType.pitToken:
      //   return PitToken.fromValue(value);
      // case TlvType.incomingFaceId:
      //   return IncomingFaceId.fromValue(value);
      // case TlvType.nextHopFaceId:
      //   return NextHopFaceId.fromValue(value);
      // case TlvType.cachePolicy:
      //   return CachePolicy.fromValue(value);
      // case TlvType.cachePolicyType:
      //   return CachePolicyType.fromValue(value);
      // case TlvType.congestionMark:
      //   return CongestionMark.fromValue(value);
      // case TlvType.ack:
      //   return Ack.fromValue(value);
      // case TlvType.txSequence:
      //   return TxSequence.fromValue(value);
      // case TlvType.nonDiscovery:
      //   return NonDiscovery.fromValue(value);
      // case TlvType.prefixAnnouncement:
      //   return PrefixAnnouncement.fromValue(value);
      default:
        return Success(UnknownTlvElement(type, value));
    }
  }
}

abstract base class KnownTlvElement extends TlvElement {
  const KnownTlvElement();

  TlvType get tlvType;

  bool get isValid => true;

  @override
  int get type => tlvType.number;
}

abstract base class FlagTlvElement extends KnownTlvElement {
  const FlagTlvElement() : value = const <int>[];

  const FlagTlvElement.fromValue(this.value);

  @override
  bool get isValid => value.isEmpty;

  final List<int> value;

  @override
  List<int> get encodedValue => const [];
}

abstract base class NonNegativeIntegerTlvElement extends KnownTlvElement {
  const NonNegativeIntegerTlvElement(this.value);

  final NonNegativeInteger value;

  @override
  List<int> get encodedValue => value.encode();
}

abstract base class OctetTlvElement extends KnownTlvElement {
  const OctetTlvElement(this.value);

  final List<int> value;

  @override
  List<int> get encodedValue => value;
}

final class UnknownTlvElement extends TlvElement {
  const UnknownTlvElement(this.type, this.encodedValue);

  @override
  final int type;

  @override
  final List<int> encodedValue;
}
