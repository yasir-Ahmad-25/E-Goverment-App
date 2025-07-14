import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatelessWidget {
  final String supportNumber = "+252610000000";

  const HelpCenterScreen({super.key});

  Future<void> _launchPhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: supportNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $supportNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help Center"),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // 📞 Call Us Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.indigo.shade50,
              child: ListTile(
                leading: Icon(Icons.call, color: Colors.indigo, size: 30),
                title: Text(
                  "Call Us",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(supportNumber),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.indigo,
                ),
                onTap: _launchPhoneCall,
              ),
            ),
            SizedBox(height: 20),

            // 💬 FAQ Section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Frequently Asked Questions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            ExpansionTile(
              leading: Icon(Icons.help_outline),
              title: Text("How can I pay my tax online?"),
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "You can pay your tax through the 'Tax Payment' section on your dashboard.",
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.account_circle),
              title: Text("How do I update my personal info?"),
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Go to 'Profile' and click on 'Edit'. Make your changes and save.",
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: Icon(Icons.email_outlined),
              title: Text("I did not receive a payment receipt."),
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Please contact support by phone or email with your transaction ID.",
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // 📧 Contact Us by Email Placeholder
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.email, color: Colors.deepOrange),
                title: Text("Need more help?"),
                subtitle: Text("support@egovtax.gov.so"),
                onTap: () {
                  // Future: launch email or open email form
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
