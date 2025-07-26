import 'dart:convert';

import 'package:e_govermenet/components/banner_card.dart';
import 'package:e_govermenet/components/services/api_constants.dart';
import 'package:e_govermenet/screens/service_detailed_page.dart';
import 'package:e_govermenet/screens/service_sectioned_list.dart';
import 'package:e_govermenet/service_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<GovService> _services = [];
  String? _fullName;
  String? _gender;
  String? _userStatus;
  bool _isActive = false;
  bool _isLoading = true;

  // Track selected index
  int _selectedIndex = 0;

  // Update index when an item is tapped
  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on the tapped index
    switch (index) {
      case 0:
        // Navigate to Home
        Navigator.pushNamed(context, 'home_screen');
        break;
      case 1:
        // Navigate to Reports Screen
        Navigator.pushNamed(context, 'taxes');
        break;
      case 2:
        // Navigate to Tax Payment
        Navigator.pushNamed(context, 'help_center');
        break;
      case 3:
        // Navigate to Profile
        // Navigator.pushNamed(context, 'user_profile');
        _logout();
        break;
    }
  }

  // Logout
  Future<void> _logout() async {
    try {
      if (!mounted) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // await http.post(Uri.parse('http://192.168.202.39/Som-Gov/logout'));
      await http.post(Uri.parse(ApiConstants.getLogoutUrl()));

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, 'Login');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  final Map<String, List<ServiceInfo>> serviceSections = {
    'NIRA': [
      ServiceInfo(
        serId: 1,
        title: 'National Id Card',
        description: 'Apply for your National ID card.',
        assetImagePath: 'assets/images/nira_Logo.png',
      ),
    ],
    'Ministry Of Interior': [
      ServiceInfo(
        serId: 2,
        title: 'Passport',
        description: 'Get your passport.',
        assetImagePath: 'assets/images/passport.jpg',
      ),

  ],
    'Ministry Of Transport': [
      ServiceInfo(
        serId: 5,
        title: 'Driver License',
        description: 'Apply for or renew your driver license.',
        assetImagePath: 'assets/images/driver_License.jpg',
      ),
  ],
    'Ministry Of Commerce ': [
      ServiceInfo(
        serId: 4,
        title: 'Business Registration',
        description: 'Register your business legally.',
        assetImagePath: 'assets/images/business.jpg',
      ),
    ],
    'Gobolka Banadir': [
      ServiceInfo(
        serId: 3,
        title: 'Birth Certificate',
        description: 'Request a certified birth certificate.',
        assetImagePath: 'assets/images/birth_certificate.jpg',
      ),
    ],
    // 'Educational Ministry': [
    //   ServiceInfo(
    //     serId: 6,
    //     title: 'Education Certificate',
    //     description: 'Get your education certificate.',
    //     assetImagePath: 'assets/images/nira_Logo.png',
    //   ),
    // ],
  };


  @override
  void initState() {
    super.initState();
    _loadCitizenData();
    _loadServices();
  }

  Future<void> _loadCitizenData() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final citizenId = prefs.getInt('user_id');

      if (citizenId == null) {
        throw Exception("User ID not found in preferences");
      }

      // Fetch citizen data
      final response = await http.get(
        // Uri.parse('http:// 192.168.202.39/egov_back/citizen/$citizenId'),
        Uri.parse(ApiConstants.getCitizenData(citizenId)),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _fullName = data['data']['fullname'];
            _gender = data['data']['gender'];
            _userStatus = data['data']['status'];
            if (_userStatus == 'Active') {
              _isActive = true;
            }

            setState(() {
              _isLoading = false;
            });
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          throw Exception(data['message']);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  Future<void> _loadServices() async {
    try {
      // Fetch services data
      final response = await http.get(
        // Uri.parse('http://192.168.202.39/Som-Gov/services/'),
        Uri.parse(ApiConstants.getServices()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _services = List<GovService>.from(
              data['services'].map((item) => GovService.fromJson(item)),
            );
          });
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("Failed To Fetch Services: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome , $_fullName 🔥", style: TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Bootstrap.arrow_clockwise),
            onPressed: () {
              _loadCitizenData();
              _loadServices();
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BannerCard shimmer
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 12.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // "Services" title shimmer
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8,
                      ),
                      child: Container(
                        width: 100,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),

                    // Grid shimmer (3x2 fake services)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          itemCount: 6,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                          itemBuilder:
                              (_, __) => Column(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    width: 40,
                                    height: 10,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              // : _isActive
              : HomeContent(service: _services,serviceSections: serviceSections,),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        method: _onNavBarItemTapped,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final List<GovService> service;
  final Map<String, List<ServiceInfo>> serviceSections;
  const HomeContent({super.key, required this.service, required this.serviceSections});
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BannerCard(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "Services",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
      
          // Services(services: service),

      
          ServiceSectionedList(
            serviceSections: serviceSections,
            onServiceTap: (service) {
              // Navigate to details or handle tap
              // Example:
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => ServiceDetailPage(service: service),
              ));
            },
          ),
        ],
      ),
    );
  }
}

class PendingUser extends StatelessWidget {
  final String gender;
  final VoidCallback function;
  const PendingUser({super.key, required this.gender, required this.function});

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
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage(
                      // "https://media.geeksforgeeks.org/wp-content/uploads/20210101144014/gfglogo.png",
                      "https://www.ecss-online.com/2013/wp-content/uploads/2022/12/somalia.jpg",
                    ), //NetworkImage
                    radius: 100,
                  ), //CircleAvatar
                ), //CircleAvatar
                const SizedBox(height: 10), //SizedBox
                Text(
                  'Salaan ${(gender == 'Male') ? 'Mudane' : 'Marwo'}',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue[900],
                    fontWeight: FontWeight.w500,
                  ), //Textstyle
                ), //Text
                const SizedBox(height: 10), //SizedBox
                const Text(
                  'Account Sida ugu dhaqsiyaha badan ayaa la xaqiijin doona ? Waaku Mahadsantahay Waqtigaaga.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ), //Textstyle
                ), //Text
                const SizedBox(height: 15), //SizedBox
                Center(
                  child: ElevatedButton(
                    onPressed: function,
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.redAccent,
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Prevents stretching
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Bootstrap.box_arrow_left, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Logout', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ), //Column
          ), //Padding
        ), //SizedBox
      ), //Card
    ); //Center
  }
}

// class Services extends StatelessWidget {
//   final List<GovService> services;
//   const Services({super.key, required this.services});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: GridView.builder(
//           itemCount: services.length,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             mainAxisSpacing: 10,
//             crossAxisSpacing: 10,
//           ),
//           itemBuilder: (context, index) {
//             return ServiceIcon(service: services[index]);
//           },
//         ),
//       ),
//     );
//   }
// }

// class ServiceIcon extends StatelessWidget {
//   final GovService service;
//
//   const ServiceIcon({super.key, required this.service});
//
//   @override
//   Widget build(BuildContext context) {
//     final iconData = getBootstrapIcon(service.serviceIcon);
//     final color = hexToColor(service.colorHex);
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ServiceDetailPage(service: service),
//           ),
//         );
//       },
//       child: Column(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(50),
//               color: color,
//             ),
//             child: Icon(iconData, color: Colors.white),
//           ),
//           SizedBox(height: 5),
//           Text(
//             service.name,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontSize: 13),
//           ),
//         ],
//       ),
//     );
//   }
// }

// NAVIGATION BAR

class BottomBar extends StatelessWidget {
  final int? selectedIndex;
  final Function(int)? method;

  const BottomBar({super.key, this.selectedIndex, this.method});

  @override
  Widget build(BuildContext context) {
    double height = 56;

    const primaryColor = Colors.blue;
    const backgroundColor = Colors.white;

    return BottomAppBar(
      color: backgroundColor,
      elevation: 8, // gives it a little shadow
      child: SizedBox(
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarIcon(
              text: "Home",
              icon: Bootstrap.house,
              selected: selectedIndex == 0,
              onPressed: () => method?.call(0),
              defaultColor: Colors.grey,
              selectedColor: primaryColor,
            ),
            NavBarIcon(
              text: "Taxes",
              icon: Icons.attach_money_rounded,
              selected: selectedIndex == 1,
              onPressed: () => method?.call(1),
              defaultColor: Colors.grey,
              selectedColor: primaryColor,
            ), // space for FAB
            NavBarIcon(
              text: "Help Center",
              icon: Icons.help_rounded,
              selected: selectedIndex == 2,
              onPressed: () => method?.call(2),
              defaultColor: Colors.grey,
              selectedColor: primaryColor,
            ),
            NavBarIcon(
              // text: "Person ",
              text: "Logout",
              icon: FontAwesomeIcons.rightFromBracket,
              selected: selectedIndex == 3,
              onPressed: () => method?.call(3),
              defaultColor: Colors.grey,
              selectedColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavCurvePainter extends CustomPainter {
  BottomNavCurvePainter({
    this.backgroundColor = Colors.black,
    this.insetRadius = 38,
  });

  Color backgroundColor;
  double insetRadius;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 12);

    double insetCurveBeginnningX = size.width / 2 - insetRadius;
    double insetCurveEndX = size.width / 2 + insetRadius;
    double transitionToInsetCurveWidth = size.width * .05;
    path.quadraticBezierTo(
      size.width * 0.20,
      0,
      insetCurveBeginnningX - transitionToInsetCurveWidth,
      0,
    );
    path.quadraticBezierTo(
      insetCurveBeginnningX,
      0,
      insetCurveBeginnningX,
      insetRadius / 2,
    );

    path.arcToPoint(
      Offset(insetCurveEndX, insetRadius / 2),
      radius: const Radius.circular(10.0),
      clockwise: false,
    );

    path.quadraticBezierTo(
      insetCurveEndX,
      0,
      insetCurveEndX + transitionToInsetCurveWidth,
      0,
    );
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 12);
    path.lineTo(size.width, size.height + 56);
    path.lineTo(
      0,
      size.height + 56,
    ); //+56 here extends the navbar below app bar to include extra space on some screens (iphone 11)
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class NavBarIcon extends StatelessWidget {
  const NavBarIcon({
    super.key,
    required this.text,
    required this.icon,
    required this.selected,
    required this.onPressed,
    this.selectedColor = Colors.blue,
    this.defaultColor = Colors.grey,
  });

  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  final Color defaultColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: Icon(
        icon,
        size: 25,
        color: selected ? selectedColor : defaultColor,
      ),
    );
  }
}

class GovService {
  final int serId;
  final String name;
  final String descriptions;
  final double price;
  final String status;
  final String serviceIcon; // <-- add this
  final String colorHex;

  GovService({
    required this.serId,
    required this.name,
    required this.descriptions,
    required this.price,
    required this.status,
    required this.serviceIcon,
    required this.colorHex,
  });

  factory GovService.fromJson(Map<String, dynamic> json) {
    return GovService(
      serId: int.parse(json['ser_id']),
      name: json['name'],
      descriptions: json['descriptions'],
      price: double.parse(json['price']),
      status: json['status'],
      serviceIcon: json['service_icon'], // <-- add this
      colorHex: json['service_bg_color'],
    );
  }
}

IconData getBootstrapIcon(String iconName) {
  switch (iconName) {
    case 'Bootstrap.card_heading':
      return Bootstrap.card_heading;
    case 'Bootstrap.passport':
      return Bootstrap.passport;
    case 'Bootstrap.journal_text':
      return Bootstrap.journal_text;
    case 'Bootstrap.credit_card':
      return Bootstrap.credit_card;
    default:
      return Icons.help_outline; // fallback icon
  }
}

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex'; // add full opacity if missing
  return Color(int.parse(hex, radix: 16));
}



// ============================== added recently ==================

class ServiceCategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl; // Can be a network image or asset image
  final VoidCallback? onTap;

  const ServiceCategoryCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Container(
          padding: EdgeInsets.all(18),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        width: 48,
                        height: 48,
                        color: Colors.grey[200],
                        child: Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                ),
              ),
              SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
