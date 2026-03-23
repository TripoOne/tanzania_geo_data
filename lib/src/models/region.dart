class Region {
  final String name;
  final String? postCode;

  const Region({
    required this.name,
    this.postCode,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'postCode': postCode,
      };

  factory Region.fromJson(Map<String, dynamic> json) => Region(
        name: json['name'],
        postCode: json['postCode'],
      );

  @override
  String toString() => 'Region(name: $name, postCode: $postCode)';
}
