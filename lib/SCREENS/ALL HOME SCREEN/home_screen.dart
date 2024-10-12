import 'package:fiander/COMPONENTS/event_text.dart';
import 'package:fiander/COMPONENTS/join_button.dart';
import 'package:fiander/COMPONENTS/upcoming_events.dart';
import 'package:fiander/CONSTANTS/constants.dart';
import 'package:fiander/DATE_MATHCHING/pairing_logic.dart';
import 'package:fiander/SCREENS/ALL%20HOME%20SCREEN/profile_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../COMPONENTS/FETCHING_USERS_DETAILS/profile_picture.dart';
import 'nav_bar.dart';
import 'settings_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomeScreen1(),
        '/events': (context) => const EventsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/profile': (context) => ProfileScreen(),
      },
      title: 'Sliver Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen1(),
    );
  }
}

class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[270],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 70,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // TODO: Implement menu functionality
              },
            ),
            title: Image.asset('lib/images/fianderlogo.png', height: 40),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_active_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  // TODO: Implement notification functionality
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Avatar$username(),
                const SizedBox(height: 10),
                CarouselSection(),
                EventDateText(),
                AvailableEventsTitle(),
                EventGrid(),
                EventGrid(),
                UpcomingEventsTitle(),
                const WeekendEventList(
                  saturdayTime: '2:00-3:00pm',
                  sundayTime: '4:00-5:00pm',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

class EventRegistrationStatus extends StatelessWidget {
  const EventRegistrationStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("You haven't registered for an event");
  }
}

class CarouselSection extends StatelessWidget {
  final List<String> images = [
    'lib/images/home1.jpeg',
    'lib/images/home2.jpeg',
    'lib/images/home3.jpeg',
  ];

  CarouselSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 16 / 9,
          viewportFraction: 1,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          autoPlay: true,
        ),
        items: images.map((image) {
          return Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text(
                                'Special Valentine Speed Date',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              //there is no space to add the love(heart icon)
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: // Update the button's onPressed callback
                            TextButton(
                          onPressed: () => pairUsers(context),
                          style: TextButton.styleFrom(
                            foregroundColor: TextsInsideButtonColor,
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          child: const Text(
                            'Pair Users',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class EventDateText extends StatelessWidget {
  const EventDateText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 15, top: 5),
      child: Text(
        'Sat and Sundays  2:00 - 5:00pm',
        style: TextStyle(
            color: Colors.black26, //TextsInsideButtonColor,
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
    );
  }
}

class AvailableEventsTitle extends StatelessWidget {
  const AvailableEventsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 30, left: 20),
      child: Text(
        'Available Events',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

class EventGrid extends StatelessWidget {
  const EventGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(alignment: Alignment.topRight, children: [
                  Container(
                    height: 200, // Set the height directly
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('lib/images/event1.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ]),
                const SaturdayEventDateText(eventTime: '2:00 - 3:00pm'),
                JoinButton(),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 200,
                  // Set the height directly
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('lib/images/event2.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SundayEventDateText(eventTime: '4:00 - 5:00pm'),
                JoinButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UpcomingEventsTitle extends StatelessWidget {
  const UpcomingEventsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Upcoming Events',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
