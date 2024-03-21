// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:async";

import "extensions/non_negative_integer.dart";
import "face.dart";
import "nfd_management/nfd_controller.dart";
import "signer.dart";
import "tlv_elements/name/name.dart";
import "tlv_elements/packet/data_packet.dart";
import "tlv_elements/packet/interest_packet.dart";
import "tlv_elements/packet/ndn_packet.dart";
import "transport.dart";

class Producer extends Stream<InterestPacket> {
  Producer(
    this._face, {
    Signer? signer,
  })  : _nfdController = NfdController(
          _face,
          signer: signer,
        ),
        _interestPacketStream =
            _filterInterestPackets(_face.asBroadcastStream());

  // TODO: Refactor
  static Future<Producer> create([Uri? uri]) async {
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
    final consumer = Producer(face).._hasInternalFace = true;

    return consumer;
  }

  Future<void> registerPrefix(
    Name prefix, {
    NonNegativeInteger? faceId,
    NonNegativeInteger? origin,
    NonNegativeInteger? cost,
    NonNegativeInteger? flags,
    NonNegativeInteger? expirationPeriod,
  }) async {
    await _nfdController.registerRoute(
      prefix,
      faceId: faceId,
      origin: origin,
      cost: cost,
      flags: flags,
      expirationPeriod: expirationPeriod,
    );
  }

  Future<void> satifisfyInterest(
    InterestPacket interestPacket,
    List<int>? content,
  ) async {
    final dataPacket = DataPacket(
      interestPacket.name,
      content: content,
    );

    _face.sendData(dataPacket);
  }

  @override
  StreamSubscription<InterestPacket> listen(
    void Function(InterestPacket event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      _interestPacketStream.asBroadcastStream().listen(
            onData,
            onError: onError,
            onDone: onDone,
            cancelOnError: cancelOnError,
          );

  static Stream<InterestPacket> _filterInterestPackets(
    Stream<NdnPacket> stream,
  ) async* {
    await for (final ndnPacket in stream) {
      if (ndnPacket is InterestPacket) {
        yield ndnPacket;
      }
    }
  }

  Future<void> shutdown() async {
    if (_hasInternalFace) {
      await _face.shutdown();
    }
  }

  final Stream<InterestPacket> _interestPacketStream;

  final Face _face;

  final NfdController _nfdController;

  bool _hasInternalFace = false;

  bool get hasInternalFace => _hasInternalFace;
}
