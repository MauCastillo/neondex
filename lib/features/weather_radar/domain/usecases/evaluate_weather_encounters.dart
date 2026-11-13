import '../entities/weather_encounter_recommendation.dart';
import '../entities/weather_forecast.dart';

class EvaluateWeatherEncounters {
  const EvaluateWeatherEncounters();

  String describeWmoCode(int code) {
    if (code == 0) return 'Cielo Despejado';
    if (code == 1 || code == 2) return 'Parcialmente Nublado';
    if (code == 3) return 'Cielo Cubierto';
    if (code == 45 || code == 48) return 'Niebla Densa';
    if (code >= 51 && code <= 57) return 'Llovizna Activa';
    if (code >= 61 && code <= 67) return 'Lluvia Intensa';
    if (code >= 71 && code <= 77) return 'Nevada / Escarcha';
    if (code >= 80 && code <= 82) return 'Chubascos Fuertes';
    if (code == 85 || code == 86) return 'Tormenta de Nieve';
    if (code >= 95) return 'Tormenta Eléctrica';
    return 'Clima Variable';
  }

  WeatherEncounterReport call(WeatherForecast forecast) {
    final code = forecast.weatherCode;
    final temp = forecast.temperatureC;
    final wind = forecast.windSpeedKmh;
    final humidity = forecast.relativeHumidity;
    final isDay = forecast.isDay;

    final recommendations = <String, WeatherEncounterRecommendation>{};

    void addRec(String type, int affinity, String reason) {
      final existing = recommendations[type];
      if (existing == null || affinity > existing.affinityPercent) {
        recommendations[type] = WeatherEncounterRecommendation(
          typeName: type,
          affinityPercent: affinity.clamp(10, 99),
          reason: reason,
        );
      }
    }

    String biomeTag;
    if (code >= 95) {
      biomeTag = 'STORM-GRID // HIGH VOLTAGE';
      addRec('electric', 98, 'Descargas atmosféricas activas');
      addRec('dragon', 84, 'Anomalía energética de tormenta');
      addRec('water', 80, 'Precipitación asociada al frente');
    } else if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      biomeTag = 'HYDRO-SECTOR // RAINFALL';
      addRec('water', 95, 'Lluvia activa favorece hábitat acuático');
      addRec('electric', 78, 'Humedad conductiva en el ambiente');
      addRec('bug', 72, 'Actividad tras humedad superficial');
    } else if ((code >= 71 && code <= 77) || code == 85 || code == 86 || temp <= 4) {
      biomeTag = 'CRYO-ZONE // SUB-ZERO';
      addRec('ice', 96, 'Bajas temperaturas y clima gélido');
      addRec('steel', 76, 'Resistencia térmica extrema');
      addRec('water', 65, 'Condensación fría en el sector');
    } else if (code == 45 || code == 48) {
      biomeTag = 'SPECTRAL-MIST // LOW VISIBILITY';
      addRec('ghost', 93, 'Niebla densa oculta presencias espectrales');
      addRec('poison', 81, 'Partículas suspendidas en la bruma');
      addRec('psychic', 75, 'Distorsión sensorial en el radar');
    } else if (temp >= 28) {
      biomeTag = 'SOLAR-FLARE // THERMAL SURGE';
      addRec('fire', 94, 'Radiación térmica elevada (${temp.toStringAsFixed(1)}°C)');
      addRec('ground', 84, 'Terreno árido y calor superficial');
      addRec('grass', 72, 'Fotosíntesis intensa bajo luz solar');
    } else if (code <= 1 && isDay) {
      biomeTag = 'DAYLIGHT-SCAN // CLEAR SKY';
      addRec('grass', 89, 'Luz solar directa ideal para tipo Planta');
      addRec('normal', 82, 'Condiciones estables en superficie');
      addRec('fairy', 76, 'Luminosidad despejada');
    } else if (!isDay) {
      biomeTag = 'NIGHT-CITY // NOCTURNAL SIGNAL';
      addRec('dark', 92, 'Oscuridad nocturna activa depredadores');
      addRec('ghost', 85, 'Frecuencia nocturna elevada');
      addRec('psychic', 78, 'Actividad psíquica bajo cielo nocturno');
    } else {
      biomeTag = 'OVERCAST-NET // CLOUD COVER';
      addRec('normal', 82, 'Clima templado sin alertas extremas');
      addRec('fighting', 76, 'Condiciones óptimas de entrenamiento');
      addRec('poison', 68, 'Cobertura nubosa moderada');
    }

    if (wind >= 22) {
      addRec('flying', 89, 'Viento fuerte (${wind.toStringAsFixed(0)} km/h)');
      addRec('dragon', 76, 'Corrientes aéreas de alta velocidad');
    }

    if (humidity >= 80 && !recommendations.containsKey('water')) {
      addRec('water', 74, 'Humedad ambiental del $humidity%');
    }

    if (forecast.elevation >= 1800) {
      addRec('rock', 79, 'Sector de gran altitud (${forecast.elevation.round()} m)');
    }

    final sorted = recommendations.values.toList()
      ..sort((a, b) => b.affinityPercent.compareTo(a.affinityPercent));

    return WeatherEncounterReport(
      conditionTitle: describeWmoCode(code),
      biomeTag: biomeTag,
      recommendations: sorted.take(5).toList(),
    );
  }
}
