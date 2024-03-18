// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:async";

import "result/interest_expression_result.dart";
import "tlv_elements/packet/data_packet.dart";
import "tlv_elements/packet/interest_packet.dart";
import "tlv_elements/packet/nack_packet.dart";
import "tlv_elements/packet/ndn_packet.dart";
import "transport.dart";

class Face extends Stream<NdnPacket> {
  Face.fromTransport(this.transport);

  static Future<Face> createFace(Uri uri) async {
    switch (uri.scheme) {
      case "tcp4":
      case "tcp6":
        final tcpTransport = await TcpTransport.create(uri);
        return Face.fromTransport(tcpTransport);
      case "unix":
        final unixTransport = await UnixTransport.create(uri.path);
        return Face.fromTransport(unixTransport);
    }

    throw ArgumentError("URI scheme ${uri.scheme} is not supported.");
  }

  final Transport transport;

  Future<InterestExpressionResult> expressInterest(
    InterestPacket interest,
  ) async {
    transport.send(interest);

    final completer = Completer<InterestExpressionResult>();

    Timer(const Duration(seconds: 4), () {
      if (completer.isCompleted) {
        return;
      }

      completer.complete(InterestTimedOut());
    });

    transport.asBroadcastStream().listen((event) {
      if (completer.isCompleted) {
        return;
      }

      // TODO: Match name of incoming packets with interest
      // TODO: Decide whether the pendingInterestTable is actually needed
      switch (event) {
        case DataPacket():
          completer.complete(DataReceived(event));
        case NackPacket():
          completer.complete(NackReceived(event));
      }
    });

    return completer.future;
  }

  void sendData(DataPacket dataPacket) {
    transport.send(dataPacket);
  }

  Future<void> shutdown() async {
    await transport.shutdown();
  }

  @override
  StreamSubscription<NdnPacket> listen(
    void Function(NdnPacket event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      transport.asBroadcastStream().listen(
            onData,
            onError: onError,
            onDone: onDone,
            cancelOnError: cancelOnError,
          );
}

enum Scope {
  local,
  nonLocal,
}

enum LinkType {
  pointToPoint,
  multiAccess,
  adHoc,
}

enum Persistency {
  onDemand,
  persistent,
  permanent,
}

enum FaceState {
  up,
  down,
  closing,
  failing,
  closed,
}
