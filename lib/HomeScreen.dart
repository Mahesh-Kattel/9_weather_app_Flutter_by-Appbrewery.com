import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> guff = [
    'Don\'t Get Outside Its too hot🌞🌞🌞.Be in your Room Have Cold Drinks and plenty of cold Water.🌤🌤🌤',
    'Its Hot🌝🌝🌝. Have fun inside your house with some cold shower and cold juices.Go Swimming🏊‍♂🏊‍♂ ',
    'Its COOL wear Light Dresses.Have Fun 🚵‍♂️🚵‍♂️🚵‍♂️Boom get your jod done fast',
    'Its cold wear Jackets and have Dudh Chiya☕☕☕ I miss Ashish!! Where is Ashish.',
    'Its Soo Cold.Lets Have Khukuri Rum with Honey🥂🥂🥂.Ashish lai chai dud Chiya',
    'Ohh!! Its freezy lets get inside Sirak..Its snowing Outside....🌧 🌧 🌧'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  late double latitude;
  late double longitude;
  static double temp = 0.0;
  int? tempc = 0;
  String? description = '';
  String? cityName = '';
  String? city = '';
  getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      if (position == LocationPermission.denied) {
        print('denied');
      }
      latitude = position.latitude;
      longitude = position.longitude;
      print(longitude);

      getData();
    } catch (e) {
      print(e.toString().toString());
    }
  }

  getData() async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=65e777e17e8d4443716ea0e893ff18bf');
    http.Response response = await http.get(url);
    //print(response.body);
    String data = response.body;
    temp = jsonDecode(data)['main']['temp'];
    city = jsonDecode(data)['name'];
    description = jsonDecode(data)['weather'][0]['description'];
    latitude = jsonDecode(data)['coord']['lat'];
    longitude = jsonDecode(data)['coord']['lon'];
    setState(() {
      tempc = temp.toInt() - 274;
    });
  }

  getDescription() {
    if (tempc! >= 35) {
      return guff[0];
    } else if (tempc! >= 27 && tempc! < 35) {
      return guff[1];
    } else if (tempc! >= 20 && tempc! < 27) {
      return guff[2];
    } else if (tempc! > 10 && tempc! < 20) {
      return guff[3];
    } else if (tempc! > 0 && tempc! < 10) {
      return guff[4];
    } else if (tempc! < 0) {
      return guff[5];
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
          child: FloatingActionButton(
            onPressed: () {
              getLocation();
            },
            child: const Icon(Icons.location_city_outlined),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/weather1.jpg'),
                    fit: BoxFit.cover,
                    opacity: 150.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(15)),
                              width: MediaQuery.of(context).size.width / 2.8,
                              height: MediaQuery.of(context).size.height / 5,
                              child: Center(
                                child: Text(
                                  '$tempc°',
                                  style: const TextStyle(
                                      fontSize: 80,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 17,
                                  width: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white54),
                                  child: TextField(
                                    onChanged: (value) {
                                      cityName = value;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "City Name Here",
                                        border: InputBorder.none),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                MaterialButton(
                                  height: 40,
                                  color: Colors.black54,
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Search",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                  onPressed: () async {
                                    var url = Uri.parse(
                                        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=65e777e17e8d4443716ea0e893ff18bf');
                                    http.Response response =
                                        await http.get(url);
                                    String data = response.body;

                                    temp = jsonDecode(data)['main']['temp'];

                                    city = jsonDecode(data)['name'];
                                    description = jsonDecode(data)['weather'][0]
                                        ['description'];
                                    setState(() {});
                                    setState(() {
                                      tempc = temp.toInt() - 274;
                                    });
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 25),
                        Text(
                          "$city",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40),
                        ),
                        const SizedBox(height: 45),
                        Text(
                          "$description".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              getDescription(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
