import 'package:fiander/CONSTANTS/constants.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sliver Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen1(),
    );
  }
}

class HomeScreen1 extends StatelessWidget {
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
                UserWelcome(),
                const SizedBox(height: 10),
                CarouselSection(),
                EventDateText(),
                AvailableEventsTitle(),
                EventGrid(),
                EventGrid(),
                UpcomingEventsTitle(),
                const UpcomingEventCard(
                  date: 'Saturday, April 13th',
                  time: '2:00-3:00pm',
                ),
                const SizedBox(height: 20),
                const UpcomingEventCard(
                  date: 'Sunday, April 14th',
                  time: '4:00-5:00pm',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}

class UserWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            // backgroundImage: NetworkImage('https://example.com/user_image.jpg'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Aligns text to the start of the Column

              children: [
                const Text(
                  'Hi! Welcome back..John Doe',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                EventRegistrationStatus(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventRegistrationStatus extends StatelessWidget {
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
                        child: TextButton(
                          onPressed: () {
                            // Handle button press
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: TextsInsideButtonColor,
                            backgroundColor:
                                Colors.white, // Ensure transparent background
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          child: const Text(
                            'Join',
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
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 15, top: 5),
      child: Text(
        'Sat, Feb 14, 2:00 - 3:00pm',
        style: TextStyle(
            color: TextsInsideButtonColor,
            fontWeight: FontWeight.bold,
            fontSize: 12),
      ),
    );
  }
}

class AvailableEventsTitle extends StatelessWidget {
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
                EventDateText(),
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
                EventDateText(),
                JoinButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class JoinButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: TextsInsideButtonColor, // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Curved edges
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        minimumSize: Size(100, 30),
// Padding
      ),
      child: const Text(
        'Join Event',
        style: TextStyle(
          color: Colors.white, // Text color
          fontWeight: FontWeight.bold, // Text weight
        ),
      ),
    );
  }
}

class UpcomingEventsTitle extends StatelessWidget {
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

class UpcomingEventCard extends StatelessWidget {
  final String date;
  final String time;

  const UpcomingEventCard({Key? key, required this.date, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xff9e9e9e), // Set the border color to grey
          width: 1, // Set the border width
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.event,
                    color: TextsInsideButtonColor, size: 24),
                const SizedBox(width: 8),
                Expanded(child: Text(date)),
                const Spacer(),
                const Icon(Icons.access_time_outlined,
                    color: TextsInsideButtonColor, size: 24),
                const SizedBox(width: 8),
                Text(time),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement button functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TextsInsideButtonColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: const Size(100, 30),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        // TODO: Implement navigation functionality
        print('Tapped on tab $index');
      },
    );
  }
}
