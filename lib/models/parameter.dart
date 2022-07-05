class Parameter {
  final String fecini;
  final String fecfin;

  const Parameter({
    required this.fecini,
    required this.fecfin,
  });

  Parameter copy({
    String? fecini,
    String? fecfin,
  }) =>
      Parameter(
        fecini: fecini ?? this.fecini,
        fecfin: fecfin ?? this.fecfin,
      );

  static Parameter fromJson(Map<String, dynamic> json) => Parameter(
        fecini: json['fecini'],
        fecfin: json['fecfin'],
      );

  Map<String, dynamic> toJson() => {
        'fecini': fecini,
        'fecfin': fecfin,
      };
}
