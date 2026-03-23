class Street {
  final String name;
  final String wardName;

  const Street({
    required this.name,
    required this.wardName,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'wardName': wardName,
      };

  factory Street.fromJson(Map<String, dynamic> json) => Street(
        name: json['name'],
        wardName: json['wardName'],
      );

  @override
  String toString() => 'Street(name: $name, wardName: $wardName)';
}
