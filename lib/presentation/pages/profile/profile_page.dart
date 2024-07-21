import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/navigation_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<NavigationProvider>(context, listen: false)
                .resetToHome(); 
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text('Profile Page Content'),
      ),
    );
  }
}
