// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

part of "../name_component.dart";

// TODO: Differentiate TLV-VALUE Format, see https://redmine.named-data.net/projects/ndn-tlv/wiki/NameComponentType
// TODO: Support Alternate Uri-Format, see https://redmine.named-data.net/projects/ndn-tlv/wiki/NameComponentType

/// This class serves as the basis for [NameComponent]s of other component types
/// governed by the [Name Component Assignment policy].
///
/// [Name Component Assignment policy]: https://redmine.named-data.net/projects/ndn-tlv/wiki/NameComponentType
sealed class OtherTypeComponent extends NameComponent {
  const OtherTypeComponent(this.value);

  @override
  final List<int> value;

  @override
  TlvValueFormat get tlvValueFormat => TlvValueFormat.nonNegativeInteger;
}

final class KeywordNameComponent extends OtherTypeComponent {
  const KeywordNameComponent(super.value);

  @override
  TlvType get tlvType => TlvType.keywordNameComponent;

  @override
  TlvValueFormat get tlvValueFormat => TlvValueFormat.octetStar;
}

final class SegmentNameComponent extends OtherTypeComponent {
  const SegmentNameComponent(super.value);

  @override
  TlvType get tlvType => TlvType.segmentNameComponent;
}

final class ByteOffsetNameComponent extends OtherTypeComponent {
  const ByteOffsetNameComponent(super.value);

  @override
  TlvType get tlvType => TlvType.byteOffsetNameComponent;
}

final class VersionNameComponent extends OtherTypeComponent {
  const VersionNameComponent(super.value);

  @override
  TlvType get tlvType => TlvType.versionNameComponent;
}

final class TimestampNameComponent extends OtherTypeComponent {
  const TimestampNameComponent(super.value);

  @override
  TlvType get tlvType => TlvType.timestampNameComponent;
}

final class SequenceNumNameComponent extends OtherTypeComponent {
  const SequenceNumNameComponent(super.value);

  @override
  TlvType get tlvType => TlvType.sequenceNumNameComponent;
}
