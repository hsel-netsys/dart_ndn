// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

// ignore_for_file: avoid_print

import "package:convert/convert.dart";
import "package:dart_ndn/dart_ndn.dart";

import "common.dart";

Future<void> main() async {
  final consumer = await Consumer.create(nfdFaceUri);

  final result = await consumer.expressInterest(Name.fromString("foo/bar"));

  switch (result) {
    case NackReceived():
      print("Received NACK");
    case InterestTimedOut():
      print("Interest timed out");
    case DataReceived():
      print("Received Data Packet");
      final content = result.data.content;
      print(content);

      if (content != null) {
        print("Content: ${hex.encode(content)}");
      }
  }

  await consumer.shutdown();
}
