[![pub package](https://img.shields.io/pub/v/dart_ndn.svg)](https://pub.dev/packages/dart_ndn)
[![Build](https://github.com/hsel-netsys/dart_ndn/actions/workflows/ci.yml/badge.svg)](https://github.com/hsel-netsys/dart_ndn/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/hsel-netsys/dart_ndn/branch/main/graph/badge.svg?token=76OBNOVL60)](https://codecov.io/gh/hsel-netsys/dart_ndn)
[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)

# Named Data Networking (NDN) in Dart

`dart_ndn` is a basic Named Data Networking (NDN) implementation that can be
used in Dart and Flutter projects.
It follows Version 0.3 of the [NDN Packet Specification], and implements the
link protocol [NDNLPv2] as well as the [NFD Management Protocol] to be able
to interact with an NDN Forwarding Daemon (NFD).

[NDN Packet Specification]: https://docs.named-data.net/NDN-packet-spec/0.3/
[NDNLPv2]: https://redmine.named-data.net/projects/nfd/wiki/NDNLPv2
[NFD Management Protocol]: https://redmine.named-data.net/projects/nfd/wiki/Management

## Features

The main features include support for Faces based on Unix and TCP sockets
as well as a Consumer and Producer implementation.

## Getting started

In order to use the package, you should have a local NFD installed.
On unix-like systems, you can follow these [installation instructions].
On Android, you can install an NFD port from the Google PlayStore.
<!-- TODO: What about iOS? -->

[installation instructions]: https://docs.named-data.net/NFD/current/INSTALL.html
[Google PlayStore]: https://play.google.com/store/apps/details?id=net.named_data.nfd

Having an NFD installed, you can then interact with it using Unix or TCP
sockets.
In theory, however, you could also have an NFD running on a different host
and connect via TCP, which might be useful for some testing scenarios.

## Usage

A minimal example with a consumer that connects to an NFD via a Unix socket can
be found below.

```dart
import "package:convert/convert.dart";
import "package:dart_ndn/dart_ndn.dart";

Future<void> main() async {
  final consumer = await Consumer.create();

  final result = await consumer.expressInterest(Name.fromString("/foo/bar"));

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
```

Additional examples can be found in the `example` directory.

## License

`dart_ndn` is licensed under the 3-Clause BSD License.
See the `LICENSE` file for more information.

    SPDX-License-Identifier: BSD-3-Clause
