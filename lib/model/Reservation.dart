import 'package:flutter/material.dart';

import 'Car.dart';

class Reservation {
  Car car;
  DateTime from;
  DateTime to;
  ReservationState state;
  String? notes;
  String? userNotes;
  String? review;
  double? score;

  Reservation(
    this.car,
    this.from,
    this.to,
    this.state,
    this.notes,
    this.userNotes,
  );

  Reservation.withReview(
    this.car,
    this.from,
    this.to,
    this.state,
    this.notes,
    this.userNotes,
    this.review,
    this.score,
  );
}

enum ReservationState {
  checkIn("CHECKED IN", Colors.cyan),
  reserved("CHECK-IN READY", Colors.deepPurpleAccent),
  confirmed("CONFIRMED", Colors.green),
  waiting('PENDING', Colors.orange),

  canceled('CANCELED', Colors.red),
  reviewed("COMPLETED", Color.fromARGB(255, 20, 145, 3)),
  leaveReview("NOT REVIEWED", Color.fromARGB(255, 177, 196, 8));

  final String text;
  final Color color;

  const ReservationState(this.text, this.color);
}
