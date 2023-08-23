import 'package:flutter/material.dart';
import 'package:weather/weather-api.dart';
import 'weather_details.dart';
import 'bottom_navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: WeatherScreen(),
      routes: {
        '/weather-details': (context) => WeatherDetailsScreen(),
      },
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  dynamic _weatherData;
  int _currentIndex = 0;

  Future<void> _getWeatherData() async {
    final cityName = _cityController.text;
    final weatherApi = WeatherApi();

    setState(() {
      _weatherData = null;
    });

    try {
      final weatherData = await weatherApi.getWeatherByCity(cityName: cityName);
      setState(() {
        _weatherData = weatherData;
      });
    } catch (e) {
      print(e);
    }
  }

  String _formatTemperature(double temperature) {
    return (temperature - 273.15).toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'Digite o nome da cidade',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: _getWeatherData,
                      child: Text(
                        'Obter Previsão do Tempo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Visibility(
                  visible: _weatherData != null,
                  child: Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weatherData != null
                                ? '${_weatherData['name']}'
                                : 'Cidade não encontrada',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _weatherData != null
                                ? '${_formatTemperature(_weatherData['main']['temp'])}°C'
                                : '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 86,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(216, 58, 58, 58),
                            ),
                          ),
                          Text(
                            _weatherData != null
                                ? '${_weatherData['weather'][0]['description']}'
                                : '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            Navigator.pushNamed(context, '/weather-details');
          }
        },
      ),
    );
  }
}
