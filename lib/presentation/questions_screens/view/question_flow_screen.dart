import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task2/presentation/authentication_screens/sign_up_screen/cubit/auth_cubit.dart';
import 'package:task2/presentation/questions_screens/view/additional_requirement.dart';
import 'package:task2/presentation/questions_screens/view/budget_screen.dart';
import 'package:task2/presentation/questions_screens/view/event_details.dart';
import 'package:task2/presentation/questions_screens/view/personal_info.dart';
import 'package:task2/presentation/questions_screens/view/venue_preference.dart';
import 'package:task2/presentation/questions_screens/view/view_and_ambiance.dart';

class QuestionsFlowScreen extends StatefulWidget {
  const QuestionsFlowScreen({super.key});

  @override
  QuestionsFlowScreenState createState() => QuestionsFlowScreenState();
}

class QuestionsFlowScreenState extends State<QuestionsFlowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String fullName = "";
  String contactNumber = "";
  String email = "";
  String occasion = "";
  String numberOfGuests = "";
  String preferredDate = "";
  String alternateDate = "";
  String startTime = "";
  String endTime = "";
  bool? exclusiveVenue;
  String? preferredVenueType;
  String? desiredLocationOrArea;
  String? vibeOfEvent;
  String? eventDescription;
  double budgetAmount = 0;
  String additionalRequirements = "";
  String customOccasion = "";
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = context.read<AuthCubit>().state.userId;
  }

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
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          PersonalInfo(
            goToNext: _goToNextPage,
            onFullNameChanged: (value) => fullName = value,
            onContactNumberChanged: (value) => contactNumber = value,
            onEmailChanged: (value) => email = value,
          ),
          EventDetails(
            goToNext: _goToNextPage,
            goToPrevious: _goToPreviousPage,
            onOccasionChanged: (value) => occasion = value,
            onGuestsChanged: (value) => numberOfGuests = value,
            onPreferredDateChanged: (value) => preferredDate = value,
            onAlternateDateChanged: (value) => alternateDate = value,
            onStartTimeChanged: (value) => startTime = value,
            onEndTimeChanged: (value) => endTime = value,
            onCustomOccasionChanged: (value) {
              setState(() {
                customOccasion = value;
              });
            },
          ),
          VenuePreferences(
            goToNext: _goToNextPage,
            goToPrevious: _goToPreviousPage,
            onExclusiveVenueChanged: (value) {
              setState(() {
                exclusiveVenue = value;
              });
            },
            onPreferredVenueTypeChanged: (value) {
              setState(() {
                preferredVenueType = value;
              });
            },
            onDesiredLocationChanged: (value) => desiredLocationOrArea = value,
          ),
          ViewAndAmbiance(
            goToNext: _goToNextPage,
            goToPrevious: _goToPreviousPage,
            onVibeOfEventChanged: (value) {
              setState(() {
                vibeOfEvent = value;
              });
            },
            onEventDescriptionChanged: (value) {
              setState(() {
                eventDescription = value;
              });
            },
          ),
          BudgetScreen(
            goToNext: _goToNextPage,
            goToPrevious: _goToPreviousPage,
            onBudgetAmountChanged: (value) {
              setState(() {
                budgetAmount = value;
              });
            },
          ),
          AdditionalRequirements(
            goToPrevious: _goToPreviousPage,
            userId: userId,
            fullName: fullName,
            contactNumber: contactNumber,
            email: email,
            occasion: occasion,
            numberOfGuests: numberOfGuests,
            preferredDate: preferredDate,
            alternateDate: alternateDate,
            startTime: startTime,
            endTime: endTime,
            exclusiveVenue: exclusiveVenue ?? false,
            preferredVenueType: preferredVenueType ?? '',
            desiredLocationOrArea: desiredLocationOrArea ?? '',
            vibeOfEvent: vibeOfEvent ?? '',
            eventDescription: eventDescription ?? '',
            budgetAmount: budgetAmount,
            onAdditionalRequirementsChanged: (value) {
              setState(() {
                additionalRequirements = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
