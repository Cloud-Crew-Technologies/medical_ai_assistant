import 'package:get/get.dart';
import 'package:medical_ai_assistant/app/modules/Health_metrics_Screen/models/Health_metrics_models.dart';

class HealthMetricsController extends GetxController {

  List<HealthMetric> healthMetrics = [
    HealthMetric(title: "Health Score", value: "61.3", unit: "pts", color: 0xFF1E8E6E),
    HealthMetric(title: "Heart Rate", value: "86", unit: "bpm", color: 0xFFE14B4B),
    HealthMetric(title: "Sleep", value: "4.5", unit: "hrs", color: 0xFFEF8D3C),
  ];

  List<VirtualConsultation> consultations = [
    VirtualConsultation(doctorName: "Dr. Hannibal Lector", specialty: "Orthopedics", rating: 4.1, time: "9:25 AM - 11:25 AM"),
    VirtualConsultation(doctorName: "Dr. Jane Doe", specialty: "Neurology", rating: 3.9, time: "1:00 PM - 2:00 PM"),
  ];
  
}
    