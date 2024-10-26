import 'package:flutter/material.dart';

import '../../profilescreen/home_screen/home_screen.dart';
import 'onboarding_model.dart';

class OnboardingScreen extends StatelessWidget {
final List<OnboardingPageModel> onboardingPages = [
  OnboardingPageModel(
    title: "Welcome",
    description: "Discover the amazing features of our app.",
    image: 'assets/images/image1.jpg', // Use actual image paths from assets
    bgColor: Colors.blue,
    textColor: Colors.white,
  ),
  OnboardingPageModel(
    title: "Track Your Progress",
    description: "Keep track of your daily activities easily.",
    image: 'assets/images/image2.jpg',
    bgColor: Colors.green,
    textColor: Colors.white,
  ),
  OnboardingPageModel(
    title: "Stay Connected",
    description: "Connect with others and share your experience.",
    image: 'assets/images/image1.jpg',
    bgColor: Colors.orange,
    textColor: Colors.white,
  ),
];

@override
Widget build(BuildContext context) {
  return OnboardingPage(pages: onboardingPages);
}
}
