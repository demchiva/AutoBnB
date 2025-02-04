import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Database.dart';
import 'Navigation.dart';
import 'model/Car.dart';
import 'model/Owner.dart';
import 'model/Reservation.dart';

class ReservationDetailScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/reservationDetail';

  const ReservationDetailScreen({Key? key}) : super(key: key);

  @override
  State<ReservationDetailScreen> createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  Reservation reservation = Database.currentReservation!;
  Car car = Database.currentReservation!.car;
  Owner owner = Database.owners.firstWhere(
      (element) => Database.currentReservation!.car.ownerId == element.id);

  static const String DATE_FORMAT = 'dd/MM/yyyy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(car.photoUrl),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 5, left: 20, right: 20),
              child: Text(
                car.title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.location,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Database.currentOwner = Database.owners.firstWhere(
                              (element) => car.ownerId == element.id);
                          Navigation.me.ownerDetail(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Offered by ${Database.owners.firstWhere((element) => car.ownerId == element.id).shortName}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Database.currentOwner = Database.owners
                          .firstWhere((element) => car.ownerId == element.id);
                      Navigation.me.ownerDetail(context);
                    },
                    child: CircleAvatar(
                      maxRadius: 40,
                      child: Image.asset(Database.owners
                          .firstWhere((element) => car.ownerId == element.id)
                          .photoPath),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 15,
                color: Colors.black45,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildText("Reservation status"),
                  _buildReservationStatusText(
                      reservation.state.text, reservation.state.color
                      /*style: const TextStyle(color: Colors.white),*/
                      ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildText("Start date"),
                  _buildValueText(
                      DateFormat(DATE_FORMAT).format(reservation.from)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildText("End date"),
                  _buildValueText(
                      DateFormat(DATE_FORMAT).format(reservation.to)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildText("Registration plate"),
                  _buildValueText(reservation.car.registrationPlate),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildText("Location"),
                  _buildValueText(
                      '${reservation.car.street}\n${reservation.car.location}'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Image.asset("assets/images/location.png"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildText("Owner's info"),
                  _buildValueText(
                      '${owner.fullName}\n${owner.street}\n${owner.shortLocation}\n${owner.phoneNumber}'),
                ],
              ),
            ),
            if (reservation.notes != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _buildText("Notes"),
              ),
            if (reservation.notes != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  reservation.notes!,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            if (reservation.review != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    _buildText("Your review"),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                    Text(reservation.score.toString()),
                  ],
                ),
              ),
            if (reservation.review != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  reservation.review!,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigationBarByState(),
    );
  }

  Widget _buildText(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Widget _buildValueText(String value) {
    return Text(
      value,
      textAlign: TextAlign.right,
      style: const TextStyle(
        color: Colors.black45,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildReservationStatusText(String value, Color underline) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 3, // space between underline and text
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: underline, // Underline colour
        width: 3.0, // Underline width
      ))),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.black45, // Text colour
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget? _buildNavigationBarByState() {
    switch (reservation.state) {
      case ReservationState.reviewed:
        return null; // TODO maybe edit review?
      case ReservationState.checkIn:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: SizedBox(
            height: 70,
            child: Center(
              child: _buildButton(
                "Check out",
                null,
                () async {
                  await showYNDialog(
                    message: "Confirm check-out?",
                    context: context,
                    onYes: () {
                      reservation.state = ReservationState.leaveReview;
                      Database.oldReservations.add(reservation);
                      Database.oldReservations
                          .sort((a, b) => b.from.compareTo(a.from));
                      Database.reservations.remove(reservation);
                      Navigation.me.reservations(context);
                    },
                  );
                },
              ),
            ),
          ),
        );
      case ReservationState.leaveReview:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: SizedBox(
            height: 70,
            child: Center(
              child: _buildButton(
                "Leave review",
                null,
                () {
                  Navigation.me
                      .leaveReview(context)
                      .then((value) => setState(() {}));
                },
              ),
            ),
          ),
        );
      case ReservationState.reserved:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: SizedBox(
            height: 70,
            child: Center(
              child: _buildButton(
                "Check in",
                null,
                () async {
                  await showYNDialog(
                    message: "Confirm check-in?",
                    context: context,
                    onYes: () {
                      reservation.state = ReservationState.checkIn;
                      Navigation.me.pop(context);
                      Navigation.me.reservations(context);
                    },
                  );
                },
              ),
            ),
          ),
        );
      case ReservationState.waiting:
      case ReservationState.confirmed:
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: SizedBox(
            height: 70,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton(
                    "Change reservation",
                    null,
                    () {
                      Navigation.me.editReservation(context);
                    },
                  ),
                  _buildButton(
                    "Cancel reservation",
                    Colors.red,
                    () async {
                      await showYNDialog(
                        message: "Are you sure to cancel reservation?",
                        context: context,
                        onYes: () {
                          reservation.state = ReservationState.canceled;
                          Database.oldReservations.add(reservation);
                          Database.oldReservations
                              .sort((a, b) => b.from.compareTo(a.from));
                          Database.reservations.remove(reservation);
                          Navigation.me.pop(context);
                          Navigation.me.reservations(context);
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      case ReservationState.canceled:
        return null;
    }
  }

  Widget _buildButton(String text, Color? color, VoidCallback? onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            color != null ? MaterialStateProperty.all<Color>(color) : null,
        minimumSize: MaterialStateProperty.all<Size>(const Size(150, 60)),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  static Future<void> showYNDialog({
    required final String message,
    required final BuildContext context,
    required final VoidCallback onYes,
    final VoidCallback? onNo,
  }) =>
      showDialog(
        context: context,
        builder: (final _) => AlertDialog(
          title: const Center(child: Text("Confirmation")),
          content: Text(message, textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onYes();
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (onNo != null) {
                  onNo();
                }
              },
              child: const Text("No"),
            ),
          ],
        ),
      );
}
