// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:async";
import "dart:io";

import "tlv_elements/packet/ndn_packet.dart";

sealed class Transport extends Stream<NdnPacket> {
  void send(NdnPacket block);

  Future<void> shutdown();
}

final class TcpTransport extends Transport {
  TcpTransport(this._socket)
      : rawSocketEventStream = _socket.asBroadcastStream();

  static Future<TcpTransport> create(Uri uri) async {
    final socket = await RawSocket.connect(uri.host, uri.port);

    return TcpTransport(socket);
  }

  final RawSocket _socket;

  final Stream<RawSocketEvent> rawSocketEventStream;

  @override
  void send(NdnPacket packet) {
    final encodedPacket = packet.encode();

    _socket.write(encodedPacket.toList());
  }

  @override
  StreamSubscription<NdnPacket> listen(
    void Function(NdnPacket event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final streamController = StreamController<NdnPacket>();

    rawSocketEventStream.listen(
      (event) {
        switch (event) {
          case RawSocketEvent.read:
            final data = _socket.read();

            final packet = NdnPacket.tryParse(data ?? []);

            if (packet != null) {
              streamController.add(packet);
            }
          default:
            return;
        }
      },
      onDone: () async => await streamController.close(),
      onError: (error) async => await streamController.close(),
      cancelOnError: cancelOnError,
    );

    return streamController.stream.asBroadcastStream().listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        );
  }

  @override
  Future<void> shutdown() async {
    await _socket.close();
  }
}

final class UnixTransport extends Transport {
  UnixTransport(this._socket)
      : rawSocketEventStream = _socket.asBroadcastStream();

  static Future<UnixTransport> create([String? socketPath]) async {
    final host = InternetAddress(
      socketPath ?? defaultSocketLocation,
      type: InternetAddressType.unix,
    );
    final socket = await RawSocket.connect(host, 0);

    return UnixTransport(socket);
  }

  final RawSocket _socket;

  final Stream<RawSocketEvent> rawSocketEventStream;

  @override
  void send(NdnPacket packet) {
    final encodedPacket = packet.encode();

    _socket.write(encodedPacket.toList());
  }

  static String get defaultSocketLocation {
    if (Platform.isLinux) {
      return "/run/nfd/nfd.sock";
    }

    return "/var/run/nfd.sock";
  }

  @override
  StreamSubscription<NdnPacket> listen(
    void Function(NdnPacket event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    final streamController = StreamController<NdnPacket>();

    rawSocketEventStream.listen(
      (event) {
        switch (event) {
          case RawSocketEvent.read:
            final data = _socket.read();

            final packet = NdnPacket.tryParse(data ?? []);

            if (packet != null) {
              streamController.add(packet);
            }
          default:
            return;
        }
      },
      onDone: streamController.close,
      onError: (error) => streamController.close(),
      cancelOnError: cancelOnError,
    );

    return streamController.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  Future<void> shutdown() async {
    await _socket.close();
  }
}
