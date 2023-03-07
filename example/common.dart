import "package:dart_ndn/dart_ndn.dart";

/// Face URI of the local NFD.
///
/// The examples in this folder use TCP for connecting to the NFD to be able to
/// monitor the exchanged packets with Wireshark.
/// If you pass no URI to [Consumer.create] or [Producer.create], the connection
/// will be established via a Unix socket with the default parameters.
final nfdFaceUri = Uri.parse("tcp4://localhost:6363");
