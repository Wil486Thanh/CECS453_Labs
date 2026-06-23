import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  factory WeatherData.defaults() {
    final defaultString =
        '{"coord":{"lon":-117.9537,"lat":33.7092},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01d"}],"base":"stations","main":{"temp":77.2,"feels_like":77.49,"temp_min":73.06,"temp_max":83.35,"pressure":1013,"humidity":61,"sea_level":1013,"grnd_level":1009},"visibility":10000,"wind":{"speed":8.01,"deg":288,"gust":14},"clouds":{"all":0},"dt":1782168821,"sys":{"type":2,"id":2007369,"country":"US","sunrise":1782132120,"sunset":1782183936},"timezone":-25200,"id":5350207,"name":"Fountain Valley","cod":200}';
    final Map<String, dynamic> json = jsonDecode(defaultString);
    return new WeatherData.fromJson(json);
  }
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
      Text("${data.tempF} F"),
      Text("${data.highTemp} F"),
      Text("${data.lowTemp} F"),
      Text("${data.windSpeed} mph"),
      SizedBox(height: 20),
      Text("${data.city}"),
    ];
    return Column(
      children: [
        Image.network('https://openweathermap.org/payload/api/media/file/${data.imageCode}.png', width:50, height:50),
        Row(
          mainAxisAlignment: .center,
          children: [
            Column(crossAxisAlignment: .start, children: headerColumn),
            Column(crossAxisAlignment: .end, children: dataColumn),
          ],
        ),
      ],
    );
  }
}

class SelectCityPage extends StatefulWidget {
  const SelectCityPage({super.key});

  @override
  State<SelectCityPage> createState() => _SelectCityPageState();
}

class _SelectCityPageState extends State<SelectCityPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Enter city name: "),
            TextField(controller: _controller),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
              child: Text("Return"),
            ),
          ],
        ),
      ),
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
  WeatherData pageData = .defaults();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            WeatherDisplay(data: pageData),
            SizedBox(height: 50),

            // change city button
            ElevatedButton(
              onPressed: () async {
                String cityName = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SelectCityPage(),
                  ),
                );
                pageData = .fromJson(
                  await WeatherService.fetchWeather(cityName),
                );
                setState(() {});
              },
              child: Text("Change City"),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherService {
  static Future<Map<String, dynamic>> fetchWeather(String city) async {
    // before we get this running somewhere other than dartpad you'll need to put your API key here
    // do NOT forget to delete it when uploading to GitHub
    String apiKey = '';
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=imperial',
      ),
    );
    if (response.statusCode == 200) {
      // this was the fill in the blank line
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
