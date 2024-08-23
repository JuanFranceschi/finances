import 'package:finances/components/onboarding/tip_page.dart';
import 'package:finances/utils/app_locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with SingleTickerProviderStateMixin {
  late final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Stack(
          children: [
            Positioned(
              left: 250,
              right: -250,
              top: 0,
              child: Container(
                height: 500,
                width: 500,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    width: 40,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 150,
              right: -350,
              top: -250,
              child: Container(
                height: 1000,
                width: 1000,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    width: 40,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 200,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      MediaQuery.of(context).size.width * .5,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    MediaQuery.of(context).size.width * .5,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        children: [
                          TipPageWidget(
                            icon: Symbols.receipt_long_rounded,
                            description: AppLocale.onboardingTransactions.getString(context),
                          ),
                          TipPageWidget(
                            icon: Symbols.dataset_rounded,
                            description: AppLocale.onboardingCategories.getString(context),
                          ),
                          TipPageWidget(
                            icon: Symbols.bar_chart_rounded,
                            description: AppLocale.onboardinReports.getString(context),
                            endButton: true,
                          ),
                        ],
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: 3,
                      effect: WormEffect(
                        dotColor: Theme.of(context).colorScheme.secondaryContainer,
                        activeDotColor: Theme.of(context).focusColor,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
