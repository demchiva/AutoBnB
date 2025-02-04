import 'package:autobnb/Database.dart';
import 'package:autobnb/model/User.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController? _firstName;
  TextEditingController? _lastName;
  TextEditingController? _birthDay;
  TextEditingController? _email;
  TextEditingController? _phoneNumber;
  TextEditingController? _creditCard;

  DateTime? _pickedBirthDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  User user = Database.currentUser;

  @override
  void initState() {
    _firstName = TextEditingController(text: user.firstName);
    _lastName = TextEditingController(text: user.lastName);
    _birthDay = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(user.birthDate));
    _email = TextEditingController(text: user.email);
    _phoneNumber = TextEditingController(text: user.phoneNumber);
    _creditCard = TextEditingController(text: user.creditCard);
    _pickedBirthDate = user.birthDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: CustomPaint(
                        painter: CirclePainter(),
                      )),
                  const Padding(
                    padding: EdgeInsets.only(top: 65),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "My Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 55,
                    right: 50,
                    top: 111,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 240, 240, 240),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 135,
                    right: 130,
                    top: 113,
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      child: Image.asset('assets/images/user.png'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "4.1",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 30, bottom: 10),
              child: TextFormField(
                controller: _firstName,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "The field is mandatory";
                  }
                },
                decoration: const InputDecoration(
                  labelText: "First name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _lastName,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "The field is mandatory";
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Last name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildDatePicker(
                  context, _birthDay, "Birthday", user.birthDate),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _email,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "The field is mandatory";
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _phoneNumber,
                keyboardType: TextInputType.phone,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "The field is mandatory";
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Phone number",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _creditCard,
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "The field is mandatory";
                  }

                  if (value.replaceAll(" ", "").length > 16) {
                    return "Card number is too long";
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Credit card",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: _buildButton(
          "Save changes",
          null,
          () async {
            if (_formKey.currentState!.validate()) {
              await showYNDialog(
                message: "Are you sure you want to save changes?",
                context: context,
                onYes: () async {
                  user.firstName = _firstName!.text;
                  user.lastName = _lastName!.text;
                  user.birthDate = _pickedBirthDate!;
                  user.email = _email!.text;
                  user.phoneNumber = _phoneNumber!.text;
                  user.creditCard = _creditCard!.text;
                  await showInfoDialog(
                      "Success", "Changes saved successfully", context);
                },
              );
              if (mounted) {
                FocusScope.of(context).requestFocus(FocusNode());
              }
            }
          },
        ),
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
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildDatePicker(
    final BuildContext context,
    final TextEditingController? controller,
    final String label,
    final DateTime initDate,
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

                DateTime now =
                    DateTime.now().subtract(const Duration(days: 365 * 18));
                if (_pickedBirthDate != null &&
                    _pickedBirthDate ==
                        DateTime(now.year, now.month, now.day)) {
                  return "You must be at leas 18 years old";
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _onDatePickerTap(controller, initDate),
            ),
          ],
        ),
      );

  void _onDatePickerTap(
      final TextEditingController? controller, DateTime initDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );

    setState(() {
      _pickedBirthDate = picked;
      controller!.text = picked != null
          ? DateFormat('dd/MM/yyyy').format(picked)
          : controller.text;
    });
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

  static Future<void> showInfoDialog(
    final String title,
    final String message,
    final BuildContext context,
  ) =>
      showDialog(
        context: context,
        builder: (final _) => AlertDialog(
          title: Center(child: Text(title)),
          content: Text(message, textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Ok"),
            ),
          ],
        ),
      );
}

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.lightBlue
    ..strokeWidth = 2
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    double radius = 600;
    canvas.drawCircle(Offset(0, -radius + 155), radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
