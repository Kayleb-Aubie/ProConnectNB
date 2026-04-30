import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../models/country.dart';
import '../../provider/auth_provider.dart';
import '../../widgets/tr_text.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  bool _isLoadingCountries = true;

  String _selectedCountry = "Canada";
  DateTime _selectedDate = DateTime(1990, 1, 1);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _fetchCountries();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final auth = context.read<AuthProvider>();
      _nameController.text = auth.firstName ?? "";
    });
  }

  Future<void> _fetchCountries() async {
    try {
      final response = await http.get(
        Uri.parse('https://restcountries.com/v3.1/all?fields=name,cca2,flags'),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final countries = data.map((json) => Country.fromJson(json)).toList()
          ..sort((a, b) => a.name.compareTo(b.name));

        setState(() {
          _allCountries = countries;
          _filteredCountries = countries;
          _isLoadingCountries = false;
        });
      } else {
        setState(() {
          _isLoadingCountries = false;
        });
      }
    } catch (e) {
      debugPrint("Erreur API Countries: $e");

      if (!mounted) return;

      setState(() {
        _isLoadingCountries = false;
        _allCountries = [];
        _filteredCountries = [];
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (!mounted) return;

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Erreur image: $e");
    }
  }

  void _showCountryPicker() {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF001F3F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        var modalCountries = List<Country>.from(_filteredCountries);

        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              expand: false,
              builder: (_, scrollController) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search country...",
                          hintStyle: const TextStyle(color: Colors.white38),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white70,
                          ),
                          filled: true,
                          fillColor: Colors.white10,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (val) {
                          setModalState(() {
                            modalCountries = _allCountries
                                .where(
                                  (c) => c.name.toLowerCase().contains(
                                    val.toLowerCase(),
                                  ),
                                )
                                .toList();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: _isLoadingCountries
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: modalCountries.length,
                              itemBuilder: (context, index) {
                                final c = modalCountries[index];

                                return ListTile(
                                  leading: Image.network(
                                    c.flag,
                                    width: 30,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.flag,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    c.name,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: _selectedCountry == c.name
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.blueAccent,
                                        )
                                      : null,
                                  onTap: () {
                                    if (!mounted) return;

                                    setState(() {
                                      _selectedCountry = c.name;
                                    });

                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final auth = context.read<AuthProvider>();

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      if (_image != null) {
        await auth.updateProfilePicture(_image!.path);
      }

      await auth.updateUserInfo(newName: _nameController.text.trim());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TrText("Profil mis à jour"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TrText("Erreur de mise à jour"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF001F3F), Color(0xFF003366)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Center(
                        child: TrText(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white24,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 75,
                                  backgroundColor: Colors.white10,
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: _buildProfileImage(auth),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Color(0xFF001F3F),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        _label("Name"),
                        _input(
                          _nameController,
                          "Melissa Peters",
                          Icons.person_outline,
                        ),
                        _label("Email"),
                        _input(
                          _emailController,
                          "melpeters@gmail.com",
                          Icons.email_outlined,
                        ),
                        _label("Password"),
                        _input(
                          _passwordController,
                          "**********",
                          Icons.lock_outline,
                          obscure: true,
                        ),
                        _label("Date of Birth"),
                        _dropdownTile(
                          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                          Icons.calendar_today,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (!mounted) return;

                            if (picked != null) {
                              setState(() {
                                _selectedDate = picked;
                              });
                            }
                          },
                        ),
                        _label("Country/Region"),
                        _dropdownTile(
                          _selectedCountry,
                          Icons.public,
                          onTap: _showCountryPicker,
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _save,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const TrText(
                                    "Sauvegarder les changements",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: TrText(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController c,
    String hint,
    IconData icon, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: c,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: Colors.black.withOpacity(0.2),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
        ),
      ),
    );
  }

  Widget _dropdownTile(
    String text,
    IconData icon, {
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white70),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(AuthProvider auth) {
    if (_image != null) {
      return Image.file(_image!, fit: BoxFit.cover);
    }

    final imagePath = auth.profilePicture;

    if (imagePath != null && imagePath.isNotEmpty) {
      if (imagePath.startsWith('http')) {
        return Image.network(
          imagePath,
          key: ValueKey(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, size: 80, color: Colors.white),
        );
      }

      return Image.file(
        File(imagePath),
        key: ValueKey(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.person, size: 80, color: Colors.white),
      );
    }

    return Image.asset('images/logoProConnectNB.png', fit: BoxFit.contain);
  }
}
