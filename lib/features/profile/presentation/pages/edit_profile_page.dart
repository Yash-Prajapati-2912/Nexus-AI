import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/location_service.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _timezoneController;
  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    _cityController = TextEditingController();
    _countryController = TextEditingController();
    _timezoneController = TextEditingController();

    final initialState = context.read<ProfileBloc>().state;
    if (initialState is ProfileLoadedState) {
      _populateControllers(initialState.profile);
    }
  }

  void _populateControllers(UserProfile user) {
    if (!_initialized) {
      _nameController.text = user.displayName;
      _usernameController.text = user.username;
      _phoneController.text = user.phone ?? '';
      _bioController.text = user.bio ?? '';
      _cityController.text = user.city ?? '';
      _countryController.text = user.country ?? '';
      _timezoneController.text = user.timezone;
      _selectedGender = user.gender;
      _selectedDateOfBirth = user.dateOfBirth;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  Future<void> _autoDetectTimezone() async {
    final tz = await LocationService.requestLocationAndTimezone(context);
    if (tz != null && mounted) {
      setState(() {
        _timezoneController.text = tz;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission granted! Timezone set to $tz')),
      );
    }
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final initialDate = _selectedDateOfBirth ?? DateTime(now.year - 20, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  void _saveProfile() {
    final payload = <String, dynamic>{
      'displayName': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'bio': _bioController.text.trim(),
      'city': _cityController.text.trim(),
      'country': _countryController.text.trim(),
      'timezone': _timezoneController.text.trim(),
      if (_selectedGender != null) 'gender': _selectedGender,
      if (_selectedDateOfBirth != null)
        'dateOfBirth': _selectedDateOfBirth!.toIso8601String().split('T').first,
    };

    bool isUpdating = false;

    context.read<ProfileBloc>().add(UpdateUserProfileEvent(payload));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoadedState) {
          _populateControllers(state.profile);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        } else if (state is ProfileFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update profile: ${state.message}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: _saveProfile,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  prefixIcon: Icon(Icons.person_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDateOfBirth,
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.cake_rounded),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _selectedDateOfBirth != null
                        ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                        : 'Select Date of Birth',
                    style: TextStyle(
                      color: _selectedDateOfBirth != null
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.face_rounded),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'MALE', child: Text('Male')),
                  DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                  DropdownMenuItem(value: 'PREFER_NOT_TO_SAY', child: Text('Prefer not to say')),
                ],
                onChanged: (val) => setState(() => _selectedGender = val),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  prefixIcon: Icon(Icons.location_city_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  prefixIcon: Icon(Icons.flag_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _timezoneController,
                decoration: InputDecoration(
                  labelText: 'Timezone',
                  prefixIcon: const Icon(Icons.access_time_rounded),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.my_location_rounded),
                    tooltip: 'Auto-detect Location & Timezone',
                    onPressed: _autoDetectTimezone,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  prefixIcon: Icon(Icons.description_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
