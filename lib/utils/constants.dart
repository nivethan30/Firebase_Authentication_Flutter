import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

/// Converts a Firestore [Timestamp] to a human-readable string of the form
/// "dd MMM, yyyy hh:mm a".
///
/// If [timestamp] is null, returns a hyphen.
///
String convertDateTime(Timestamp? timestamp) {
  if (timestamp == null) return "-";
  return DateFormat('dd MMM, yyyy hh:mm a').format(timestamp.toDate());
}
