import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Database.dart';
import 'Navigation.dart';
import 'model/Car.dart';
import 'model/Reservation.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  static const String DATE_FORMAT = 'dd/MM/yyyy';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              "Reservations",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (Database.reservations.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "Upcoming",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ...Database.reservations.map((e) => _buildItem(context, e)),
          if (Database.oldReservations.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "Previous reservations",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ...Database.oldReservations.map((e) => _buildItem(context, e)),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, Reservation reservation) {
    Car car = reservation.car;
    return GestureDetector(
      onTap: () {
        Database.currentReservation = reservation;
        Navigation.me
            .reservationDetail(context)
            .then((value) => setState(() {}));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 5,
          child: SizedBox(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  child: Image.asset(car.photoUrl),
                ),
                ListTile(
                  title: Text(car.title),
                  subtitle: Text(
                      '${DateFormat(DATE_FORMAT).format(reservation.from)} - ${DateFormat(DATE_FORMAT).format(reservation.to)}'),
                  trailing: Container(
                    color: reservation.state.color,
                    width: 120,
                    height: 30,
                    child: Center(
                      child: Text(
                        reservation.state.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
