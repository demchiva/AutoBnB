class Car {
  int id;
  String photoUrl;
  String title;
  String location;
  String street;
  int ownerId;
  List<int> features;
  String description;
  int price;
  double score;
  String registrationPlate;
  bool liked;

  Car(
    this.id,
    this.photoUrl,
    this.title,
    this.location,
    this.street,
    this.ownerId,
    this.features,
    this.description,
    this.price,
    this.score,
    this.registrationPlate,
    this.liked,
  );

  String get priceText => "$price Kc / day";
}
