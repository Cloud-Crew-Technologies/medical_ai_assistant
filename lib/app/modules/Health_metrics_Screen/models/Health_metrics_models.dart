class HealthMetric {
  final String title;
  final String value;
  final String unit;
  final int color;

  HealthMetric({
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
  });
}

class VirtualConsultation {
  final String doctorName;
  final String specialty;
  final double rating;
  final String time;

  VirtualConsultation({
    required this.doctorName,
    required this.specialty,
    required this.rating,
    required this.time,
  });
}