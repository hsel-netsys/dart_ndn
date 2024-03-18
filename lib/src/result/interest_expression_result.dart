// Copyright 2024 The dart_ndn Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
//
// SPDX-License-Identifier: BSD-3-Clause

import "../tlv_elements/packet/data_packet.dart";
import "../tlv_elements/packet/nack_packet.dart";

sealed class InterestExpressionResult {}

final class DataReceived extends InterestExpressionResult {
  DataReceived(this.data);

  final DataPacket data;
}

final class NackReceived extends InterestExpressionResult {
  NackReceived(this.nackPacket);

  final NackPacket nackPacket;
}

final class InterestTimedOut extends InterestExpressionResult {}
