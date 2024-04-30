import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  const SocialButton(
      {super.key,
      required this.social // Assuming you handle the onPressed outside and pass it in
      });

  final String social;

  @override
  Widget build(BuildContext context) {
    // Assuming EasyMedHelpConfiguration.init(context) has been called at a higher level

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        side: const BorderSide(
            width: 1, color: EasyMedHelpConfiguration.backgroundColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor:
            Colors.white, // Optional: Use social media color for fill
      ),
      onPressed: () {},
      child: SizedBox(
        width: EasyMedHelpConfiguration.widthSize * 0.3,
        height: 40, // Ensure height is sufficient for the icon
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center align the items
          children: <Widget>[
            Image.asset(
              'assets/$social.png', // Use the specific social media icon
              width: 24, // A typical size for icons
              height: 24,
            ),
            const SizedBox(width: 10), // Space between icon and text
            Text(
              social.toUpperCase(),
              style: const TextStyle(
                // Use the specific social media color for text
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
