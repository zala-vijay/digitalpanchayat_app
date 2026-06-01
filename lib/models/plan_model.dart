class PlanModel {
  final String id;
  final String title;
  final String description;
  final String status;

  PlanModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory PlanModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return PlanModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'Ongoing',
    );
  }
}