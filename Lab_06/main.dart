import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Weather App', home: MainScreen());
  }
}

class Report {
  final String name;
  final String weather;
  //   final String weatherIcon;
  final double temperature;
  final double temperatureMin;
  final double temperatureMax;
  final double humidity;
  final double windSpeed;

  const Report({
    required this.name,
    required this.weather,
    //     required this.weatherIcon,
    required this.temperature,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.humidity,
    required this.windSpeed,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      name: json["name"] as String,
      weather: json["weather"][0]["main"] as String,
      //       weatherIcon: json["weather"][0]["icon"] as String,
      temperature: json["main"]["temp"] as double,
      temperatureMin: json["main"]["temp_min"] as double,
      temperatureMax: json["main"]["temp_max"] as double,
      humidity: json["main"]["humidity"] as double,
      windSpeed: json["wind"]["speed"] as double,
    );
  }
}

Future<Report> fetchWeather(String city) async {
  final apiKey = "";
  final response = await http.get(
    Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric',
    ),
  );

  if (response.statusCode == 200) {
    final responseJson = json.decode(response.body) as Map<String, dynamic>;
    return Report.fromJson(responseJson);
  } else {
    throw Exception('Failed to load weather data');
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<Report> futureWeatherReport;

  final TextEditingController _cityController = TextEditingController();
  String _city = "london";

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureWeatherReport = fetchWeather(_city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: .center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 500,
                      child: TextField(
                        controller: _cityController,
                        keyboardType: TextInputType.text,
                        onChanged: (text) {
                          setState(() {});
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _city = _cityController.text;
                          futureWeatherReport = fetchWeather(_city);
                        });
                      },
                      child: Text('Submit'),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 200,
                      child: FutureBuilder<Report>(
                        future: futureWeatherReport,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              child: Column(
                                children: [
                                  Text(
                                    "Current City: ${snapshot.data!.name}\nThe weather: ${snapshot.data!.weather}\nThe temperature: ${snapshot.data!.temperature} Celsius\nThe min temperature: ${snapshot.data!.temperatureMin} Celsius\nThe max temperature: ${snapshot.data!.temperatureMax} Celsius\nThe humidity: ${snapshot.data!.humidity}%\nThe wind speed: ${snapshot.data!.windSpeed} meter/sec",
                                  ),
                                  //                                   Container(
                                  //                                     child: Image.network(
                                  //                                       'https://openweathermap.org/payload/api/media/file/${snapshot.data!.weatherIcon}.png',
                                  //                                       height: 100,),
                                  //                                     ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          // By default, show a loading spinner.
                          return const CircularProgressIndicator();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
