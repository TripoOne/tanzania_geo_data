class Ward {
  final String name;
  final String districtName;
  final String? postCode;

  const Ward({
    required this.name,
    required this.districtName,
    this.postCode,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'districtName': districtName,
        'postCode': postCode,
      };

  factory Ward.fromJson(Map<String, dynamic> json) => Ward(
        name: json['name'],
        districtName: json['districtName'],
        postCode: json['postCode'],
      );

  @override
  String toString() => 'Ward(name: $name, districtName: $districtName, postCode: $postCode)';
}
