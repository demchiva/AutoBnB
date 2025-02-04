import 'package:autobnb/model/Review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import 'Database.dart';
import 'Navigation.dart';
import 'model/Car.dart';
import 'model/Owner.dart';
import 'model/Reservation.dart';

class LeaveReviewScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/leaveReview';
  const LeaveReviewScreen({Key? key}) : super(key: key);

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  Reservation reservation = Database.currentReservation!;
  Car car = Database.currentReservation!.car;
  Owner owner = Database.owners.firstWhere(
      (element) => Database.currentReservation!.car.ownerId == element.id);

  static const String DATE_FORMAT = 'dd/MM/yyyy';
  double _rating = 5;

  TextEditingController? _review;

  @override
  void initState() {
    _review = TextEditingController();
    super.initState();
  }

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
                  _buildText("Date"),
                  _buildValueText(
                      '${DateFormat(DATE_FORMAT).format(reservation.from)} - ${DateFormat(DATE_FORMAT).format(reservation.to)}')
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: _buildText("Rating"),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
              child: Text(
                "Select rating from 1 (worst) to 5 (best).",
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _rating = rating;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: _buildText("What was your experience like?"),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 10),
              child: Text(
                "Include information about the car, communication with the owner.",
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TextFormField(
                maxLines: 7,
                controller: _review,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButton(
                      "Submit",
                      null,
                      () {
                        reservation.review = _review!.text;
                        reservation.score = _rating;
                        reservation.state = ReservationState.reviewed;

                        Owner owner = Database.owners.firstWhere(
                            (element) => element.id == reservation.car.ownerId);
                        owner.reviews.add(
                          Review(
                            "assets/images/user.png",
                            Database.currentUser.firstName,
                            '${DateFormat('MMMM').format(DateTime(0, reservation.from.month))} ${reservation.from.year.toString()}',
                            _review!.text,
                            _rating,
                          ),
                        );

                        Navigation.me.pop(context);
                      },
                    ),
                  ],
                )),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            ),
          ],
        ),
      ),
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
}
