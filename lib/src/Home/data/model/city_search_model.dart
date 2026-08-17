import 'package:weather_app/src/Home/domin/entity/city_search_entity.dart';

class CitySearchModel extends CitySearchEntity {
  const CitySearchModel({
    required super.name,
    required super.country,
    required super.latitude,
    required super.longitude,
  });

  factory CitySearchModel.fromJson(Map<String, dynamic> json) {
    final address = json['address'] as Map<String, dynamic>? ?? {};
    final displayName = json['display_name'] as String? ?? '';

    final name =
        (address['city'] ??
                address['town'] ??
                address['village'] ??
                address['municipality'] ??
                address['county'] ??
                address['state'] ??
                address['country'] ??
                (displayName.isNotEmpty
                    ? displayName.split(',').first.trim()
                    : ''))
            as String;

    return CitySearchModel(
      name: name,
      country: (address['country'] as String?) ?? '',
      latitude: double.tryParse(json['lat']?.toString() ?? '') ?? 0.0,
      longitude: double.tryParse(json['lon']?.toString() ?? '') ?? 0.0,
    );
  }
}
