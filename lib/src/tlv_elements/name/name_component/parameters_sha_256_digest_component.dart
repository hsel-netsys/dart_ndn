// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

part of "../name_component.dart";

/// The parameters digest component (ParametersSha256DigestComponent) contains
/// the SHA-256 digest computed over the portion of an Interest starting
/// from and including the ApplicationParameters element until the end of the
/// Interest.
///
/// This digest provides uniqueness of the Interest name for a given set of
/// parameters and securely ensures that the retrieved Data packet is a response
/// generated against the correct set of parameters.
///
/// See the [NDN Packet Specification] for more information.
///
/// [NDN Packet Specification]: https://docs.named-data.net/NDN-packet-spec/current/name.html#parameters-digest-component
final class ParametersSha256DigestComponent extends NameComponent {
  const ParametersSha256DigestComponent(this.encodedValue);

  static const int _digestLength = 32;

  static Result<ParametersSha256DigestComponent> fromValue(List<int> value) {
    final length = value.length;

    if (length != _digestLength) {
      return Fail(
        FormatException("Encountered an invalid digest length of $length}"),
      );
    }

    return Success(ParametersSha256DigestComponent(value));
  }

  @override
  TlvType get tlvType => TlvType.parametersSha256DigestComponent;

  @override
  final List<int> encodedValue;

  /// Indicates whether the SHA-256 value has a [length] of 32 bytes.
  @override
  bool get isValid => length == _digestLength;

  @override
  TlvValueFormat get tlvValueFormat => TlvValueFormat.octet32;
}
