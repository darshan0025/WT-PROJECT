import 'package:flutter/material.dart';
import 'AddUserScreen.dart';
import 'UserListScreen.dart';
import 'FavoriteScreen.dart';
import 'AboutusScreen.dart';

class MatrimonyDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        elevation: 4,
        title: const Text(
          '💖 Matrimony App 💖',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Pink Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.white], // Pink Gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '💍 Find Your Perfect Match!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(blurRadius: 2, color: Colors.black26, offset: Offset(1, 1))
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      MatrimonyCard(
                          title: 'Add User',
                          icon: Icons.person_add,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddUserScreen()))),
                      MatrimonyCard(
                          title: 'User List',
                          icon: Icons.list,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserListScreen()))),
                      MatrimonyCard(
                          title: 'Favorite Users',
                          icon: Icons.favorite,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FavoriteUserScreen()))),
                      MatrimonyCard(
                          title: 'About Us',
                          icon: Icons.info,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUsScreen()))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MatrimonyCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MatrimonyCard({required this.title, required this.icon, required this.onTap});

  @override
  _MatrimonyCardState createState() => _MatrimonyCardState();
}

class _MatrimonyCardState extends State<MatrimonyCard> {
  bool _isHovered = false;
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isTapped = true),
        onTapUp: (_) {
          setState(() => _isTapped = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isTapped = false),
        child: AnimatedScale(
          scale: _isTapped ? 0.95 : (_isHovered ? 1.05 : 1.0),
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: _isHovered ? 0.9 : 1.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _isHovered ? Colors.pinkAccent : Colors.pink,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pinkAccent,
                    blurRadius: _isHovered ? 15 : 8,
                    spreadRadius: 1,
                  )
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, size: 50, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

