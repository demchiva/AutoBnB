import 'package:autobnb/Database.dart';
import 'package:autobnb/model/CarFeature.dart';
import 'package:flutter/material.dart';

import 'Navigation.dart';
import 'SearchScreen.dart';
import 'model/Car.dart';

class FilterScreen extends StatefulWidget {
  static const String ROUTE_NAME = '/filter';

  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  SingingCharacter? _character;
  TextEditingController? _minPrice;
  TextEditingController? _maxPrice;

  List<CarFeature>? features;

  @override
  void initState() {
    features = [];
    features!.addAll(Database.currentFeatures);
    _character = Database.sort;
    _minPrice = TextEditingController(
        text: Database.minPrice == 0 ? null : Database.maxPrice.toString());
    _maxPrice = TextEditingController(
        text: Database.maxPrice == 0 ? null : Database.maxPrice.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Filters",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          children: [
            const Text(
              "Sort by",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  _character = SingingCharacter.topRated;
                });
              },
              title: const Text('Top rated'),
              trailing: Radio<SingingCharacter>(
                value: SingingCharacter.topRated,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  _character = SingingCharacter.cheaper;
                });
              },
              title: const Text('Price'),
              trailing: Radio<SingingCharacter>(
                value: SingingCharacter.cheaper,
                groupValue: _character,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Price range",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        width: 100,
                        height: 40,
                        child: TextFormField(
                          controller: _minPrice,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: 5, left: 10),
                            border: OutlineInputBorder(),
                            hintText: "Min",
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      "-",
                      style: TextStyle(fontSize: 21),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: 100,
                        height: 40,
                        child: TextFormField(
                          controller: _maxPrice,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(top: 5, left: 10),
                            border: OutlineInputBorder(),
                            hintText: "Max",
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Car features",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...Database.carsFeatures.map((e) => _buildItem(e)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: SizedBox(
          height: 100,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildButton(
                  "Apply filters",
                  null,
                  () {
                    Database.setToDefaultFilters();
                    Database.minPrice = _minPrice!.text.isNotEmpty
                        ? int.parse(_minPrice!.text)
                        : 0;
                    Database.maxPrice = _maxPrice!.text.isNotEmpty
                        ? int.parse(_maxPrice!.text)
                        : 0;
                    Database.sort = _character!;
                    Database.currentFeatures.addAll(features!);
                    SearchScreenState.searchedCars = [];

                    Database.cars.forEach((Car element) {
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
                          if (!element.features.contains(currentFeature.id)) {
                            shouldAddCar = false;
                          }
                        }
                      }

                      if (shouldAddCar) {
                        if (!SearchScreenState.searchedCars.contains(element)) {
                          SearchScreenState.searchedCars.add(element);
                        }
                      } else {
                        SearchScreenState.searchedCars.remove(element);
                      }
                    });

                    if (Database.sort == SingingCharacter.topRated) {
                      SearchScreenState.searchedCars
                          .sort((a, b) => b.score.compareTo(a.score));
                    } else {
                      SearchScreenState.searchedCars
                          .sort((a, b) => a.price.compareTo(b.price));
                    }

                    Navigation.me.searchResultsFromFilters(context);
                  },
                ),
                // _buildButton(
                //   "Cancel filters",
                //   Colors.red,
                //   () {
                //     Database.setToDefaultFilters();
                //     SearchScreenState.searchedCars.addAll(Database.cars);
                //     SearchScreenState.searchedCars
                //         .sort((a, b) => b.score.compareTo(a.score));
                //     Navigation.me.pop(context);
                //   },
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color? color, VoidCallback? onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            color != null ? MaterialStateProperty.all<Color>(color) : null,
        minimumSize: MaterialStateProperty.all<Size>(const Size(160, 50)),
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

  Widget _buildItem(CarFeature feature) {
    return CheckboxListTile(
      value: features!.contains(feature),
      title: Text(feature.description),
      onChanged: (bool? value) {
        setState(() {
          if (value != null && value) {
            features!.add(feature);
          } else {
            features!.remove(feature);
          }
        });
      },
    );
  }
}
