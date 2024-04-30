import "package:easymedhelp_app/components/doctor_card.dart";
import "package:easymedhelp_app/models/auth_model.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class FavouriteDoctorsScreen extends StatefulWidget {
  const FavouriteDoctorsScreen({super.key});

  @override
  State<FavouriteDoctorsScreen> createState() => _FavouriteDoctorsScreenState();
}

class _FavouriteDoctorsScreenState extends State<FavouriteDoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
          children: [
            const Text(
              'Улюблені лікарі',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<AuthModel>(
                builder: (context, auth, child) {
                  return ListView.builder(
                    itemCount: auth.getFavouriteDoctor.length,
                    itemBuilder: (context, index) {
                      return DoctorCard(
                        doctor: auth.getFavouriteDoctor[index],
                        //show fav icon
                        isFavourite: true,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
