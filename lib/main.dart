import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//Todo use JSON serializer and parse json

void main() => runApp(new MaterialApp(home: StarWarsWidget()));

class StarWarsWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new StarWarState();
}

class StarWarState extends State<StarWarsWidget> {
  final String _url = "https://swapi.co/api/starships";
  List _data;

  Future<StarWar> getData() async {
    var res = await http
        .get(Uri.encodeFull(_url), headers: {"Accept": "application/json"});

    final _resBody = json.decode(res.body);
    return new StarWar.fromJson(_resBody);

  }


  Widget _listView(_data) =>
      new ListView.builder(
        itemCount: _data == null ? 0 : _data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Container(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Card(
                    child: new Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Container(
                          child: Text(_data[index].name,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black54))),
                    )),
                new Card(
                  child: new Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: new Container(
                        child: Text(_data[index].model,
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.redAccent)),
                      )),
                )
              ],
            ),
          );
        },
      );


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Star Wars Ship'),
          backgroundColor: Colors.amberAccent,
        ),
        body:FutureBuilder<StarWar>(
          future: getData(),
          builder: (context,snapShot){
            if(snapShot.hasData){
              return _listView(snapShot.data.results);
            }else if(snapShot.hasError){
              return new Text("${snapShot.error}");
            }
            return new Center(child: new CircularProgressIndicator());
          })
    );
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }
}

class StarWar {
  final int count;
  final String next;
  final int previous;
  final List<Properties> results;

  StarWar({this.count, this.next, this.previous, this.results});

  factory StarWar.fromJson(Map<String, dynamic> json) {
    return new StarWar(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((e) => Properties.fromJson(e))
          .toList(),
    );
  }
}

class Properties {
  final String name;
  final String model;
  final String manufacturer;
  final String cost_in_credits;
  final String length;
  final String max_atmosphering_speed;
  final String crew;
  final String passengers;
  final String cargo_capacity;
  final String consumables;
  final String hyperdrive_rating;
  final String MGLT;
  final String starship_class;
  final List<String> pilots;
  final List<String> films;
  final String created;
  final String edited;
  final String url;

  Properties({
    this.name,
    this.model,
    this.manufacturer,
    this.cost_in_credits,
    this.length,
    this.max_atmosphering_speed,
    this.crew,
    this.passengers,
    this.cargo_capacity,
    this.consumables,
    this.hyperdrive_rating,
    this.MGLT,
    this.starship_class,
    this.pilots,
    this.films,
    this.created,
    this.edited,
    this.url,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return new Properties(
      name: json['name'],
      model: json['model'],
      manufacturer: json['manufacturer'],
      cost_in_credits: json['cost_in_credits'],
      length: json['length'],
      max_atmosphering_speed: json['max_atmosphering_speed'],
      crew: json['crew'],
      passengers: json['passengers'],
      cargo_capacity: json['cargo_capacity'],
      consumables: json['consumables'],
      hyperdrive_rating: json['hyperdrive_rating'],
      MGLT: json['MGLT'],
      starship_class: json['starship_class'],
      pilots: (json['pilots'] as List).cast<String>().toList(),
      films: (json['films'] as List).cast<String>().toList(),
      created: json['created'],
      edited: json['edited'],
      url: json['url'],
    );
  }
}
