import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/authentication_provider.dart';
import '../../theme/theme.dart';
import '../../utils/helper.dart';
import '../../widgets/loading_overlay.dart';

class EditHospitalProfileScreen extends StatefulWidget {
  const EditHospitalProfileScreen({super.key});

  @override
  State<EditHospitalProfileScreen> createState() =>
      _EditHospitalProfileScreenState();
}

class _EditHospitalProfileScreenState extends State<EditHospitalProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _hospitalNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipController = TextEditingController();
  final _totalBedsController = TextEditingController();
  final _icuBedsController = TextEditingController();
  final _emergencyBedsController = TextEditingController();

  File? _coverImageFile;
  List<File> _hospitalImages = [];
  final ImagePicker _imagePicker = ImagePicker();

  // Hospital Type & Services
  String? _selectedType;
  String? _selectedState;
  String? _selectedCity;
  bool _is24x7 = false;
  bool _hasEmergency = true;
  bool _isVerified = true;

  // Accreditations
  final List<TextEditingController> _accreditationControllers = [];
  List<String> accreditations = [];

  bool _isSaving = false;
  bool _isUploadingImage = false;
  bool _cancelUpload = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  void _loadCurrentData() {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    final hospital = authProvider.hospital;
    _hospitalNameController.text = hospital!.displayName;
    _emailController.text = hospital.email ?? "Email";
    _phoneController.text = hospital.phoneNumber ?? "Phone Number";
    _emergencyPhoneController.text =
        hospital.emergencyPhoneNumber ?? "";
    _websiteController.text = hospital.website ?? "";
    _descriptionController.text = hospital.description ?? "";
    _addressController.text = hospital.address ?? "";
    _selectedCity = hospital.city;
    _selectedState = hospital.state;
    _zipController.text = hospital.zip ?? "";
    _totalBedsController.text = hospital.bedCount.toString();
    _icuBedsController.text = hospital.icuBedCount.toString();
    _emergencyBedsController.text = hospital.emergencyBedCount.toString();
    _selectedType = hospital.type;
    _is24x7 = hospital.is24x7 ?? false;
    _hasEmergency = hospital.hasEmergency ?? true;
    _isVerified = hospital.isVerified ?? true;

    accreditations = [""];
    for (var acc in accreditations) {
      _accreditationControllers.add(TextEditingController(text: acc));
    }
  }

  @override
  void dispose() {
    _hospitalNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyPhoneController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _zipController.dispose();
    _totalBedsController.dispose();
    _icuBedsController.dispose();
    _emergencyBedsController.dispose();
    for (var controller in _accreditationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickFromCamera() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _coverImageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _coverImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      throw Exception('Failed to select image: $e');
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      final pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 70,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _hospitalImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select images: $e')),
      );
    }
  }

  void _removeHospitalImage(int index) {
    setState(() {
      _hospitalImages.removeAt(index);
    });
  }

  void _addAccreditation() {
    setState(() {
      _accreditationControllers.add(TextEditingController());
    });
  }

  void _removeAccreditation(int index) {
    setState(() {
      _accreditationControllers[index].dispose();
      _accreditationControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Edit Hospital Profile",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Photo Section
                  _buildCoverPhotoSection(context, isDarkMode),
                  const SizedBox(height: 32),

                  // Hospital Images Gallery
                  _buildSectionTitle(context, "Hospital Images", Icons.photo_library),
                  const SizedBox(height: 16),
                  _buildHospitalImagesSection(isDarkMode),
                  const SizedBox(height: 32),

                  // Basic Information
                  _buildSectionTitle(context, "Basic Information", Icons.info),
                  const SizedBox(height: 16),
                  _buildBasicInfoSection(isDarkMode),
                  const SizedBox(height: 32),

                  // Location
                  _buildSectionTitle(context, "Location", Icons.location_on),
                  const SizedBox(height: 16),
                  _buildLocationSection(isDarkMode, isMobile),
                  const SizedBox(height: 32),

                  // Contact Information
                  _buildSectionTitle(
                    context,
                    "Contact Information",
                    Icons.contact_phone,
                  ),
                  const SizedBox(height: 16),
                  _buildContactSection(isDarkMode, isMobile),
                  const SizedBox(height: 32),

                  // Accreditations & Certifications
                  _buildSectionTitle(
                    context,
                    "Accreditations & Certifications",
                    Icons.verified,
                  ),
                  const SizedBox(height: 16),
                  _buildAccreditationsSection(isDarkMode),
                  const SizedBox(height: 32),

                  // Capacity Information
                  _buildSectionTitle(
                    context,
                    "Capacity Information",
                    Icons.hotel,
                  ),
                  const SizedBox(height: 16),
                  _buildCapacitySection(isDarkMode),
                  const SizedBox(height: 32),

                  // Departments
                  _buildSectionTitle(context, "Departments", Icons.apartment),
                  const SizedBox(height: 16),
                  _buildDepartmentsSection(isDarkMode),
                  const SizedBox(height: 32),

                  // Facilities & Services
                  _buildSectionTitle(
                    context,
                    "Facilities & Services",
                    Icons.medical_services,
                  ),
                  const SizedBox(height: 16),
                  _buildFacilitiesSection(isDarkMode),
                  const SizedBox(height: 32),

                  // Working Hours
                  _buildSectionTitle(
                    context,
                    "Working Hours",
                    Icons.access_time,
                  ),
                  const SizedBox(height: 16),
                  _buildWorkingHoursSection(isDarkMode),
                  const SizedBox(height: 32),

                  // Settings
                  _buildSectionTitle(context, "Settings", Icons.settings),
                  const SizedBox(height: 16),
                  _buildSettingsSection(isDarkMode),
                  const SizedBox(height: 40),

                  // Save Button
                  _buildSaveButton(isDarkMode),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        if (_isUploadingImage || _isSaving)
          LoadingOverlay(
            isDarkMode: isDarkMode,
            isUploadingImage: _isUploadingImage,
          ),
      ],
    );
  }

  Widget _buildCoverPhotoSection(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[800]
                    : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              child: _coverImageFile != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _coverImageFile!,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(
                Icons.image,
                size: 60,
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: FloatingActionButton.small(
                onPressed: () {
                  _showImagePickerOptions(context, "cover", isDarkMode);
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          "Cover Photo",
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalImagesSection(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Hospital Photos",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          if (_hospitalImages.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: _hospitalImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _hospitalImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTap: () => _removeHospitalImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _pickMultipleImages,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text("Add Images"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(bool isDarkMode) {
    return Column(
      children: [
        _buildTextField(
          controller: _hospitalNameController,
          label: "Hospital Name",
          icon: Icons.local_hospital,
          isDarkMode: isDarkMode,
          validator: _requiredValidator,
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: "Hospital Type",
          value: _selectedType,
          items: hospitalTypes,
          icon: Icons.category,
          isDarkMode: isDarkMode,
          onChanged: (value) {
            setState(() => _selectedType = value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select hospital type";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _descriptionController,
          label: "About Hospital",
          icon: Icons.description,
          isDarkMode: isDarkMode,
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildLocationSection(bool isDarkMode, bool isMobile) {
    return Column(
      children: [
        _buildTextField(
          controller: _addressController,
          label: "Street Address",
          icon: Icons.home,
          isDarkMode: isDarkMode,
          validator: _requiredValidator,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                label: "State",
                value: _selectedState,
                items: indianStates,
                icon: Icons.map,
                isDarkMode: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _selectedState = value;
                    _selectedCity = null; // Reset city when state changes
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select state";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdown(
                label: "City",
                value: _selectedCity,
                items: _selectedState != null
                    ? (indianCities[_selectedState] ?? [])
                    : [],
                icon: Icons.location_city,
                isDarkMode: isDarkMode,
                onChanged: (value) {
                  setState(() => _selectedCity = value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select city";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _zipController,
          label: "PIN Code",
          icon: Icons.pin,
          keyboardType: TextInputType.number,
          isDarkMode: isDarkMode,
          validator: _requiredValidator,
        ),
      ],
    );
  }

  Widget _buildContactSection(bool isDarkMode, bool isMobile) {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          label: "Email Address",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          isDarkMode: isDarkMode,
          validator: _emailValidator,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _phoneController,
                label: "Phone Number",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                isDarkMode: isDarkMode,
                validator: _requiredValidator,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _emergencyPhoneController,
                label: "Emergency Phone",
                icon: Icons.emergency,
                keyboardType: TextInputType.phone,
                isDarkMode: isDarkMode,
                validator: _requiredValidator,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _websiteController,
          label: "Website",
          icon: Icons.language,
          keyboardType: TextInputType.url,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildAccreditationsSection(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Accreditations & Certifications",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _accreditationControllers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _accreditationControllers[index],
                        decoration: InputDecoration(
                          labelText: "Accreditation ${index + 1}",
                          prefixIcon: const Icon(Icons.verified),
                          filled: true,
                          fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _removeAccreditation(index),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _addAccreditation,
              icon: const Icon(Icons.add),
              label: const Text("Add Accreditation"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacitySection(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: _totalBedsController,
            label: "Total Beds",
            icon: Icons.hotel,
            keyboardType: TextInputType.number,
            isDarkMode: isDarkMode,
            validator: _numberValidator,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextField(
            controller: _icuBedsController,
            label: "ICU Beds",
            icon: Icons.local_hospital,
            keyboardType: TextInputType.number,
            isDarkMode: isDarkMode,
            validator: _numberValidator,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextField(
            controller: _emergencyBedsController,
            label: "Emergency Beds",
            icon: Icons.emergency,
            keyboardType: TextInputType.number,
            isDarkMode: isDarkMode,
            validator: _numberValidator,
          ),
        ),
      ],
    );
  }

  Widget _buildDepartmentsSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Available Departments",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: departments.keys.map((dept) {
              return FilterChip(
                label: Text(dept),
                selected: departments[dept]!,
                onSelected: (selected) {
                  setState(() {
                    departments[dept] = selected;
                  });
                },
                selectedColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.2),
                checkmarkColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: departments[dept]!
                      ? Theme.of(context).primaryColor
                      : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilitiesSection(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Available Facilities",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: facilities.keys.map((facility) {
              return FilterChip(
                label: Text(facility),
                selected: facilities[facility]!,
                onSelected: (selected) {
                  setState(() {
                    facilities[facility] = selected;
                  });
                },
                selectedColor: Theme.of(
                  context,
                ).primaryColor.withValues(alpha: 0.2),
                checkmarkColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: facilities[facility]!
                      ? Theme.of(context).primaryColor
                      : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHoursSection(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Operating Hours",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              Row(
                children: [
                  Text(
                    "24/7",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _is24x7,
                    onChanged: (value) {
                      setState(() {
                        _is24x7 = value;
                        if (value) {
                          // Set all days to open
                          workingHours.forEach((key, value) {
                            value['isOpen'] = true;
                          });
                        }
                      });
                    },
                    activeThumbColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!_is24x7)
            ...workingHours.keys.map((day) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          Checkbox(
                            value: workingHours[day]!['isOpen'],
                            onChanged: (value) {
                              setState(() {
                                workingHours[day]!['isOpen'] = value!;
                              });
                            },
                            activeColor: Theme.of(context).primaryColor,
                          ),
                          Text(
                            day.substring(0, 3),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: workingHours[day]!['isOpen']
                                  ? (isDarkMode
                                  ? Colors.white
                                  : Colors.grey[800])
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (workingHours[day]!['isOpen']) ...[
                      Expanded(
                        child: Text(
                          "${workingHours[day]!['start']} - ${workingHours[day]!['end']}",
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () {
                          // TODO: Show time picker dialog
                        },
                      ),
                    ] else
                      Expanded(
                        child: Text(
                          "Closed",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            })
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  Text(
                    "Hospital operates 24 hours, 7 days a week",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          _buildSettingToggle(
            "Emergency Services Available",
            _hasEmergency,
            Icons.emergency,
                (value) {
              setState(() => _hasEmergency = value);
            },
            isDarkMode,
          ),
          const Divider(height: 32),
          _buildSettingToggle(
            "Verified Hospital",
            _isVerified,
            Icons.verified,
                (value) {
              setState(() => _isVerified = value);
            },
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingToggle(
      String title,
      bool value,
      IconData icon,
      Function(bool) onChanged,
      bool isDarkMode,
      ) {
    return Row(
      children: [
        Icon(icon, color: value ? Theme.of(context).primaryColor : Colors.grey),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDarkMode,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required bool isDarkMode,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      hint: const Text("Select Hospital Type"),
      isExpanded: true,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSaveButton(bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSaving
            ? null
            : () {
          if (_formKey.currentState!.validate()) {
            _saveHospitalProfile();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode
              ? DarkThemeColors.buttonPrimary
              : LightThemeColors.buttonPrimary,
          disabledBackgroundColor: isDarkMode
              ? DarkThemeColors.textDisabled
              : LightThemeColors.textDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: _isSaving
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.save, size: 24, color: Colors.black),
            const SizedBox(width: 12),
            Text(
              "Save Changes",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions(
      BuildContext context,
      String type,
      bool isDarkMode,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Choose Cover Photo",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                _buildImageOption(
                  context,
                  Icons.camera_alt,
                  "Take Photo",
                  isDarkMode,
                      () {
                    Navigator.pop(context);
                    _pickFromCamera();
                  },
                ),
                const SizedBox(height: 12),
                _buildImageOption(
                  context,
                  Icons.photo_library,
                  "Choose from Gallery",
                  isDarkMode,
                      () {
                    Navigator.pop(context);
                    _pickFromGallery();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageOption(
      BuildContext context,
      IconData icon,
      String label,
      bool isDarkMode,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // Validators
  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!value.contains('@') || !value.contains('.')) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    if (int.tryParse(value) == null) {
      return "Enter a valid number";
    }
    return null;
  }

  Future<void> _saveHospitalProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    setState(() => _isSaving = true);

    try {
      String? uploadedImageUrl;
      if (_coverImageFile != null) {
        _cancelUpload = false;
        setState(() => _isUploadingImage = true);

        try {
          final result = await authProvider.uploadProfileImage(
            _coverImageFile!,
          );

          if (_cancelUpload) {
            setState(() {
              _isUploadingImage = false;
              _isSaving = false;
            });
            return;
          }

          uploadedImageUrl = result;
        } catch (e) {
          if (!_cancelUpload) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to upload profile picture")),
            );
          }

          setState(() {
            _isUploadingImage = false;
            _isSaving = false;
          });
          return;
        } finally {
          if (mounted) {
            setState(() => _isUploadingImage = false);
          }
        }
      }

      final facilitiesList = facilities.entries
          .where((e) => e.value == true)
          .map((e) => e.key)
          .toList();
      final selectedDepartments = departments.entries
          .where((e) => e.value == true)
          .map((e) => e.key)
          .toList();

      // Get accreditations from controllers
      final accreditationsList = _accreditationControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final Map<String, dynamic> updateData = {
        'hospitalName': _hospitalNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'website': _websiteController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _selectedCity,
        'state': _selectedState,
        'zip': _zipController.text.trim(),
        'description': _descriptionController.text.trim(),
        'bedCount': int.tryParse(_totalBedsController.text.trim()),
        'icuBedCount': int.tryParse(_icuBedsController.text.trim()),
        'emergencyBedCount': int.tryParse(_emergencyBedsController.text.trim()),
        'hasEmergency': _hasEmergency,
        'isVerified': _isVerified,
        'departments': selectedDepartments,
        'facilities': facilitiesList,
        'operatingHours': workingHours,
        'is24x7': _is24x7,
        'type': _selectedType,
        'accreditations': accreditationsList,
        'emergencyPhoneNumber': _emergencyPhoneController.text.trim().isEmpty
            ? null
            : _emergencyPhoneController.text.trim(),
      };
      if (uploadedImageUrl != null) {
        updateData['coverPhoto'] = uploadedImageUrl;
      }

      // TODO: Handle hospital images upload
      // if (_hospitalImages.isNotEmpty) {
      //   List<String> uploadedImageUrls = [];
      //   for (var image in _hospitalImages) {
      //     final url = await authProvider.uploadImage(image);
      //     uploadedImageUrls.add(url);
      //   }
      //   updateData['hospitalImages'] = uploadedImageUrls;
      // }

      final success = await authProvider.updateProfile(updateData);
      await authProvider.fetchUserProfile();

      if (!mounted) return;

      setState(() => _isSaving = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  "Profile updated successfully!",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    authProvider.error ?? 'Failed to update profile',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'An error occurred: ${e.toString()}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}


