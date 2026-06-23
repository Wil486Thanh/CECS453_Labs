import 'package:flutter/material.dart';
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class WeatherData {
  // image code, current temp, weather conditions, city name,
  final String imageCode;
  final double tempF;
  final double highTemp;
  final double lowTemp;
  final String city;
  final double windSpeed;

  WeatherData.fromJson(Map<String, dynamic> json)
    : imageCode = json['weather'][0]['icon'],
      tempF = json['main']['temp'],
      highTemp = json['main']['temp_max'],
      lowTemp = json['main']['temp_min'],
      city = json['name'],
      windSpeed = json['wind']['speed'];
}

class WeatherDisplay extends StatelessWidget {
  final WeatherData data;
  const WeatherDisplay({required this.data});

  @override
  Widget build(BuildContext context) {
    List<Widget> headerColumn = [
      Text("Image code"),
      Text("Temperature"),
      Text("High"),
      Text("Low"),
      Text("Wind Speed"),
      SizedBox(height: 20),
      Text("City"),
    ];
    List<Widget> dataColumn = [
      Text("${data.imageCode}"),
      Text("${data.tempF}"),
      Text("${data.highTemp}"),
      Text("${data.lowTemp}"),
      Text("${data.windSpeed}"),
      SizedBox(height: 20),
      Text("${data.city}"),
    ];
    return Row(
      mainAxisAlignment: .center,
      children: [
        Column(crossAxisAlignment: .start, children: headerColumn),
        Column(crossAxisAlignment: .end, children: dataColumn),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final jsonString =
      '{"coord":{"lon":-117.9537,"lat":33.7092},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"base":"stations","main":{"temp":77.2,"feels_like":77.49,"temp_min":73.06,"temp_max":83.35,"pressure":1013,"humidity":61,"sea_level":1013,"grnd_level":1009},"visibility":10000,"wind":{"speed":8.01,"deg":288,"gust":14},"clouds":{"all":0},"dt":1782168821,"sys":{"type":2,"id":2007369,"country":"US","sunrise":1782132120,"sunset":1782183936},"timezone":-25200,"id":5350207,"name":"Fountain Valley","cod":200}';

  @override
  Widget build(BuildContext context) {
    final thingy = jsonDecode(jsonString) as Map<String, dynamic>;
    print(WeatherData.fromJson(thingy));

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [WeatherDisplay(data: .fromJson(thingy))],
        ),
      ),
    );
  }
}
