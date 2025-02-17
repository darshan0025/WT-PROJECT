import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildCard('Meet Our Team', [
                _buildInfoRow('Developed by', 'Krish Kachrola (23010101413)'),
                _buildInfoRow('Mentored by', 'Prof. Mehul Bhundiya'),
                _buildInfoRow('Explored by', 'ASWDC, School of Computer Science'),
                _buildInfoRow('Eulogized by', 'Darshan University, Rajkot, Gujarat - INDIA'),
              ]),
              const SizedBox(height: 16),
              _buildCard('About ASWDC', [
                const Text(
                  'ASWDC is an Application, Software, and Website Development Center @ Darshan University. '
                      'It is run by students and staff of the School of Computer Science. '
                      'Its sole purpose is to bridge the gap between university curriculum & industry demands.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Students learn cutting-edge technologies, develop real-world applications, & experience a professional environment under the guidance of industry experts & faculty members.',
                  style: TextStyle(fontSize: 14),
                ),
              ]),
              const SizedBox(height: 16),
              _buildCard('Contact Us', [
                _buildContactRow(Icons.email, 'aswdc@darshan.ac.in', 'mailto:aswdc@darshan.ac.in'),
                _buildContactRow(Icons.phone, '+91-9727747317', 'tel:+919727747317'),
                _buildContactRow(Icons.language, 'www.darshan.ac.in', 'https://www.darshan.ac.in'),
              ]),
              const SizedBox(height: 16),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/matrimony_logo.png', // Update with your actual image path
            width: 100, // Adjust size as needed
            height: 100,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          const Text(
            'Matrimony App',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(content)),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String content, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () => _launchURL(url),
        child: Row(
          children: [
            Icon(icon, color: Colors.pinkAccent),
            const SizedBox(width: 8),
            Text(content, style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Center(
      child: Column(
        children: [
          Text('© 2025 Darshan University', style: TextStyle(fontSize: 12)),
          Text('All Rights Reserved - Privacy Policy', style: TextStyle(fontSize: 12)),
          Text('Made with ❤️ in India', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
