/// Distrito (bairro) de São Paulo retornado pela API de localidades do IBGE.
class Neighborhood {
  final int id;
  final String name;
  final String city;

  const Neighborhood({
    required this.id,
    required this.name,
    required this.city,
  });

  factory Neighborhood.fromJson(Map<String, dynamic> json) {
    final city = json['municipio'] as Map<String, dynamic>?;

    return Neighborhood(
      id: (json['id'] as num).toInt(),
      name: json['nome'] as String,
      city: (city?['nome'] as String?) ?? '',
    );
  }
}
