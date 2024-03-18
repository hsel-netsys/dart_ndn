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
///  generated against the correct set of parameters.
///
/// See the [NDN Packet Specification] for more information.
///
/// [NDN Packet Specification]: https://docs.named-data.net/NDN-packet-spec/current/name.html#parameters-digest-component
final class ParametersSha256DigestComponent extends NameComponent {
  const ParametersSha256DigestComponent(this.value);

  @override
  TlvType get tlvType => TlvType.implicitSha256DigestComponent;

  @override
  final List<int> value;

  /// Indicates whether the SHA-256 value has a [length] of 32 bytes.
  bool get isValid => length == 32;

  @override
  TlvValueFormat get tlvValueFormat => TlvValueFormat.octet32;
}
