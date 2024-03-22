// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

part of "../name_component.dart";

final class GenericNameComponent extends NameComponent {
  const GenericNameComponent(this.encodedValue);

  static Result<GenericNameComponent, DecodingException> fromValue(
    List<int> value,
  ) =>
      Success(GenericNameComponent(value));

  // TODO: Deal with special characters: https://docs.named-data.net/NDN-packet-spec/current/name.html#ndn-uri-scheme
  String get content => percent.encode(encodedValue);

  @override
  TlvType get tlvType => TlvType.genericNameComponent;

  @override
  final List<int> encodedValue;

  @override
  String toPathSegment() => percentEncodedValue;
}
