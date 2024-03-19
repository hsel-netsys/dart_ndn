// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/int_encoding.dart";
import "../../extensions/non_negative_integer.dart";
import "../tlv_type.dart";

// TODO: https://docs.named-data.net/NDN-packet-spec/current/signature.html#signature-elements
enum SignatureType {
  digestSha256(0),
  signatureSha256WithRsa(1),
  signatureSha256WithEcdsa(3),
  signatureHmacWithSha256(4),
  signatureEd25519(5),
  ;

  const SignatureType(this._numericValue);

  final int _numericValue;

  NonNegativeInteger get numericValue => NonNegativeInteger(_numericValue);

  int get type => tlvType.number;

  TlvType get tlvType => TlvType.signatureType;

  List<int> get value => numericValue.encode();

  int get length => value.length;

  List<int> encode() {
    return [
      ...type.encodeAsNdnTlv(),
      ...length.encodeAsNdnTlv(),
      ...value,
    ];
  }
}
