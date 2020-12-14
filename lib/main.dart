import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:simple_http_fetch/album_provider.dart';
import 'package:simple_http_fetch/restaurant.dart';
import 'package:simple_http_fetch/resto_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestoProvider>(
            create: (_) =>
                RestoProvider(fetchRestaurant: Restaurant.fetchRestaurant)),
        ChangeNotifierProvider<AlbumProvider>(
            create: (_) => AlbumProvider(fetchAlbum: Album.fetchAlbum)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Consumer<AlbumProvider>(
              builder: (context, state, _) {
                if (state.state == ResultStateAlbum.Loading) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Center(
                    child: Text(state.result.title),
                  );
                }
              },
            ),
            Center(
              child: Consumer<RestoProvider>(
                builder: (context, state, _) {
                  if (state.state == ResultState.Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.state == ResultState.HasData) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.result.restaurants.length,
                        itemBuilder: (context, index) {
                          var restaurant = state.result.restaurants[index];
                          return Container(
                            margin: EdgeInsets.fromLTRB(15, 3, 15, 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[350],
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(0, 3))
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 80.0,
                                  width: 120.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        'https://restaurant-api.dicoding.dev/images/medium/' +
                                            restaurant.pictureId,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      restaurant.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14),
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.place,
                                          size: 20,
                                          color: Color(0xffFA5D5D),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          restaurant.city,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          size: 20,
                                          color: Colors.orangeAccent,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          restaurant.rating.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  } else if (state.state == ResultState.NoData) {
                    return Center(child: Text(state.message));
                  } else if (state.state == ResultState.Error) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Text(''));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
    );
  }

  static Future fetchAlbum() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/albums/1');

    if (response.statusCode == 200) {
      return Album.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
