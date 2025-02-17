import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'mydatabase.dart';



import 'UserListScreen.dart';

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

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Convert hobbies list to a comma-separated string for storage
      String hobbiesString = _newUser['hobbies'].join(',');

      Map<String, dynamic> userToSave = {
        'name': _newUser['name'],
        'email': _newUser['email'],
        'phone': _newUser['phone'],
        'dob': _newUser['dob'],
        'city': _newUser['city'],
        'gender': _newUser['gender'],
        'hobbies': hobbiesString,
        'isFavorite': _newUser['isFavorite'] ? 1 : 0,
      };

      await DatabaseHelper.instance.insertUser(userToSave);

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
