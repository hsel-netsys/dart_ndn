// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:convert";

import "package:dart_ndn/dart_ndn.dart";
import "package:dart_ndn/src/tlv_elements/signature/signature_type.dart";

import "common.dart";

Future<void> main() async {
  final signer = Signer(SignatureTypeValue.digestSha256);
  final producer = await Producer.create(uri: nfdFaceUri, signer: signer);

  await producer.registerPrefix(Name.fromString("foo"));

  await for (final interest in producer) {
    await producer.satifisfyInterest(interest, utf8.encode("test"));
  }
}
