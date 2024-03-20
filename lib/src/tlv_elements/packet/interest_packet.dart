// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "package:convert/convert.dart";

import "../../extensions/bytes_encoding.dart";
import "../../result/result.dart";
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

  // TODO: Improve error handling
  static Result<InterestPacket> fromValue(List<int> value) {
    final tlvElements = value.toTvlElements();

    final nameComponents = <NameComponent>[];

    for (final tlvElement in tlvElements) {
      switch (tlvElement) {
        case Success<NameComponent>(:final tlvElement):
          nameComponents.add(tlvElement);
        case Fail(:final exception):
          // TODO: Deal with critical fails
          return Fail(exception);

        default:
          continue;
      }
    }

    // TODO: Also deal with other TlvElements

    final result = InterestPacket.fromName(Name(nameComponents));

    return Success(result);
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
      encodedValues.addAll(const CanBePrefix().encode());
    }

    if (mustBeFresh) {
      encodedValues.addAll(const MustBeFresh().encode());
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

    // TODO: Deal with other namecomponents
    for (final component in components) {
      result.add(GenericNameComponent(percent.decode(component)));
    }

    return result;
  }
}

extension type RecordId(int id) {}
