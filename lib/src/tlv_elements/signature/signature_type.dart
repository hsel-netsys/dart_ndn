// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../../extensions/int_encoding.dart";
import "../../extensions/non_negative_integer.dart";
import "../../result/result.dart";
import "../tlv_element.dart";
import "../tlv_type.dart";

final class SignatureType extends KnownTlvElement {
  const SignatureType(this.signaturTypeValue);

  static Result<SignatureType, DecodingException> fromValue(List<int> value) {
    final decodedValue = NonNegativeInteger.fromValue(value);

    switch (decodedValue) {
      // ignore: pattern_never_matches_value_type
      case Success(:final tlvElement):
        final parsedValue = SignatureTypeValue.tryParse(tlvElement);
        if (parsedValue == null) {
          // TODO: Improve error handling
          return Fail(
            DecodingException(
              TlvType.signatureType.number,
              "Unkown value $value ",
            ),
          );
        }
        return Success(SignatureType(parsedValue));
      case Fail(:final exception):
        return Fail(
          DecodingException(
            TlvType.signatureType.number,
            exception.message,
          ),
        );
    }
  }

  final SignatureTypeValue signaturTypeValue;

  @override
  TlvType get tlvType => TlvType.signatureValue;

  @override
  List<int> get encodedValue => signaturTypeValue.encode();
}

// TODO: https://docs.named-data.net/NDN-packet-spec/current/signature.html#signature-elements
enum SignatureTypeValue {
  digestSha256(0),
  signatureSha256WithRsa(1),
  signatureSha256WithEcdsa(3),
  signatureHmacWithSha256(4),
  signatureEd25519(5),
  ;

  const SignatureTypeValue(this._numericValue);

  static SignatureTypeValue? tryParse(NonNegativeInteger value) {
    return _registry[value];
  }

  static final _registry =
      Map.fromEntries(values.map((e) => MapEntry(e._numericValue, e)));

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
