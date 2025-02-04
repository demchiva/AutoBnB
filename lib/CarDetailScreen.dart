import 'package:autobnb/model/CarFeature.dart';
import 'package:flutter/material.dart';

import 'Database.dart';
import 'Navigation.dart';
import 'model/Car.dart';

class CarDetailScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/carDetail';

  CarDetailScreen({Key? key}) : super(key: key);

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final Car car = Database.currentCar!;

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
            buildLikeCarComponent(car, 35),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: car.features.length,
                  itemBuilder: (context, index) {
                    CarFeature feature = Database.carsFeatures.firstWhere(
                        (element) => element.id == car.features[index]);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              feature.icon,
                              size: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                feature.description,
                                maxLines: 2,
                                textWidthBasis: TextWidthBasis.longestLine,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                car.description,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        //margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(width: 1.0, color: Colors.grey))),
        child: SizedBox(
            height: 90,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListTile(
                title: Text(
                  car.priceText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    Text(car.score.toString()),
                  ],
                ),
                trailing: SizedBox(
                  width: 150,
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
                      onPressed: () {
                        Navigation.me.createReservation(context);
                      },
                      child: const Text(
                        "Reserve",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget buildLikeCarComponent(Car car, double iconSize) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Image.asset(car.photoUrl),
        Padding(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                car.liked = !car.liked;
              });
            },
            child: Icon(
              Icons.favorite,
              color: car.liked ? Colors.red : Colors.white54,
              size: iconSize,
            ),
          ),
        ),
      ],
    );
  }
}
