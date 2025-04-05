import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:animate_do/animate_do.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _AdvancedProfileSettingsPageState createState() => _AdvancedProfileSettingsPageState();
}

class _AdvancedProfileSettingsPageState extends State<ProfileScreen> {
  final ValueNotifier<bool> _isDarkMode = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isDarkMode,
      builder: (context, isDark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(isDark),
          home: Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(isDark),
                  _buildProfileHeader(isDark),
                  _buildProfileSections(isDark),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ThemeData _buildTheme(bool isDark) {
    final primaryGreen = isDark ? Color(0xFF00693E) : Color(0xFF2E8B57);
    final backgroundColor = isDark ? Color(0xFF121212) : Color(0xFFF0FFF0);
    final surfaceColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryGreen,
        background: backgroundColor,
        surface: surfaceColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(bool isDark) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: false,
      centerTitle: true,
      backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
      title: Text(
        'Profile Settings',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: isDark ? Colors.white : Color(0xFF2E8B57),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isDark ? Ionicons.sunny_outline : Ionicons.moon_outline,
            color: isDark ? Colors.white : Color(0xFF2E8B57),
          ),
          onPressed: () {
            _isDarkMode.value = !_isDarkMode.value;
          },
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildProfileHeader(bool isDark) {
    return SliverToBoxAdapter(
      child: FadeInUp(
        child: GestureDetector(
          onTap: () => _showDetailedPersonalInfoPage(context),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Color(0xFF00693E), Color(0xFF004D40)]
                    : [Color(0xFF2E8B57), Color(0xFF3CB371)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Hero(
                  tag: 'profile_avatar',
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://ui-avatars.com/api/?name=Kazi+Mahbub&background=random',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saurya Tripathi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Premium Member',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Ionicons.chevron_forward_outline,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailedPersonalInfoPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailedPersonalInfoPage(),
      ),
    );
  }

  SliverList _buildProfileSections(bool isDark) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _buildSection(
          context,
          icon: Ionicons.mail_outline,
          title: 'Contact Details',
          isDark: isDark,
          onTap: () => _showContactDetailsBottomSheet(context),
        ),
        _buildSection(
          context,
          icon: Ionicons.lock_closed_outline,
          title: 'Privacy & Security',
          isDark: isDark,
          onTap: () => _showPrivacySettingsBottomSheet(context),
        ),
        _buildSection(
          context,
          icon: Ionicons.log_out_outline,
          title: 'Logout',
          isDark: isDark,
          isDestructive: true,
          onTap: () => _showLogoutConfirmation(context),
        ),
      ]),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required IconData icon,
        required String title,
        required bool isDark,
        required VoidCallback onTap,
        bool isDestructive = false,
      }) {
    return FadeInRight(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isDestructive
                ? Colors.red
                : (isDark ? Colors.white : Color(0xFF2E8B57)),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isDestructive
                  ? Colors.red
                  : (isDark ? Colors.white : Color(0xFF2E8B57)),
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Icon(
            Ionicons.chevron_forward_outline,
            color: isDestructive
                ? Colors.red
                : (isDark ? Colors.white70 : Color(0xFF2E8B57)),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

// Other existing methods remain the same...
}

class DetailedPersonalInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Information'),
        backgroundColor: Color(0xFF2E8B57),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'profile_avatar',
                child: Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(
                      'https://ui-avatars.com/api/?name=Kazi+Mahbub&background=random',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildInfoCard(
                title: 'Personal Details',
                children: [
                  _buildDetailRow('Full Name', 'Kazi Mahbub'),
                  _buildDetailRow('Date of Birth', '20/01/2022'),
                  _buildDetailRow('Gender', 'Male'),
                ],
              ),
              SizedBox(height: 20),
              _buildInfoCard(
                title: 'Contact Information',
                children: [
                  _buildDetailRow('Phone Number', '+90-123456789'),
                  _buildDetailRow('Email', 'abcd1234@email.com'),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Edit profile logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E8B57),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E8B57),
              ),
            ),
            Divider(color: Color(0xFF2E8B57)),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
void _showContactDetailsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: ListView(
          controller: controller,
          children: [
            _buildBottomSheetHeader('Contact Details'),
            _buildInfoTile('Phone Number', '+90-123456789'),
            _buildInfoTile('Email', 'abcd1234@email.com'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Update contact details logic
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Update Contact'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showPrivacySettingsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: ListView(
          controller: controller,
          children: [
            _buildBottomSheetHeader('Privacy & Security'),
            SwitchListTile(
              title: const Text('Two-Factor Authentication'),
              subtitle: const Text('Add an extra layer of security'),
              value: true,
              onChanged: (bool value) {},
              secondary: const Icon(Ionicons.lock_closed_outline),
            ),
            SwitchListTile(
              title: const Text('Profile Visibility'),
              subtitle: const Text('Control who can see your profile'),
              value: false,
              onChanged: (bool value) {},
              secondary: const Icon(Ionicons.eye_outline),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              // Logout logic
              Navigator.of(context).pop();
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  );
}

Widget _buildBottomSheetHeader(String title) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _buildInfoTile(String label, String value) {
  return ListTile(
    title: Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.grey[600],
      ),
    ),
    trailing: Text(
      value,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
