import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  static const bg = Color(0xFFE9DFD1); // Background color
  static final onBg = Colors.brown.shade900;

  Future<void> _open(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "Could not launch $uri";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text("Contact Us", style: TextStyle(color: onBg)),
        centerTitle: true,
        iconTheme: IconThemeData(color: onBg),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- EAHE Conference Contact ---
          Text("EAHE Conference", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onBg)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text("Mariam.Emad@foldergroup.com"),
            subtitle: const Text("For registration & inquiries"),
            onTap: () => _open(Uri.parse("mailto:Mariam.Emad@foldergroup.com")),
          ),
          ListTile(
            leading: const Icon(Icons.phone_outlined),
            title: const Text("+20 12 87199405"),
            onTap: () => _open(Uri.parse("tel:+201287199405")),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text("eahe.xyz"),
            onTap: () => _open(Uri.parse("https://eahe.xyz/")),
          ),
          ListTile(
            leading: const Icon(Icons.facebook_outlined),
            title: const Text("Facebook"),
            onTap: () => _open(Uri.parse("https://www.facebook.com/profile.php?id=100084085962107")),
          ),
          ListTile(
            leading: const Icon(Icons.linked_camera_outlined), // LinkedIn icon not in Material
            title: const Text("LinkedIn"),
            onTap: () => _open(Uri.parse("https://www.linkedin.com/company/eahe/posts/?feedView=all")),
          ),

          const Divider(height: 32, thickness: 1),

          // --- Folder Group (Organizer) ---
          Text("Organized by Folder Group", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: onBg)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text("info@foldergroup.com"),
            onTap: () => _open(Uri.parse("mailto:info@foldergroup.com")),
          ),
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: const Text("foldergroup.com"),
            onTap: () => _open(Uri.parse("https://foldergroup.com/")),
          ),
          ListTile(
            leading: const Icon(Icons.facebook_outlined),
            title: const Text("Facebook"),
            onTap: () => _open(Uri.parse("https://www.facebook.com/share/171eccWGqs/?mibextid=wwXIfr")),
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email_outlined),
            title: const Text("Twitter / X"),
            onTap: () => _open(Uri.parse("https://x.com/FOLDERmiddleast")),
          ),
          ListTile(
            leading: const Icon(Icons.linked_camera_outlined),
            title: const Text("LinkedIn"),
            onTap: () => _open(Uri.parse("https://www.linkedin.com/company/folder-group")),
          ),
        ],
      ),
    );
  }
}
