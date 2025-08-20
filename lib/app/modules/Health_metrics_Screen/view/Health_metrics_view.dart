import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_ai_assistant/app/modules/Health_metrics_Screen/controllers/Health_metrics_controller.dart';
import 'package:medical_ai_assistant/app/theme/theme_data.dart';


class HealthMetricsView extends GetView<HealthMetricsController> {
  const HealthMetricsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Top Header Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? kPrimaryColor : kLightPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                //backgroundImage: AssetImage('assets/profile.jpg'),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Morning, Holo! 👋",
                                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                          // Notification 
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_none,
                              color: isDark ? kPrimaryColor : kLightPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      //  Search Field 
                      
                       Container(
                          width: double.infinity,
                          
                              //padding: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  
                                  Expanded(
                                    child: TextField(
                                          style: theme.textTheme.bodyMedium, // Text color from theme
                                          decoration: InputDecoration(
                                          hintText: "Search anything...",
                                          hintStyle: theme.inputDecorationTheme.hintStyle, // From theme file
                                          prefixIcon: const Icon(Icons.search),
                                     ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                //  Health Metrics Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Health Metrics", style: theme.textTheme.bodyLarge),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "See All",
                        style: TextStyle(color: isDark ? kGlowingTealColor : kLightTextButtonColor),
                      ),
                    ),
                  ],
                ),

                //  Health Metrics List
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.healthMetrics.length,
                    itemBuilder: (context, index) {
                      final metric = controller.healthMetrics[index];
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(metric.color),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(metric.title, style: const TextStyle(color: Colors.white, fontSize: 14)),
                            const Spacer(),
                            Text("${metric.value} ${metric.unit}",
                                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                //  Virtual Consultation Title
                Text("Virtual Consultation", style: theme.textTheme.bodyLarge),
                const SizedBox(height: 10),

                //  Virtual Consultation  List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.consultations.length,
                  itemBuilder: (context, index) {
                    final consult = controller.consultations[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? kSecondaryColor : kLightCardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 25,
                            //backgroundImage: AssetImage('assets/doctor.jpg'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(consult.doctorName, style: theme.textTheme.bodyLarge),
                                Text(consult.specialty, style: theme.textTheme.titleSmall),
                                Text(consult.time,
                                    style: TextStyle(
                                        color: isDark ? kGlowingTealColor : kLightPrimaryColor, fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark ? kPrimaryColor : kLightPrimaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text("${consult.rating} ★", style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      //  Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: isDark ? kPrimaryColor : kLightPrimaryColor,
        unselectedItemColor:isDark ? kPrimaryColor : kLightPrimaryColor,
        onTap: (index) {
          // Handle bottom nav tap
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: "Alerts"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}