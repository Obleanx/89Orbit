import 'package:fiander/PROVIDERS/harmburger_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HamburgerMenuScreen extends StatelessWidget {
  const HamburgerMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HamburgerMenuProvider(),
      child: Material(
        type: MaterialType.transparency,
        child: Row(
          children: [
            // Menu content
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {}, // Prevents closing when tapping inside menu
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Text(
                            "Choose an event",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // First Option: Tailored
                        Consumer<HamburgerMenuProvider>(
                          builder: (context, provider, child) {
                            return InkWell(
                              onTap: () {
                                provider.toggleTailoredSelected();
                                // Handle "Find Your Spec" tap
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Tailored",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: provider.isTailoredSelected
                                            ? Colors.pink
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: provider.isTailoredSelected
                                        ? Colors.pink
                                        : Colors.black,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 8),
                          child: Text(
                            "Find your spec",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Second Option: General
                        Consumer<HamburgerMenuProvider>(
                          builder: (context, provider, child) {
                            return InkWell(
                              onTap: () {
                                provider.toggleGeneralSelected();
                                // Handle "Find a Quick Match" tap
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "General",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: provider.isGeneralSelected
                                            ? Colors.pink
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: provider.isGeneralSelected
                                        ? Colors.pink
                                        : Colors.black,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 8),
                          child: Text(
                            "Find a quick match",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Transparent area to close menu
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
