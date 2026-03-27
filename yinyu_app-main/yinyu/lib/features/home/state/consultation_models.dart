class Consultant {
  final String id;
  final String name;
  final String title;
  final double rating;
  final int cases;
  final List<String> specialties;

  const Consultant({
    required this.id,
    required this.name,
    required this.title,
    required this.rating,
    required this.cases,
    required this.specialties,
  });
}
