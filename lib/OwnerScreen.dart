import 'package:autobnb/model/Owner.dart';
import 'package:autobnb/model/Review.dart';
import 'package:flutter/material.dart';

import 'Database.dart';
import 'Navigation.dart';
import 'model/Car.dart';

class OwnerScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/ownerDetail';

  OwnerScreen({Key? key}) : super(key: key);

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  late Owner owner;
  late List<Car> ownerCars;

  @override
  void initState() {
    owner = Database.currentOwner!;
    ownerCars =
        Database.cars.where((element) => element.ownerId == owner.id).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  owner.photoPath,
                  width: 100,
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    owner.shortName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Text(owner.description),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              height: 15,
              color: Colors.black45,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      "RENTING SINCE",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(owner.yearRatingSince.toString())
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "RATING",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(owner.rating.toString()),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      "LOCATION",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(owner.shortLocation),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Divider(
              height: 15,
              color: Colors.black45,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "Cars",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                padding: const EdgeInsets.all(5),
                scrollDirection: Axis.horizontal,
                itemCount: ownerCars.length,
                itemBuilder: (context, index) =>
                    _buildItemCard(context, index, ownerCars),
              ),
            ),
          ),
          if (owner.reviews.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Text(
                "Reviews",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              children: owner.reviews.map((e) => _buildReview(e)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildReview(Review review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(review.name),
              leading: Image.asset(review.photoUrl),
              subtitle: Text(review.date),
              trailing: SizedBox(
                width: 50,
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    Text(review.score.toString())
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(review.comment),
            ),
          ],
        ),
      ),
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
