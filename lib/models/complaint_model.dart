class ComplaintModel {
  final String id;
  final String title;
  final String description;
  final String status;

  ComplaintModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  factory ComplaintModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return ComplaintModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] ?? 'Pending',
    );
  }
}