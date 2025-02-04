import 'Review.dart';

class Owner {
  int id;
  String photoPath;
  String shortName;
  String fullName;
  String phoneNumber;
  String description;
  int yearRatingSince;
  double rating;
  String shortLocation;
  String street;
  List<Review> reviews;

  Owner(this.id, this.photoPath, this.shortName, this.fullName, this.phoneNumber, this.description,
      this.yearRatingSince, this.rating, this.shortLocation, this.street, this.reviews);
}