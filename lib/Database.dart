import 'package:autobnb/model/CarFeature.dart';
import 'package:autobnb/model/User.dart';
import 'package:flutter/material.dart';

import 'model/Car.dart';
import 'model/Owner.dart';
import 'model/Reservation.dart';
import 'model/Review.dart';

class Database {
  static Car? currentCar;
  static Owner? currentOwner;
  static Reservation? currentReservation;

  static List<Car> cars = [
    Car(
      1,
      'assets/images/cars/passat.jpg',
      'Volkswagen Passat 2018',
      'Praha 8 - Karlin',
      'Krizikova 23',
      2,
      [1, 2, 3],
      "Nabízíme pronájem prémiového modelu VW Passat. "
          "Přistavení na Terminálu Letiště Václava Havla Praha zajistí naše autopůjčovna nonstop.",
      1400,
      4.3,
      "AA1 5889",
      false,
    ),
    Car(
      2,
      'assets/images/cars/mercedes.jpg',
      'Mercedes-Benz GT Roadster',
      'Praha 8 - Karlin',
      'Krizikova 23',
      2,
      [1, 4, 5],
      "Cerná Mythos metalíza, černá kůže Nappa s červeným prošíváním, 20 černá "
          "litá RS kola, paket černé optiky exteriéru, černá maska a kruhy AUDI, "
          "červený designový RS paket interiéru, červeně lakované brzdové třmeny, "
          "zadní černý RS spoiler, HD Matrix LED světla, adaptivní sportovní podvozek "
          "AUDI Magnetic ride, tempomat, parkovací senzory s kamerou vzadu, bezklíčkové, "
          "nastavení jízdních režimů vč. RS módu, sportovní brzdy a výfuky, omezovač na 280 km/h, "
          "otevírání garážových vrat, zaclonitelná, sklopná.\n\n Vyhřívaná zrcátka, RS sportovní elektrická sedadla, "
          "vyhřívání předních sedadel, navigace MMI plus, Bang & Olufsen sound system, smartphone rozhraní, "
          "phone box s bezdrátovým dobíjením, RS sportovní multifunkční volant "
          "s pádly řazení v kombinaci alcantara / kůže, paket odkládacích prostor, "
          "isofixy, vnitřní výplně dveří v alcantaře, karbon dekorace interiéru, "
          "černý látkový strop, kontrastní červené prošívání interiéru, "
          "červeně lakované bočnice sedadel a středová konzole.",
      2300,
      4.1,
      "AH 9932 BC",
      true,
    ),
    Car(
      3,
      'assets/images/cars/volvo-s60.webp',
      'Volvo S60',
      'Praha 6 - Dejvice',
      'Kozlovska 3',
      3,
      [2, 3],
      "Nice Volvo S60. "
          "I won't deliver it to you.",
      1150,
      3.9,
      "5M7 1042",
      false,
    ),
    Car(
      4,
      'assets/images/cars/volvo-s60-2005.jpg',
      'Volvo S60 2005',
      'Praha 6 - Dejvice',
      'Kozlovska 3',
      3,
      [2, 3],
      "Older Volvo S60 model, no air conditioning, but still drives well. "
          "I won't deliver it to you.",
      755,
      3.8,
      "3A3 5449",
      false,
    ),
    Car(
      5,
      'assets/images/cars/octavia.jpg',
      'Škoda Octavia RS III',
      'Praha 6 - Dejvice',
      'Kozlovska 3',
      1,
      [1, 2, 3],
      "Nabízíme pronájem prémiového modelu Škoda Octavia III RS s náhonem všech kol. "
          "Přistavení na Terminálu Letiště Václava Havla Praha zajistí naše autopůjčovna nonstop.",
      1400,
      4.1,
      "TH1 3 KK",
      false,
    ),
    Car(
      6,
      'assets/images/cars/volvo-xc60.jpg',
      'Volvo XC60',
      'Praha 6 - Dejvice',
      'Kozlovska 3',
      3,
      [1, 2, 3],
      "Well equipped and maintained Volvo XC60. "
          "I won't deliver it to you.",
      1850,
      4.2,
      "U3A 8547",
      false,
    ),
  ];

  static List<CarFeature> carsFeatures = [
    CarFeature(1, "Automatic transmission", Icons.car_repair),
    CarFeature(2, "5 seats", Icons.filter_5),
    CarFeature(3, "Family edition", Icons.family_restroom),
    CarFeature(4, "2 seats", Icons.filter_2),
    CarFeature(5, "Sport edition", Icons.sports_esports),
  ];

  static List<Owner> owners = [
    Owner(
      1,
      "assets/images/Owner1.png",
      "Arnold",
      "Arnold Schwarzenegger",
      "+1 310 396-5917",
      "Give me your wear or rent a car!",
      2019,
      4.1,
      "Santa Monica, CA",
      "3110 Main Street, Suite 300",
      [
        Review(
          'assets/images/Owner2.png',
          'Karolina',
          'January 2021',
          'Very pleasant experience. Arnold was kind ans helped us everything! 5 stars.',
          5.0,
        ),
        Review(
          'assets/images/Owner1.png',
          'Arnold',
          'December 2020',
          'Yes, I rented my own car. Why? Because I am Arnold and i can do whatever i want !!',
          4.0,
        ),
      ],
    ),
    Owner(
      2,
      "assets/images/Owner2.png",
      "Karolina",
      "Karolina Velikova",
      "+420 147 789 963",
      "Pronajimam sva dve auta, novou "
          "Octavii a starsi Sport car. Vyzvednuti po domluve bud rano, nebo klidne vecer "
          "pred rezervaci.",
      2021,
      4.1,
      "Praha 6, CZ",
      "Kozlovska 4",
      [],
    ),
    Owner(
      3,
      "assets/images/Owner3.png",
      "Josef",
      "Josef Starý",
      "+420 547 744 113",
      "All my life I've only been driving Volvos, "
          "I love them for their reliability and quality. You can rent some of my older models.",
      2021,
      4.0,
      "Praha 6, CZ",
      "Kozlovska 4",
      [
        Review(
          'assets/images/Owner2.png',
          'Karolina',
          'January 2021',
          'I rented the 2005 model. It was mediocre, but you get what you pay for',
          4.0,
        ),
      ],
    ),
  ];

  static List<Reservation> reservations = [
    Reservation(
      cars[1],
      DateTime(2022, 10, 23),
      DateTime(2022, 10, 28),
      ReservationState.reserved,
      "Meet me at 8:30 near the car, I will give you "
      "everything you need. If you prefer a different "
      "time, call me or text me on WhatsUp.",
      null,
    ),
  ];

  static List<Reservation> oldReservations = [
    Reservation(
      cars[4],
      DateTime(2022, 9, 22),
      DateTime(2022, 9, 30),
      ReservationState.leaveReview,
      "Meet me at 8:30 near the car, I will give you "
      "everything you need. If you prefer a different "
      "time, call me or text me on WhatsUp.",
      null,
    ),
    Reservation.withReview(
      cars[0],
      DateTime(2022, 6, 22),
      DateTime(2022, 6, 24),
      ReservationState.reviewed,
      "Meet me at 8:30 near the car, I will give you "
          "everything you need. If you prefer a different "
          "time, call me or text me on WhatsUp.",
      null,
      "All was good :)",
      4.5,
    ),
  ];

  static User currentUser = User(
    "Karel",
    "Potocka",
    DateTime(1995, 05, 12),
    "karel.potocka@seznam.cz",
    "+420 741 963 987",
    "**** **** **** 6134",
  );

  static List<CarFeature> currentFeatures = [];
  static SingingCharacter sort = SingingCharacter.topRated;
  static int minPrice = 0;
  static int maxPrice = 0;

  static void setToDefaultFilters() {
    currentFeatures.clear();
    sort = SingingCharacter.topRated;
    minPrice = 0;
    maxPrice = 0;
  }
}

enum SingingCharacter { topRated, cheaper }
