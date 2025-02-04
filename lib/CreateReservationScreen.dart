import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Database.dart';
import 'Navigation.dart';
import 'model/Car.dart';
import 'model/Reservation.dart';

class CreateReservationScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/reservation-create';

  CreateReservationScreen({Key? key}) : super(key: key);

  @override
  State<CreateReservationScreen> createState() =>
      _CreateReservationScreenState();
}

class _CreateReservationScreenState extends State<CreateReservationScreen> {
  final Car car = Database.currentCar!;

  static const String DATE_FORMAT = 'dd/MM/yyyy';

  DateTime? _pickedDateFrom;
  DateTime? _pickedDateTo;

  TextEditingController? _dateFrom;
  TextEditingController? _dateTo;
  TextEditingController? _comment;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _dateFrom = TextEditingController();
    _dateTo = TextEditingController();
    _comment = TextEditingController();
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
        child: Form(
          key: _formKey,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Reservation",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: _buildDatePicker(
                  context,
                  _dateFrom,
                  setPickedDateFrom,
                  "First day",
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: _buildDatePicker(
                  context,
                  _dateTo,
                  setPickedDateTo,
                  "Last day",
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text("Message to owner"),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: TextFormField(
                  maxLines: 8,
                  controller: _comment,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 1.0, color: Colors.grey))),
        child: SizedBox(
            height: 90,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListTile(
                title: Text(
                    'Total: ${_pickedDateTo != null && _pickedDateFrom != null && (_pickedDateTo!.isAfter(_pickedDateFrom!) || _pickedDateTo!.isAtSameMomentAs(_pickedDateFrom!)) ? car.price * (_pickedDateTo!.difference(_pickedDateFrom!).inDays + 1) : 0} Kč',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
                trailing: SizedBox(
                  width: 180,
                  height: 70,
                  child: Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(200, 70)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Reservation? reservation;
                          await showYNDialog(
                            message: "Are you sure you want to book this car?",
                            context: context,
                            onYes: () {
                              reservation = Reservation(
                                car,
                                _pickedDateFrom!,
                                _pickedDateTo!,
                                ReservationState.waiting,
                                null,
                                _comment?.text,
                              );

                              Database.reservations.add(reservation!);
                              Database.reservations
                                  .sort((a, b) => b.from.compareTo(a.from));
                              Navigation.me.reservations(context);
                            },
                          );

                          if (reservation != null) {
                            // Mock Owner interaction
                            Future.delayed(const Duration(seconds: 2)).then(
                                (value) =>
                                    changeStateToConfirmed(reservation!));
                            Future.delayed(const Duration(seconds: 120)).then(
                                (value) => changeStateToReserved(reservation!));
                          }
                        }
                      },
                      child: const Text(
                        "Request reservation",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildDatePicker(
    final BuildContext context,
    final TextEditingController? controller,
    final Function(DateTime?) setDate,
    final String label,
  ) =>
      Container(
        // width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          // color: Colors.green,
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(),
                labelText: label,
              ),
              validator: (final String? value) {
                if (value == null || value.isEmpty) {
                  return "The field is mandatory";
                }

                if (controller == _dateTo &&
                    _pickedDateTo != null &&
                    _pickedDateFrom != null &&
                    _pickedDateTo!.isBefore(_pickedDateFrom!)) {
                  return "Date to must be after date from";
                }

                DateTime now = DateTime.now();
                if (_pickedDateFrom != null &&
                    _pickedDateFrom == DateTime(now.year, now.month, now.day)) {
                  return "Date must be after today";
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _onDatePickerTap(controller, setDate),
            ),
          ],
        ),
      );

  void _onDatePickerTap(
    final TextEditingController? controller,
    final Function(DateTime?) setDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    setState(() {
      setDate(picked);
      controller!.text = picked != null
          ? DateFormat(DATE_FORMAT).format(picked)
          : controller.text;
    });
  }

  void setPickedDateTo(final DateTime? value) {
    _pickedDateTo = value;
  }

  void setPickedDateFrom(final DateTime? value) {
    _pickedDateFrom = value;
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
          title: const Text("Confirmation"),
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

  void changeStateToConfirmed(Reservation reservation) {
    if (reservation.state == ReservationState.waiting) {
      reservation.state = ReservationState.confirmed;
      reservation.notes = "Meet me at 8:30 near the car, I will give you "
          "everything you need. If you prefer a different "
          "time, call me or text me on WhatsApp.";
    }
  }

  void changeStateToReserved(Reservation reservation) {
    if (reservation.state == ReservationState.confirmed) {
      reservation.state = ReservationState.reserved;
    }
  }
}
