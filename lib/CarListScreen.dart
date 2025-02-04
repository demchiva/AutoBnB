import 'package:autobnb/Database.dart';
import 'package:flutter/material.dart';

import 'Navigation.dart';
import 'model/Car.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({Key? key}) : super(key: key);

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
      children: [
        _buildTopBar(),
        _buildAdvertisement("The most popular", Icons.people, Database.cars),
        _buildAdvertisement("Ecology", Icons.eco, Database.cars),
        _buildAdvertisement("Best price", Icons.price_check, Database.cars),
        _buildAdvertisement("Near you", Icons.near_me, Database.cars),
      ],
    ));
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "AutoBnB 🚗",
            style: TextStyle(
              color: Color.fromARGB(255, 8, 108, 190),
              fontSize: 28,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Color.fromARGB(255, 9, 59, 145),
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                  width: 2.0, color: Color.fromARGB(159, 255, 255, 255)),
              backgroundColor: Color.fromARGB(237, 166, 216, 255),
            ),
            onPressed: () {
              Navigation.me.filter(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 10, right: 10),
              child: Row(
                children: const <Widget>[
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.search)),
                  Padding(padding: const EdgeInsets.all(3)),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Find a car",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 24, 59),
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertisement(
      String title, IconData iconData, List<Car> carsToAdvertise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Icon(iconData)
              ],
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(5),
            itemCount: carsToAdvertise.length,
            itemBuilder: (BuildContext context, int index) =>
                _buildItemCard(context, index, carsToAdvertise),
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(BuildContext context, int index, List<Car> cars) {
    final Car car = cars[index];
    return GestureDetector(
      onTap: () {
        Database.currentCar = car;
        Navigation.me.carDetail(context).then((value) => setState(() {}));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 5,
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: buildLikeCarComponent(car, 20),
              ),
              ListTile(
                title: Text(car.title),
                subtitle: Text(car.priceText),
                trailing: SizedBox(
                  width: 43,
                  child: Row(
                    children: [
                      Text(
                        car.score.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
                dense: true,
              )
            ],
          ),
        ),
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
