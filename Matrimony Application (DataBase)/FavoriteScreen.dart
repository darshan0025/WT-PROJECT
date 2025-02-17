import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'mydatabase.dart';

class FavoriteUserScreen extends StatefulWidget {
  @override
  _FavoriteUserScreenState createState() => _FavoriteUserScreenState();
}

class _FavoriteUserScreenState extends State<FavoriteUserScreen> {
  List<Map<String, dynamic>> favoriteUsers = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteUsers();
  }

  Future<void> _loadFavoriteUsers() async {
    final db = await DatabaseHelper.instance.database;
    final users = await db.query('users', where: 'isFavorite = ?', whereArgs: [1]);
    setState(() {
      favoriteUsers = users;
    });
  }

  Future<void> _removeFromFavorites(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'users',
      {'isFavorite': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadFavoriteUsers();
  }

  Future<void> _deleteUser(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
    _loadFavoriteUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Users'),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: favoriteUsers.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        itemCount: favoriteUsers.length,
        itemBuilder: (context, index) {
          final user = favoriteUsers[index];
          return Dismissible(
            key: Key(user['id'].toString()),
            direction: DismissDirection.endToStart,
            background: _buildDeleteBackground(),
            onDismissed: (direction) => _deleteUser(user['id']),
            child: _buildUserCard(user),
          );
        },
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.pinkAccent,
          child: Text(
            user['name'][0].toUpperCase(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        title: Text(
          user['name'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(user['email'], style: TextStyle(color: Colors.grey.shade600)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () => _removeFromFavorites(user['id']),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteUser(user['id']),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.redAccent,
      child: const Icon(Icons.delete, color: Colors.white, size: 30),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.pinkAccent),
          const SizedBox(height: 20),
          Text(
            'No favorite users found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
