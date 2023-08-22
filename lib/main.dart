import 'package:flutter/material.dart';
import 'package:weather/weather-api.dart';

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
      ),
      home: WeatherScreen(),
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
      print('Erro: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao obter dados da previsão do tempo.'),
        ),
      );
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Digite o nome da cidade'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _getWeatherData,
              child: Text('Obter Previsão do Tempo'),
            ),
            SizedBox(height: 16.0),
            if (_weatherData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cidade: ${_weatherData['name']}'),
                  Text(
                    'Temperatura: ${_formatTemperature(_weatherData['main']['temp'])}°C',
                  ),
                  Text(
                      'Condição: ${_weatherData['weather'][0]['description']}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
