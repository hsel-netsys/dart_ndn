// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../extensions/non_negative_integer.dart";
import "../tlv_elements/name/name.dart";
import "../tlv_elements/nfd_management/control_parameters.dart";
import "../tlv_elements/packet/interest_packet.dart";

abstract class CommandInterest {
  CommandInterest(
    this.managementModule,
    this.commandVerb, {
    this.commandPrefix = "/localhost/nfd",
    this.name,
    this.faceId,
    this.origin,
    this.cost,
    this.flags,
    this.expirationPeriod,
  });

  final String commandVerb;

  final String commandPrefix;

  final String managementModule;

  final Name? name;

  final NonNegativeInteger? faceId;

  final NonNegativeInteger? origin;

  final NonNegativeInteger? cost;

  final NonNegativeInteger? flags;

  final NonNegativeInteger? expirationPeriod;

  InterestPacket toInterestPacket() {
    final controlParameters = ControlParameters(
      name: name,
      faceId: faceId,
      origin: origin,
      cost: cost,
      flags: flags,
      expirationPeriod: expirationPeriod,
    ).asNameComponent();

    final nameComponents = [
      ...commandPrefix.toNameComponents(),
      ...managementModule.toNameComponents(),
      ...commandVerb.toNameComponents(),
      controlParameters,
    ];

    return InterestPacket.fromName(
      Name(nameComponents),
    );
  }
}

final class RegisterRouteCommand extends CommandInterest {
  RegisterRouteCommand(
    Name prefix, {
    super.faceId,
    super.origin,
    super.cost,
    super.flags,
    super.expirationPeriod,
  }) : super(
          "rib",
          "register",
          name: prefix,
        );
}
