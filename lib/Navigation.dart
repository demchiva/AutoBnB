import 'package:autobnb/HomeScreen.dart';
import 'package:autobnb/ReservationDetailScreen.dart';
import 'package:flutter/material.dart';

import 'CarDetailScreen.dart';
import 'CreateReservationScreen.dart';
import 'EditReservationScreen.dart';
import 'FilterScreen.dart';
import 'LeaveReviewScreen.dart';
import 'OwnerScreen.dart';
import 'SearchScreen.dart';

class Navigation {
  static const String MAIN_ROUTE_NAME = '/';

  static final Navigation me = Navigation._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Navigation._();

  Future<dynamic> navigateTo(
    final BuildContext context,
    final String routeName,
    final Object? args,
  ) =>
      Navigator.pushNamed(context, routeName, arguments: args);

  Future<void> carDetail(final BuildContext context) {
    return Navigator.of(context).pushNamed(CarDetailScreen.ROUTE_NAME);
  }

  Future<void> filter(final BuildContext context) {
    return Navigator.of(context).pushNamed(FilterScreen.ROUTE_NAME);
  }

  Future<void> filterFromSearchResults(final BuildContext context) {
    return Navigator.of(context).pushReplacementNamed(FilterScreen.ROUTE_NAME);
  }

  Future<void> createReservation(final BuildContext context) {
    return Navigator.of(context).pushNamed(CreateReservationScreen.ROUTE_NAME);
  }

  Future<void> ownerDetail(final BuildContext context) {
    return Navigator.of(context).pushNamed(OwnerScreen.ROUTE_NAME);
  }

  Future<void> reservations(final BuildContext context) {
    Navigation.me.popUntil(context, HomeScreen.ROUTE_NAME_RESERVATIONS);
    return Navigator.of(context).pushNamed(HomeScreen.ROUTE_NAME_RESERVATIONS);
  }

  Future<void> reservationDetail(final BuildContext context) {
    return Navigator.of(context).pushNamed(ReservationDetailScreen.ROUTE_NAME);
  }

  Future<void> editReservation(final BuildContext context) {
    return Navigator.of(context).pushNamed(EditReservationScreen.ROUTE_NAME);
  }

  Future<void> leaveReview(BuildContext context) {
    return Navigator.of(context).pushNamed(LeaveReviewScreen.ROUTE_NAME);
  }

  Future<void> searchResultsFromFilters(BuildContext context) {
    return Navigator.of(context).pushReplacementNamed(SearchScreen.ROUTE_NAME);
  }

  void pop(final BuildContext context) {
    Navigator.of(context).pop();
  }

  void popUntil(final BuildContext context, String route) {
    Navigator.of(context).popUntil(ModalRoute.withName(route));
  }

  Map<String, WidgetBuilder> routeList() => {
        CarDetailScreen.ROUTE_NAME: (final BuildContext context) =>
            CarDetailScreen(),
        FilterScreen.ROUTE_NAME: (final BuildContext context) =>
            const FilterScreen(),
        CreateReservationScreen.ROUTE_NAME: (final BuildContext context) =>
            CreateReservationScreen(),
        OwnerScreen.ROUTE_NAME: (final BuildContext context) => OwnerScreen(),
        HomeScreen.ROUTE_NAME_RESERVATIONS: (final BuildContext context) =>
            const HomeScreen(barIndex: 1),
        ReservationDetailScreen.ROUTE_NAME: (final BuildContext context) =>
            const ReservationDetailScreen(),
        EditReservationScreen.ROUTE_NAME: (final BuildContext context) =>
            const EditReservationScreen(),
        LeaveReviewScreen.ROUTE_NAME: (final BuildContext context) =>
            const LeaveReviewScreen(),
        SearchScreen.ROUTE_NAME: (final BuildContext context) =>
            const SearchScreen(),
      };

  Route<dynamic> onGenerateRoute(final RouteSettings routeSettings) =>
      MaterialPageRoute(
        builder: (final BuildContext context) {
          return const HomeScreen(barIndex: 0);
        },
        settings: routeSettings,
      );
}
