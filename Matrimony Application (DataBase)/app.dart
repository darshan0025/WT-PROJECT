import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matrimony App',
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _heartbeatController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _heartbeatAnimation;

  @override
  void initState() {
    super.initState();

    // Fade Animation for text and logo
    _fadeController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    // Scale Animation for logo
    _scaleController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );

    // Heartbeat Animation
    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _heartbeatAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _heartbeatController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _fadeController.forward();
    _scaleController.forward();

    // Navigate to Dashboard after animation
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MatrimonyDashboard()),
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _heartbeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.white], // Smooth romantic gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset('assets/images/matrimony_logo.png', width: 150, height: 150), // Your logo
                ),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    "Find Your Perfect Match",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                ),
                const SizedBox(height: 30),

                // Animated Heart Icon
                AnimatedBuilder(
                  animation: _heartbeatAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _heartbeatAnimation.value,
                      child: const Icon(Icons.favorite, color: Colors.red, size: 50),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
















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



















class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _dateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> _cities = ['Morbi', 'Rajkot', 'Gondal', 'Jamnagar', 'Junaghadh'];
  final List<String> _hobbies = ['Reading', 'Traveling', 'Gaming', 'Music', 'Sports'];

  final Map<String, dynamic> _newUser = {
    'name': '',
    'email': '',
    'phone': '',
    'dob': '',
    'city': 'Morbi',
    'gender': 'Male',
    'hobbies': [],
    'isFavorite': false,
  };

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime minAllowedDate = DateTime(today.year - 80, today.month, today.day);
    DateTime maxAllowedDate = DateTime(today.year - 18, today.month, today.day);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: maxAllowedDate,
      firstDate: minAllowedDate,
      lastDate: maxAllowedDate,
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
        _newUser['dob'] = formattedDate;
      });
    }
  }

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        UserListScreen.users.add(Map<String, dynamic>.from(_newUser));
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User added successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Add User'),
        backgroundColor: Colors.pinkAccent,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    'Full Name',
                    'Enter your full name',
                    Icons.person,
                        (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'Enter a valid full name (min 3 characters)';
                      }
                      if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                        return 'Only letters and spaces are allowed';
                      }
                      return null;
                    },
                        (value) => _newUser['name'] = value,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), // Allow only letters and spaces
                    ],
                  ),


                  const SizedBox(height: 15),

                  _buildTextField('Email', 'Enter your email', Icons.email, (value) {
                    if (value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  }, (value) => _newUser['email'] = value),

                  const SizedBox(height: 15),

                  _buildTextField(
                    'Mobile Number',
                    'Enter your phone number',
                    Icons.phone,
                        (value) {
                      if (value == null || !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                        (value) => _newUser['phone'] = value,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,  // Only allow digits
                      LengthLimitingTextInputFormatter(10),    // Restrict input to 10 digits
                    ],
                  ),


                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: "Select Date of Birth",
                      prefixIcon: const Icon(Icons.calendar_today, color: Colors.pinkAccent),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    readOnly: true,
                    onTap: () => _pickDate(context),
                  ),

                  const SizedBox(height: 15),

                  _buildDropdown('City', Icons.location_city, _cities, (value) => _newUser['city'] = value),

                  const SizedBox(height: 15),

                  _buildDropdown('Gender', Icons.wc, ['Male', 'Female', 'Other'], (value) => _newUser['gender'] = value),

                  const SizedBox(height: 15),

                  _buildHobbies(),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _saveUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save User', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      IconData icon,
      FormFieldValidator<String> validator,
      FormFieldSetter<String> onSaved, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,  // <-- Add this parameter
      }) {
    return TextFormField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters, // <-- Pass input formatters here
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.pinkAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }


  Widget _buildDropdown(String label, IconData icon, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pinkAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      value: items.first,
      items: items.map((String item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildHobbies() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hobbies", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ..._hobbies.map((hobby) => CheckboxListTile(
              title: Text(hobby),
              value: _newUser['hobbies'].contains(hobby),
              activeColor: Colors.pinkAccent,
              onChanged: (bool? selected) {
                setState(() {
                  if (selected == true) {
                    _newUser['hobbies'].add(hobby);
                  } else {
                    _newUser['hobbies'].remove(hobby);
                  }
                });
              },
            )),
          ],
        ),
      ),
    );
  }
}






















class UserListScreen extends StatefulWidget {
  static final List<Map<String, dynamic>> users = [
    {
      'name': 'John Doe',
      'email': 'john@example.com',
      'phone': '9876543210',
      'dob': '12/03/1990',
      'city': 'New York',
      'gender': 'Male',
      'hobbies': ['Reading', 'Music'],
      'isFavorite': false,
    },
    {
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'phone': '8765432109',
      'dob': '25/07/1995',
      'city': 'Los Angeles',
      'gender': 'Female',
      'hobbies': ['Traveling', 'Gaming'],
      'isFavorite': true,
    },
    {
      'name': 'Alice Johnson',
      'email': 'alice@example.com',
      'phone': '7654321098',
      'dob': '15/06/1992',
      'city': 'Chicago',
      'gender': 'Female',
      'hobbies': ['Sports', 'Reading'],
      'isFavorite': false,
    },
    {
      'name': 'Bob Brown',
      'email': 'bob@example.com',
      'phone': '6543210987',
      'dob': '03/09/1988',
      'city': 'Houston',
      'gender': 'Male',
      'hobbies': ['Gaming', 'Music'],
      'isFavorite': true,
    },
    {
      'name': 'Charlie Davis',
      'email': 'charlie@example.com',
      'phone': '5432109876',
      'dob': '08/11/1993',
      'city': 'San Francisco',
      'gender': 'Male',
      'hobbies': ['Traveling', 'Sports'],
      'isFavorite': false,
    },
  ];

  @override
  _UserListScreenState createState() => _UserListScreenState();
}


class _UserListScreenState extends State<UserListScreen> {
  String searchQuery = "";
  String searchCategory = "Name";
  final List<String> _searchCategories = [
    'Name',
    'Email',
    'City',
    'Gender',
    'Hobby'
  ];
  final List<String> _hobbies = [
    'Reading',
    'Traveling',
    'Gaming',
    'Music',
    'Sports'
  ];

  void _toggleFavorite(int index) {
    setState(() {
      UserListScreen.users[index]['isFavorite'] =
      !UserListScreen.users[index]['isFavorite'];
    });
  }

  void _deleteUser(int index) {
    setState(() {
      UserListScreen.users.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User deleted successfully")),
    );
  }

  void _editUser(int index) {
    final user = UserListScreen.users[index];

    TextEditingController nameController = TextEditingController(
        text: user['name']);
    TextEditingController emailController = TextEditingController(
        text: user['email']);
    TextEditingController phoneController = TextEditingController(
        text: user['phone']);
    TextEditingController dobController = TextEditingController(
        text: user['dob']);
    TextEditingController cityController = TextEditingController(
        text: user['city']);
    String gender = user['gender'];

    // Create a local copy of hobbies to modify
    Map<String, bool> selectedHobbies = {
      for (var hobby in _hobbies) hobby: user['hobbies'].contains(hobby),
    };

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Edit User'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(
                          labelText: 'Mobile Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.length != 10) {
                          return 'Enter a valid 10-digit phone number';
                        }
                        return null;
                      },

                    ),
                    TextField(
                      controller: dobController,
                      decoration: const InputDecoration(
                          labelText: 'Date of Birth (DD/MM/YYYY)'),
                    ),
                    TextField(
                      controller: cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                    DropdownButtonFormField(
                      value: gender,
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text(
                            'Female')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        gender = value.toString();
                      },
                      decoration: const InputDecoration(labelText: 'Gender'),
                    ),
                    const SizedBox(height: 10),
                    const Text('Hobbies'),
                    Column(
                      children: _hobbies.map((hobby) {
                        return CheckboxListTile(
                          title: Text(hobby),
                          value: selectedHobbies[hobby],
                          onChanged: (bool? value) {
                            setDialogState(() {
                              selectedHobbies[hobby] = value!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      UserListScreen.users[index] = {
                        'name': nameController.text,
                        'email': emailController.text,
                        'phone': phoneController.text,
                        'dob': dobController.text,
                        'city': cityController.text,
                        'gender': gender,
                        'hobbies': selectedHobbies.entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key)
                            .toList(),
                        'isFavorite': user['isFavorite'],
                      };
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> getFilteredUsers() {
    return UserListScreen.users.where((user) {
      switch (searchCategory) {
        case "Email":
          return user['email'].toLowerCase().contains(
              searchQuery.toLowerCase());
        case "City":
          return user['city'].toLowerCase().contains(searchQuery.toLowerCase());
        case "Gender":
          return user['gender'].toLowerCase() == searchQuery.toLowerCase();
        case "Hobby":
          return (user['hobbies'] as List)
              .map((hobby) => hobby.toString().toLowerCase())
              .any((hobby) => hobby.contains(searchQuery.toLowerCase()));

        default:
          return user['name'].toLowerCase().contains(searchQuery.toLowerCase());
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Use the getFilteredUsers method to filter based on the search category and query
    final filteredUsers = getFilteredUsers();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
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
              onTap: () { // Open profile when tapping anywhere
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(user: user),
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
                  // Text('Email: ${user['email']}'),
                  // Text('Phone: ${user['phone']}'),
                  Text('DOB: ${user['dob']}'),
                  Text('City: ${user['city']}'),
                  Text('Gender: ${user['gender']}'),
                  // Text('Hobbies: ${user['hobbies'].join(", ")}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      user['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                      color: user['isFavorite'] ? Colors.red : null,
                    ),
                    onPressed: () => _toggleFavorite(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editUser(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteUser(index),
                  ),
                ],
              ),
            ),

          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddUserScreen()));
        },
        child: const Icon(Icons.add, color: Colors.pink,),
      ),
    );
  }
}



























class FavoriteUserScreen extends StatefulWidget {
  @override
  _FavoriteUserScreenState createState() => _FavoriteUserScreenState();
}

class _FavoriteUserScreenState extends State<FavoriteUserScreen> {
  void _removeFromFavorites(int index) {
    setState(() {
      UserListScreen.users[index]['isFavorite'] = false;
    });
  }

  void _deleteUser(int index) {
    setState(() {
      UserListScreen.users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteUsers =
    UserListScreen.users.where((user) => user['isFavorite']).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Users'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: favoriteUsers.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: favoriteUsers.length,
        itemBuilder: (context, index) {
          final user = favoriteUsers[index];
          final originalIndex = UserListScreen.users
              .indexWhere((u) => u['email'] == user['email']);

          return Dismissible(
            key: Key(user['email']),
            direction: DismissDirection.endToStart,
            background: _buildDeleteBackground(),
            onDismissed: (direction) => _deleteUser(originalIndex),
            child: _buildUserCard(user, originalIndex),
          );
        },
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user, int originalIndex) {
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
              onPressed: () => _removeFromFavorites(originalIndex),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteUser(originalIndex),
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





























class UserProfileScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50, // Soft pink background
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.pinkAccent,
                          child: Text(
                            user['name'][0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildUserInfo(Icons.person, 'Name', user['name']),
                    _buildUserInfo(Icons.email, 'Email', user['email']),
                    _buildUserInfo(Icons.phone, 'Phone', user['phone']),
                    _buildUserInfo(Icons.calendar_today, 'Date of Birth', user['dob']),
                    _buildUserInfo(Icons.location_city, 'City', user['city']),
                    _buildUserInfo(Icons.wc, 'Gender', user['gender']),
                    _buildUserInfo(Icons.favorite, 'Hobbies', user['hobbies'].join(", ")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.pinkAccent),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

