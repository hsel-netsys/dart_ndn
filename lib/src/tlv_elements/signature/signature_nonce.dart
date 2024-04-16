// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../result/result.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";

/// The SignatureNonce element adds additional assurances that a signature will
/// be unique.
///
/// The recommended minimum length for a [SignatureNonce] element is 8 octets.
// TODO: Introduce common base class for simple value elements like this one
final class SignatureNonce extends OctetTlvElement {
  const SignatureNonce(super.value);

  static Result<SignatureNonce, DecodingException> fromValue(List<int> value) =>
      Success(SignatureNonce(value));

  @override
  TlvType get tlvType => TlvType.signatureNonce;
}
