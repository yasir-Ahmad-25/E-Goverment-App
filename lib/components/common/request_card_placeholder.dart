import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class RequestCardPlaceholder extends StatelessWidget {
  final String card_title;
  final String card_text;
  final bool showRequestButton;
  const RequestCardPlaceholder({
    super.key,
    required this.card_title,
    required this.card_text,
    required this.showRequestButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      /** Card Widget **/
      child: Card(
        elevation: 25,
        shadowColor: Colors.black,
        color: Colors.white,
        child: SizedBox(
          width: 300,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 70,
                  child: Image.asset(
                    "assets/images/NATIONAL_ID_CARD.jpg",
                  ), //CircleAvatar
                ), //CircleAvatar
                const SizedBox(height: 10), //SizedBox
                Text(
                  // 'Request National ID Card',
                  card_title,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w500,
                  ), //Textstyle
                ), //Text
                const SizedBox(height: 10), //SizedBox
                Text(
                  // 'Muwaadin Hada Dalbo National Id Card Cadeynaya inaa Somali Tahay ?',
                  card_text,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ), //Textstyle
                ), //Text
                const SizedBox(height: 15), //SizedBox
                Center(
                  child: showRequestButton ? RequestButton() : PendingButton(),
                ),
              ],
            ), //Column
          ), //Padding
        ), //SizedBox
      ), //Card
    ); //Center
  }
}

class RequestButton extends StatelessWidget {
  const RequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, 'national_id_card_form');
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.greenAccent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Prevents stretching
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Bootstrap.card_text, color: Colors.black87),
          SizedBox(width: 8),
          Text('Request Now', style: TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}

class PendingButton extends StatelessWidget {
  const PendingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print("Pending");
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.redAccent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Prevents stretching
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Bootstrap.card_text, color: Colors.white),
          SizedBox(width: 8),
          Text('Card Requested', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
