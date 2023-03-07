// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

part of "../name_component.dart";

/// The implicit digest component consists of the SHA-256 digest of the entire
/// Data packet bits.
///
/// Having this digest as the last name component allows identifying one
/// specific Data packet and no other.
///
/// See the [NDN Packet Specification] for more information.
///
/// [NDN Packet Specification]: https://docs.named-data.net/NDN-packet-spec/current/name.html#implicit-digest-component
final class ImplicitSha256DigestComponent extends NameComponent {
  const ImplicitSha256DigestComponent(this.value);

  @override
  TlvType get tlvType => TlvType.implicitSha256DigestComponent;

  @override
  final List<int> value;

  /// Indicates whether the SHA-256 [value] has a [length] of 32 bytes.
  bool get isValid => length == 32;

  @override
  TlvValueFormat get tlvValueFormat => TlvValueFormat.octet32;
}
