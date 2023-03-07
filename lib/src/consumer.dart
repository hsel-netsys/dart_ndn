// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:async";

import "face.dart";
import "result/interest_expression_result.dart";
import "tlv_elements/name/name.dart";
import "tlv_elements/nonce.dart";
import "tlv_elements/packet/interest_packet.dart";
import "transport.dart";

class Consumer {
  Consumer(this._face);

  static Future<Consumer> create([Uri? uri]) async {
    final Transport transport;

    final faceUri = uri ?? Uri(scheme: "unix");

    switch (faceUri.scheme) {
      case "unix":
        final path = faceUri.path;
        transport = await UnixTransport.create(path.isNotEmpty ? path : null);
      case "tcp4":
      case "tcp6":
        transport = await TcpTransport.create(faceUri);
      default:
        throw ArgumentError.value(faceUri.scheme);
    }

    final face = Face.fromTransport(transport);
    final consumer = Consumer(face).._hasInternalFace = true;

    return consumer;
  }

  final Face _face;

  bool _hasInternalFace = false;

  bool get hasInternalFace => _hasInternalFace;

  Future<InterestExpressionResult> expressInterest(
    Name name, {
    bool canBePrefix = false,
    bool mustBeFresh = false,
    Duration lifeTime = const Duration(seconds: 4),
    int? hoplimit,
    // TODO: Should this be exposed?
    List<Name>? forwardingHintNames,
  }) async {
    final ForwardingHint? forwardingHint;

    if (forwardingHintNames != null) {
      forwardingHint = ForwardingHint(forwardingHintNames);
    } else {
      forwardingHint = null;
    }

    final interest = InterestPacket.fromName(
      name,
      canBePrefix: canBePrefix,
      mustBeFresh: mustBeFresh,
      lifetime: lifeTime,
      hopLimit: hoplimit,
      forwardingHint: forwardingHint,
    );

    return _face.expressInterest(interest);
  }

  Future<void> shutdown() async {
    if (_hasInternalFace) {
      await _face.shutdown();
    }
  }
}
