// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../tlv_element.dart";
import "../tlv_type.dart";

/// The SignatureNonce element adds additional assurances that a signature will
/// be unique.
///
/// The recommended minimum length for a [SignatureNonce] element is 8 octets.
// TODO: Introduce common base class for simple value elements like this one
final class SignatureNonce extends KnownTlvElement {
  const SignatureNonce(this.value);

  @override
  TlvType get tlvType => TlvType.signatureNonce;

  @override
  final List<int> value;
}
