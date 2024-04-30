import 'dart:convert';

import 'package:easymedhelp_app/components/button.dart';
import 'package:easymedhelp_app/models/auth_model.dart';
import 'package:easymedhelp_app/providers/dio_provider.dart';
import 'package:easymedhelp_app/utils/configuration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_appbar.dart';

class DoctorDetails extends StatefulWidget {
  const DoctorDetails({
    super.key,
    required this.doctor,
    required this.isFavourite,
  });

  final Map<String, dynamic> doctor;
  final bool isFavourite;

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

String getPathFromUrl(String url) {
  Uri uri = Uri.parse(url);
  return uri.path;
}

class _DoctorDetailsState extends State<DoctorDetails> {
  double averageRating = 0.0;
  late Map<String, dynamic> doctor;
  late bool isFavourite;

  @override
  void initState() {
    doctor = widget.doctor;
    isFavourite = widget.isFavourite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'Про лікаря',
        icon: const FaIcon(Icons.arrow_back_ios),
        actions: [
          IconButton(
            onPressed: _toggleFavorite,
            icon: FaIcon(
              isFavourite ? Icons.favorite : Icons.favorite_outline,
              color: isFavourite ? Colors.red : null,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: DoctorAvatar(doctor['doctor_profile']),
            ),
            const SizedBox(height: 20),
            DoctorInfo(doctor),
            const SizedBox(height: 20),
            Button(
              disabled: false,
              width: double.infinity,
              title: 'Записатися на прийом',
              onPressed: _navigateToBookingScreen,
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite() async {
    final list = Provider.of<AuthModel>(context, listen: false).getFavourite;
    if (list.contains(doctor['doctor_id'])) {
      list.removeWhere((id) => id == doctor['doctor_id']);
    } else {
      list.add(doctor['doctor_id']);
    }

    Provider.of<AuthModel>(context, listen: false).setFavouriteList(list);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isNotEmpty && token != '') {
      final response = await DioProvider().storeFavouriteDoctor(token, list);
      if (response == 200) {
        setState(() {
          isFavourite = !isFavourite;
        });
      }
    }
  }

  void _navigateToBookingScreen() {
    Navigator.of(context).pushNamed(
      'booking_screen',
      arguments: {"doctor_id": doctor['doctor_id']},
    );
  }
}

class DoctorAvatar extends StatelessWidget {
  const DoctorAvatar(this.profileUrl);

  final String profileUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 65,
      backgroundImage: NetworkImage(profileUrl),
      backgroundColor: const Color.fromARGB(255, 118, 8, 8),
    );
  }
}

class DoctorInfo extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const DoctorInfo(this.doctor, {super.key});

  @override
  _DoctorInfoState createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  double? averageRating;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctorReviews();
  }

  Future<void> fetchDoctorReviews() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    try {
      dynamic jsonResponse = await DioProvider().getReviews(token);
      List<dynamic> reviews = jsonDecode(jsonResponse)['reviews'];
      List<dynamic> filteredReviews = reviews
          .where((review) =>
              review['doctor_id'].toString() == widget.doctor['id'].toString())
          .toList();

      if (filteredReviews.isNotEmpty) {
        List<int> ratings = filteredReviews
            .map<int>((review) => int.parse(review['ratings'].toString()))
            .toList();
        double calculatedAverage =
            ratings.reduce((a, b) => a + b) / ratings.length;
        setState(() {
          averageRating = calculatedAverage;
          isLoading = false;
        });
      } else {
        setState(() {
          averageRating = 0.0;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching reviews: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 20),
          _buildAttributes(),
          const SizedBox(height: 20),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      title: Text(
        widget.doctor['doctor_name'],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      subtitle: Text(
        '${widget.doctor['category']}',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.medical_services_outlined, size: 30),
    );
  }

  Widget _buildAttributes() {
    return Wrap(
      spacing: 10, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: <Widget>[
        _buildChip('Досвід', '${widget.doctor['experience']} років',
            FontAwesomeIcons.clock),
        _buildChip(
            'Пацієнти', '${widget.doctor['patients']}', FontAwesomeIcons.users),
        isLoading
            ? const CircularProgressIndicator()
            : _buildChip(
                'Оцінка',
                averageRating?.toStringAsFixed(1) ?? "Немає оцінок",
                FontAwesomeIcons.star),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Про лікаря:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.doctor['bio_data'],
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String value, IconData icon) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(icon, color: EasyMedHelpConfiguration.primaryColor),
      ),
      side: const BorderSide(color: EasyMedHelpConfiguration.primaryColor),
      label:
          Text('$label: $value', style: const TextStyle(color: Colors.white)),
      backgroundColor: EasyMedHelpConfiguration.primaryColor,
      padding: const EdgeInsets.all(8),
    );
  }
}
