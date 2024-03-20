// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

part of "../name_component.dart";

final class KeywordNameComponent extends NameComponent {
  const KeywordNameComponent(this.encodedValue);

  static Result<KeywordNameComponent> fromValue(List<int> value) {
    // TODO: Are there any requirements for this type?
    return Success(KeywordNameComponent(value));
  }

  @override
  final List<int> encodedValue;

  @override
  TlvType get tlvType => TlvType.keywordNameComponent;
}

sealed class NonNegativeIntegerNameComponent extends NameComponent {
  const NonNegativeIntegerNameComponent(this.value);

  final NonNegativeInteger value;

  @override
  List<int> get encodedValue => value.encode();
}

final class SegmentNameComponent extends NonNegativeIntegerNameComponent {
  const SegmentNameComponent(super.encodedValue);

  static Result<SegmentNameComponent> fromValue(List<int> value) {
    switch (NonNegativeInteger.fromValue(value)) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        return Success(SegmentNameComponent(tlvElement));
      case Fail(:final exception):
        return Fail(exception);
    }
  }

  @override
  TlvType get tlvType => TlvType.segmentNameComponent;

  @override
  String toPathSegment() => "seg=$percentEncodedValue";
}

final class ByteOffsetNameComponent extends NonNegativeIntegerNameComponent {
  const ByteOffsetNameComponent(super.encodedValue);

  static Result<ByteOffsetNameComponent> fromValue(List<int> value) {
    switch (NonNegativeInteger.fromValue(value)) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        return Success(ByteOffsetNameComponent(tlvElement));
      case Fail(:final exception):
        return Fail(exception);
    }
  }

  @override
  TlvType get tlvType => TlvType.byteOffsetNameComponent;

  @override
  String toPathSegment() => "off=$percentEncodedValue";
}

final class VersionNameComponent extends NonNegativeIntegerNameComponent {
  const VersionNameComponent(super.encodedValue);

  static Result<VersionNameComponent> fromValue(List<int> value) {
    switch (NonNegativeInteger.fromValue(value)) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        return Success(VersionNameComponent(tlvElement));
      case Fail(:final exception):
        return Fail(exception);
    }
  }

  @override
  TlvType get tlvType => TlvType.versionNameComponent;

  @override
  String toPathSegment() => "v=$percentEncodedValue";
}

final class TimestampNameComponent extends NonNegativeIntegerNameComponent {
  const TimestampNameComponent(super.encodedValue);

  static Result<TimestampNameComponent> fromValue(List<int> value) {
    switch (NonNegativeInteger.fromValue(value)) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        return Success(TimestampNameComponent(tlvElement));
      case Fail(:final exception):
        return Fail(exception);
    }
  }

  @override
  TlvType get tlvType => TlvType.timestampNameComponent;

  @override
  String toPathSegment() => "t=$percentEncodedValue";
}

final class SequenceNumNameComponent extends NonNegativeIntegerNameComponent {
  const SequenceNumNameComponent(super.encodedValue);

  static Result<SequenceNumNameComponent> fromValue(List<int> value) {
    switch (NonNegativeInteger.fromValue(value)) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        return Success(SequenceNumNameComponent(tlvElement));
      case Fail(:final exception):
        return Fail(exception);
    }
  }

  @override
  TlvType get tlvType => TlvType.sequenceNumNameComponent;

  @override
  String toPathSegment() => "t=$percentEncodedValue";
}
