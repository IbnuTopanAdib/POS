import 'package:final_project_sanbercode/blocs/auth_bloc/auth_bloc.dart';
import 'package:final_project_sanbercode/const/onboarding_content.dart';
import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:final_project_sanbercode/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  final List<Map<String, dynamic>> contents = onBoardingContent;
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Pallete.primary, Pallete.secondary],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.only(bottom: 80),
          child: PageView.builder(
            controller: controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == contents.length - 1);
            },
            itemCount: contents.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    contents[index]['image'],
                    height: MediaQuery.of(context).size.height / 2.5,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    contents[index]['title'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    child: Text(
                      contents[index]['content'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        bottomSheet: isLastPage
            ? Container(
                color: Colors.white,
                height: 80,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthCompleteOnboarding());
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text('MULAI', style: TextStyle(fontSize: 24)),
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => controller.jumpToPage(2),
                      child: const Text('SKIP'),
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        onDotClicked: (index) => controller.animateToPage(index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn),
                      ),
                    ),
                    TextButton(
                      onPressed: () => controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      child: const Text('NEXT'),
                    ),
                  ],
                ),
              ));
  }
}
