class District {
  final String name;
  final String regionName;
  final String? postCode;

  const District({
    required this.name,
    required this.regionName,
    this.postCode,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'regionName': regionName,
        'postCode': postCode,
      };

  factory District.fromJson(Map<String, dynamic> json) => District(
        name: json['name'],
        regionName: json['regionName'],
        postCode: json['postCode'],
      );

  @override
  String toString() => 'District(name: $name, regionName: $regionName, postCode: $postCode)';
}
