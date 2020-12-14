import 'package:flutter/foundation.dart';
import 'package:simple_http_fetch/restaurant.dart';

enum ResultState { Loading, NoData, HasData, Error }

class RestoProvider extends ChangeNotifier {
  final fetchRestaurant;

  RestoProvider({@required this.fetchRestaurant}) {
    _fetchRestaurant();
  }

  Restaurant _restoResult;
  String _message;
  ResultState _state;

  String get message => _message;
  Restaurant get result => _restoResult;
  ResultState get state => _state;

  Future<dynamic> _fetchRestaurant() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final resto = await fetchRestaurant();

      if (resto.count == 0) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restoResult = resto;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
