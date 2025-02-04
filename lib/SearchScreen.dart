import 'package:autobnb/Database.dart';
import 'package:flutter/material.dart';

import 'Navigation.dart';
import 'model/Car.dart';
import 'model/CarFeature.dart';

class SearchScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/searchResults';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  late TextEditingController? _searchController;

  static List<Car> searchedCars = [];

  @override
  void initState() {
    // searchedCars.addAll(Database.cars);
    // SearchScreenState.searchedCars.sort((a, b) => b.score.compareTo(a.score));
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    Database.setToDefaultFilters();
    searchedCars.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          title: const Text("Search results"),
          foregroundColor: Color.fromARGB(255, 5, 5, 5),
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 10, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 200,
                    height: 50,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (String? value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length >= 3) {
                          setState(() {
                            Database.cars.forEach((element) {
                              if (element.title
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.description
                                      .toLowerCase()
                                      .contains(value.toLowerCase())) {
                                bool shouldAddCar = true;
                                if (Database.minPrice != 0 &&
                                    element.price < Database.minPrice) {
                                  shouldAddCar = false;
                                }

                                if (Database.maxPrice != 0 &&
                                    element.price > Database.maxPrice) {
                                  shouldAddCar = false;
                                }

                                if (Database.currentFeatures.isNotEmpty) {
                                  for (CarFeature currentFeature
                                      in Database.currentFeatures) {
                                    if (!element.features
                                        .contains(currentFeature.id)) {
                                      shouldAddCar = false;
                                    }
                                  }
                                }

                                if (shouldAddCar) {
                                  if (!SearchScreenState.searchedCars
                                      .contains(element)) {
                                    SearchScreenState.searchedCars.add(element);
                                  }
                                } else {
                                  SearchScreenState.searchedCars
                                      .remove(element);
                                }

                                if (Database.sort ==
                                    SingingCharacter.topRated) {
                                  SearchScreenState.searchedCars.sort(
                                      (a, b) => b.score.compareTo(a.score));
                                } else {
                                  SearchScreenState.searchedCars.sort(
                                      (a, b) => a.price.compareTo(b.price));
                                }
                              } else {
                                SearchScreenState.searchedCars.remove(element);
                              }
                            });
                          });
                        } else {
                          setState(() {
                            Database.cars.forEach((element) {
                              bool shouldAddCar = true;
                              if (Database.minPrice != 0 &&
                                  element.price < Database.minPrice) {
                                shouldAddCar = false;
                              }

                              if (Database.maxPrice != 0 &&
                                  element.price > Database.maxPrice) {
                                shouldAddCar = false;
                              }

                              if (Database.currentFeatures.isNotEmpty) {
                                for (CarFeature currentFeature
                                    in Database.currentFeatures) {
                                  if (!element.features
                                      .contains(currentFeature.id)) {
                                    shouldAddCar = false;
                                  }
                                }
                              }

                              if (shouldAddCar) {
                                if (!SearchScreenState.searchedCars
                                    .contains(element)) {
                                  SearchScreenState.searchedCars.add(element);
                                }
                              } else {
                                SearchScreenState.searchedCars.remove(element);
                              }

                              if (Database.sort == SingingCharacter.topRated) {
                                SearchScreenState.searchedCars
                                    .sort((a, b) => b.score.compareTo(a.score));
                              } else {
                                SearchScreenState.searchedCars
                                    .sort((a, b) => a.price.compareTo(b.price));
                              }
                            });
                          });
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                        hintText: "Brand or model",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side:
                            const BorderSide(width: 2.0, color: Colors.black26),
                        backgroundColor: const Color.fromARGB(10, 0, 0, 0),
                      ),
                      onPressed: () {
                        Navigation.me.filterFromSearchResults(context);
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 12),
                        child: Row(
                          children: const <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.search)),
                            Padding(padding: const EdgeInsets.all(3)),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Edit filters",
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
                  ),
                ],
              ),
            ),
            if (searchedCars.isNotEmpty)
              const Padding(padding: EdgeInsets.only(top: 20)),
            if (searchedCars.isNotEmpty)
              ...searchedCars.map((e) => _buildItem(context, e)),
            if (searchedCars.isEmpty)
              const Center(
                child: Text("Nothing found. Please use different filters."),
              ),
          ],
        ));
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
