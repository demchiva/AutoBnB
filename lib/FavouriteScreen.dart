import 'package:autobnb/model/Car.dart';
import 'package:flutter/material.dart';

import 'Database.dart';
import 'Navigation.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    List<Car> favourites =
        Database.cars.where((element) => element.liked).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                "Favourites",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        favourites.isEmpty
            ? const Center(
                child: Text(
                "You do not have any liked cars yet :(",
                style: TextStyle(fontSize: 18),
              ))
            : Expanded(
                child: ListView(
                  children: [
                    ...favourites.map((e) => _buildItem(context, e)),
                  ],
                ),
              ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, Car car) {
    return GestureDetector(
      onTap: () {
        Database.currentCar = car;
        Navigation.me.carDetail(context).then((value) => setState(() {}));
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
                  child: buildLikeCarComponent(car, 35),
                ),
                ListTile(
                  title: Text(car.title),
                  subtitle: Text(car.priceText),
                  trailing: SizedBox(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          car.score.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 30,
                        ),
                      ],
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
