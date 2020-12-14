import 'package:flutter/foundation.dart';
import 'package:simple_http_fetch/main.dart';

enum ResultStateAlbum { Loading, NoData, HasData, Error }

class AlbumProvider extends ChangeNotifier {
  final fetchAlbum;

  AlbumProvider({@required this.fetchAlbum}) {
    _fetchAlbum();
  }

  Album _albumResult;
  String _message;
  ResultStateAlbum _state;

  String get message => _message;
  Album get result => _albumResult;
  ResultStateAlbum get state => _state;

  Future<dynamic> _fetchAlbum() async {
    try {
      _state = ResultStateAlbum.Loading;
      notifyListeners();
      final album = await fetchAlbum();

      if (album.title.isEmpty) {
        _state = ResultStateAlbum.NoData;
        notifyListeners();
        return _message = 'empty Data';
      } else {
        _state = ResultStateAlbum.HasData;
        notifyListeners();
        return _albumResult = album;
      }
    } catch (e) {
      _state = ResultStateAlbum.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
