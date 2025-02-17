import 'package:flutter/material.dart';
import 'AddUserScreen.dart';
import 'UserProfileScreen.dart';
import 'mydatabase.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> users = [];
  String searchQuery = "";
  String searchCategory = "Name";
  final List<String> _searchCategories = ['Name', 'Email', 'City', 'Gender', 'Hobby'];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final dbUsers = await DatabaseHelper.instance.getUsers();
    setState(() {
      users = dbUsers;
    });
  }

  Future<void> _deleteUser(int id) async {
    await DatabaseHelper.instance.deleteUser(id);
    _loadUsers();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User deleted successfully")),
    );
  }

  Future<void> _toggleFavorite(int id, int index) async {
    final newFavoriteStatus = users[index]['isFavorite'] == 1 ? 0 : 1;
    await DatabaseHelper.instance.updateUser({
      'id': id,
      'isFavorite': newFavoriteStatus,
    });
    _loadUsers();
  }

  List<Map<String, dynamic>> getFilteredUsers() {
    return users.where((user) {
      switch (searchCategory) {
        case "Email":
          return user['email'].toLowerCase().contains(searchQuery.toLowerCase());
        case "City":
          return user['city'].toLowerCase().contains(searchQuery.toLowerCase());
        case "Gender":
          return user['gender'].toLowerCase() == searchQuery.toLowerCase();
        case "Hobby":
          return (user['hobbies'] ?? "").toString().toLowerCase().contains(searchQuery.toLowerCase());
        default:
          return user['name'].toLowerCase().contains(searchQuery.toLowerCase());
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = getFilteredUsers();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        backgroundColor: Colors.pinkAccent,
        actions: [
          DropdownButton<String>(
            value: searchCategory,
            onChanged: (String? newValue) {
              setState(() {
                searchCategory = newValue!;
              });
            },
            items: _searchCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: 200,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: filteredUsers.isEmpty
          ? const Center(
        child: Text(
          'No users found',
          style: TextStyle(color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(userId: user['id']),
                  ),
                );
              },
              title: Text(
                user['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DOB: ${user['dob']}'),
                  Text('City: ${user['city']}'),
                  Text('Gender: ${user['gender']}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      user['isFavorite'] == 1 ? Icons.favorite : Icons.favorite_border,
                      color: user['isFavorite'] == 1 ? Colors.red : null,
                    ),
                    onPressed: () => _toggleFavorite(user['id'], index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(user['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => AddUserScreen()));
          _loadUsers(); // Refresh list after adding new user
        },
        child: const Icon(Icons.add, color: Colors.pink),
      ),
    );
  }
}
