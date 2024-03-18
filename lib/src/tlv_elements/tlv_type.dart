// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

enum TlvType {
  interest(5, TypeCategory.packetType),
  data(6, TypeCategory.packetType),

  name(7, TypeCategory.commonField),

  genericNameComponent(8, TypeCategory.nameComponent),
  implicitSha256DigestComponent(1, TypeCategory.nameComponent),
  parametersSha256DigestComponent(2, TypeCategory.nameComponent),
  keywordNameComponent(32, TypeCategory.nameComponent),
  segmentNameComponent(50, TypeCategory.nameComponent),
  byteOffsetNameComponent(52, TypeCategory.nameComponent),
  versionNameComponent(54, TypeCategory.nameComponent),
  timestampNameComponent(56, TypeCategory.nameComponent),
  sequenceNumNameComponent(58, TypeCategory.nameComponent),

  canBePrefix(33, TypeCategory.interestPacket),
  mustBeFresh(18, TypeCategory.interestPacket),
  forwardingHint(30, TypeCategory.interestPacket),
  nonce(10, TypeCategory.interestPacket),
  interestLifetime(12, TypeCategory.interestPacket),
  hopLimit(34, TypeCategory.interestPacket),
  applicationParameters(36, TypeCategory.interestPacket),
  interestSignatureInfo(44, TypeCategory.interestPacket),
  interestSignatureValue(46, TypeCategory.interestPacket),

  metaInfo(20, TypeCategory.dataPacket),
  content(21, TypeCategory.dataPacket),
  signatureInfo(22, TypeCategory.dataPacket),
  signatureValue(23, TypeCategory.dataPacket),

  contentType(24, TypeCategory.metaInfo),
  freshnessPeriod(25, TypeCategory.metaInfo),
  finalBlockId(26, TypeCategory.metaInfo),

  signatureType(27, TypeCategory.signature),
  keyLocator(28, TypeCategory.signature),
  keyDigest(29, TypeCategory.signature),
  signatureNonce(38, TypeCategory.signature),
  signatureTime(40, TypeCategory.signature),
  signatureSeqNum(42, TypeCategory.signature),

  validityPeriod(253, TypeCategory.certificate),
  notBefore(254, TypeCategory.certificate),
  notAfter(255, TypeCategory.certificate),
  additionalDescription(258, TypeCategory.certificate),
  descriptionEntry(512, TypeCategory.certificate),
  descriptionKey(513, TypeCategory.certificate),
  descriptionValue(514, TypeCategory.certificate),

  fragment(80, TypeCategory.ndnLpV2),
  sequence(81, TypeCategory.ndnLpV2),
  fragIndex(82, TypeCategory.ndnLpV2),
  fragCount(83, TypeCategory.ndnLpV2),
  hopCount(84, TypeCategory.ndnLpV2),
  geoTag(85, TypeCategory.ndnLpV2),
  pitToken(98, TypeCategory.ndnLpV2),
  lpPacket(100, TypeCategory.ndnLpV2),
  nack(800, TypeCategory.ndnLpV2),
  nackReason(801, TypeCategory.ndnLpV2),
  incomingFaceId(812, TypeCategory.ndnLpV2),
  nextHopFaceId(816, TypeCategory.ndnLpV2),
  cachePolicy(820, TypeCategory.ndnLpV2),
  cachePolicyType(821, TypeCategory.ndnLpV2),
  congestionMark(832, TypeCategory.ndnLpV2),
  ack(836, TypeCategory.ndnLpV2),
  txSequence(840, TypeCategory.ndnLpV2),
  nonDiscovery(844, TypeCategory.ndnLpV2),
  prefixAnnouncement(848, TypeCategory.ndnLpV2),

  // NFD Management
  controlResponse(101, TypeCategory.nfdManagement),
  statusCode(102, TypeCategory.nfdManagement),
  statusText(103, TypeCategory.nfdManagement),
  controlParameters(104, TypeCategory.nfdManagement),
  ;

  const TlvType(this.number, this.category);

  final int number;

  final TypeCategory category;

  bool get isCritical {
    if (number & 1 == 1) {
      return true;
    }

    return number >= 0 && number <= 31;
  }

  static final _registry = Map.fromEntries(
    TlvType.values.map((type) => MapEntry(type.number, type)),
  );

  static TlvType? tryParse(int tlvNumber) => _registry[tlvNumber];
}

enum TypeCategory {
  packetType,
  commonField,
  nameComponent,
  interestPacket,
  dataPacket,
  metaInfo,
  signature,
  certificate,
  ndnLpV2,
  nfdManagement,
  other,
  ;
}
