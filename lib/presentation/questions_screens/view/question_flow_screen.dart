import 'package:flutter/material.dart';
import 'additional_requirement.dart';
import 'personal_info.dart';
import 'event_details.dart';
import 'budget_screen.dart';
import 'venue_preference.dart';
import 'view_and_ambiance.dart';

class QuestionsFlowScreen extends StatefulWidget {
  const QuestionsFlowScreen({super.key});

  @override
  QuestionsFlowScreenState createState() => QuestionsFlowScreenState();
}

class QuestionsFlowScreenState extends State<QuestionsFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToNextPage() {
    if (_currentPage < 5) {
      _pageController.animateToPage(
        ++_currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        --_currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          PersonalInfo(goToNext: _goToNextPage),
          EventDetails(
            goToNext: _goToNextPage,
            goToPrevious: _goToPreviousPage,
          ),
          VenuePreferences(
            goToNext: _goToNextPage,
            goToPrevious: _goToPreviousPage,
          ),
          ViewAndAmbiance(
            goToNext: _goToNextPage,
            goToPrevious: _goToPreviousPage,
          ),
          BudgetScreen(
            goToNext: _goToNextPage,
            goToPrevious: _goToPreviousPage,
          ),
          AdditionalRequirements(goToPrevious: _goToPreviousPage),
        ],
      ),
    );
  }
}
