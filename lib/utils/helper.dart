import 'package:flutter/material.dart';

final List<String> hospitalTypes = [
  "Multi-Specialty Hospital",
  "General Hospital",
  "Super Specialty Hospital",
  "Clinic",
  "Diagnostic Center",
];

// Selected facilities
final Map<String, bool> facilities = {
  'Emergency': true,
  'ICU': true,
  'Pharmacy': true,
  'Laboratory': true,
  'X-Ray': true,
  'CT Scan': false,
  'MRI': false,
  'Operation Theater': true,
  'Blood Bank': false,
  'Ambulance': true,
  'Parking': true,
  'Cafeteria': true,
  'WiFi': true,
  'Wheelchair': true,
};

// Departments
final Map<String, bool> departments = {
  'Cardiology': true,
  'Neurology': true,
  'Orthopedics': true,
  'Pediatrics': true,
  'Gynecology': false,
  'Dermatology': false,
  'ENT': true,
  'Ophthalmology': false,
  'Dentistry': false,
  'General Surgery': true,
  'Psychiatry': false,
  'Radiology': true,
};

// Working Hours
final Map<String, Map<String, dynamic>> workingHours = {
  'Monday': {'isOpen': true, 'start': '08:00', 'end': '20:00'},
  'Tuesday': {'isOpen': true, 'start': '08:00', 'end': '20:00'},
  'Wednesday': {'isOpen': true, 'start': '08:00', 'end': '20:00'},
  'Thursday': {'isOpen': true, 'start': '08:00', 'end': '20:00'},
  'Friday': {'isOpen': true, 'start': '08:00', 'end': '20:00'},
  'Saturday': {'isOpen': true, 'start': '08:00', 'end': '14:00'},
  'Sunday': {'isOpen': false, 'start': '08:00', 'end': '14:00'},
};

IconData getFacilityIcon(String name) {
  switch (name.toLowerCase()) {
    case 'icu':
      return Icons.monitor_heart;
    case 'emergency':
      return Icons.emergency;
    case 'pharmacy':
      return Icons.local_pharmacy;
    case 'ambulance':
      return Icons.local_shipping;
    case 'laboratory':
      return Icons.science;
    case 'radiology':
      return Icons.medical_services;
    default:
      return Icons.local_hospital;
  }
}

IconData getDepartmentIconFromName(String name) {
  switch (name.toLowerCase()) {
    case 'cardiology':
      return Icons.favorite;
    case 'neurology':
      return Icons.psychology;
    case 'orthopedics':
      return Icons.accessibility_new;
    case 'pediatrics':
      return Icons.child_care;
    case 'dermatology':
      return Icons.spa;
    default:
      return Icons.local_hospital;
  }
}

// Indian Cities by State (sample - you can expand this)
final Map<String, List<String>> indianCities = {
  "Maharashtra": ["Mumbai", "Pune", "Nagpur", "Nashik", "Aurangabad", "Thane", "Solapur", "Saoner"],
  "Karnataka": ["Bangalore", "Mysore", "Mangalore", "Hubli", "Belgaum", "Gulbarga"],
  "Tamil Nadu": ["Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem", "Tirunelveli"],
  "Delhi": ["New Delhi", "North Delhi", "South Delhi", "East Delhi", "West Delhi"],
  "Gujarat": ["Ahmedabad", "Surat", "Vadodara", "Rajkot", "Bhavnagar", "Jamnagar"],
  "Rajasthan": ["Jaipur", "Jodhpur", "Udaipur", "Kota", "Bikaner", "Ajmer"],
  "Uttar Pradesh": ["Lucknow", "Kanpur", "Ghaziabad", "Agra", "Varanasi", "Meerut", "Prayagraj"],
  "West Bengal": ["Kolkata", "Howrah", "Durgapur", "Asansol", "Siliguri"],
  "Telangana": ["Hyderabad", "Warangal", "Nizamabad", "Khammam", "Karimnagar"],
  "Andhra Pradesh": ["Visakhapatnam", "Vijayawada", "Guntur", "Nellore", "Tirupati"],
  "Kerala": ["Thiruvananthapuram", "Kochi", "Kozhikode", "Thrissur", "Kollam"],
  "Madhya Pradesh": ["Bhopal", "Indore", "Gwalior", "Jabalpur", "Ujjain"],
  "Bihar": ["Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Purnia"],
  "Punjab": ["Chandigarh", "Ludhiana", "Amritsar", "Jalandhar", "Patiala"],
  "Haryana": ["Gurugram", "Faridabad", "Panipat", "Ambala", "Karnal"],
  // Add more states and cities as needed
};

// Indian States
final List<String> indianStates = [
  "Andhra Pradesh",
  "Arunachal Pradesh",
  "Assam",
  "Bihar",
  "Chhattisgarh",
  "Goa",
  "Gujarat",
  "Haryana",
  "Himachal Pradesh",
  "Jharkhand",
  "Karnataka",
  "Kerala",
  "Madhya Pradesh",
  "Maharashtra",
  "Manipur",
  "Meghalaya",
  "Mizoram",
  "Nagaland",
  "Odisha",
  "Punjab",
  "Rajasthan",
  "Sikkim",
  "Tamil Nadu",
  "Telangana",
  "Tripura",
  "Uttar Pradesh",
  "Uttarakhand",
  "West Bengal",
];