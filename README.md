# Named Data Networking (NDN) in Dart

`dart_ndn` is a basic Named Data Networking (NDN) implementation that can be
used in Dart and Flutter projects.
It follows Version 0.3 of the [NDN Packet Specification], and implements the
link protocol [NDNLPv2] as well as the [NFD Management Protocol] and to be able
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
In theory, however, you could also have an NFD running on a different machine
and then connect via TCP, which might be useful for some testing scenarios.

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

## Additional information

<!-- TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more. -->

## License

`dart_ndn` is licensed under the 3-Clause BSD License.
See the `LICENSE` file for more information.

    SPDX-License-Identifier: BSD-3-Clause
