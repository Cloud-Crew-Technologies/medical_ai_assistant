import 'package:get/get.dart';
import 'package:medical_ai_assistant/app/modules/Health_metrics_Screen/controllers/Health_metrics_controller.dart';



class HealthMetricsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthMetricsController>(
      () => HealthMetricsController(),
    );
  }
}