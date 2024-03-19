// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "dart:convert";

import "../../extensions/bytes_encoding.dart";
import "../name/name.dart";
import "../name/name_component.dart";
import "../nonce.dart";
import "../tlv_type.dart";
import "data_packet.dart";
import "ndn_packet.dart";

final class InterestPacket extends NdnPacket {
  InterestPacket({
    required String name,
    this.canBePrefix = false,
    this.mustBeFresh = false,
    bool generateNonce = true,
    this.forwardingHint,
    this.lifetime,
    this.hopLimit,
  })  : name = Name.fromString(name),
        nonce = generateNonce ? Nonce() : null;

  InterestPacket.fromName(
    this.name, {
    this.canBePrefix = false,
    this.mustBeFresh = false,
    bool generateNonce = true,
    this.forwardingHint,
    this.lifetime,
    this.hopLimit,
  }) : nonce = generateNonce ? Nonce() : null;

// TODO: Add error handling
  factory InterestPacket.fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    final nameComponents = <NameComponent>[];

    for (final tlvElement in tlvElements) {
      switch (tlvElement.type) {
        case 8:
          nameComponents
              .add(GenericNameComponent(utf8.decode(tlvElement.encodedValue)));
      }
    }

    return InterestPacket.fromName(Name(nameComponents));
  }

  final Name name;

  final bool canBePrefix;

  final bool mustBeFresh;

  final ForwardingHint? forwardingHint;

  final Nonce? nonce;

  final Duration? lifetime;

  final int? hopLimit;

  final bool isSigned = false;

  // final SignatureInfo? signatureInfo;

  Uri toUri() {
    return Uri();
  }

  bool matchesData(DataPacket data) {
    return true;
  }

  void refreshNonce() {}

  @override
  TlvType get tlvType => TlvType.interest;

  @override
  // TODO: Check if this can be made more efficient
  int get length => encodedValue.length;

  @override
  List<int> get encodedValue {
    final encodedValues = name.encode().toList();

    if (canBePrefix) {
      encodedValues.addAll(CanBePrefix().encode());
    }

    if (mustBeFresh) {
      encodedValues.addAll(MustBeFresh().encode());
    }

    final forwardingHint = this.forwardingHint;
    if (forwardingHint != null) {
      encodedValues.addAll(forwardingHint.encode());
    }

    final nonce = this.nonce;
    if (nonce != null) {
      encodedValues.addAll(nonce.encode());
    }

    final lifetime = this.lifetime;
    if (lifetime != null) {
      encodedValues.addAll(InterestLifetime(lifetime).encode());
    }

    final hopLimit = this.hopLimit;
    if (hopLimit != null) {
      encodedValues.addAll(HopLimit(hopLimit).encode());
    }

    return encodedValues;
  }
}

// TODO: Could also be an extension type instead
extension NameComponentExtension on String {
  List<NameComponent> toNameComponents() {
    var components = split("/");

    if (components.firstOrNull?.isEmpty ?? false) {
      components = components.sublist(1);
    }

    final result = <NameComponent>[];

    for (final component in components) {
      result.add(GenericNameComponent(component));
    }

    return result;
  }
}

class SignatureInfo {}

extension type RecordId(int id) {}
