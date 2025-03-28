import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'location_service/location_service.dart';
import '../../map/map_screen.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  _PickLocationScreenState createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  final LocationService _locationService = LocationService();
  String? _currentAddress;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _fetchStoredLocation();
  }
  Future<void> _fetchStoredLocation() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      return;
    }

    final response =
        await supabase
            .from('users')
            .select('location')
            .eq('id', userId)
            .single();

    if (response['location'] != null) {
      setState(() {
        _currentAddress = response['location'];
      });
    } else {
      _requestLocationPermission(); 
    }
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await _locationService.checkLocationService();
    if (!serviceEnabled) {
      _showLocationDialog();
      return;
    }

    geo.LocationPermission permission =
        await _locationService.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await _locationService.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        _showPermissionDeniedDialog();
        return;
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      _showPermissionDeniedDialog();
      return;
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isFetching = true);

    var position = await _locationService.getCurrentPosition();
    if (position != null) {
      String? address = await _locationService.getAddressFromCoordinates(
        position,
      );

      setState(() {
        _currentAddress = address;
      });

      await _updateUserLocation(position.latitude, position.longitude);
    } else {
      setState(() {
        _currentAddress = "Failed to get location";
      });
    }

    setState(() => _isFetching = false);
  }

  Future<void> _updateUserLocation(double latitude, double longitude) async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      return;
    }

    final locationString = "$latitude, $longitude";

    try {
      await supabase
          .from('users')
          .update({'location': locationString})
          .eq('id', userId);
    } catch (e) {
      print("Error storing location: $e");
      _showErrorDialog("Failed to store location. Please try again.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Enable Location"),
            content: Text(
              "Location services are disabled. Please enable them.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Permission Denied"),
            content: Text(
              "Location permission is required. Please enable it in settings.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
    );
  }

  void _goBack() {
    Navigator.pop(context, _currentAddress);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double padding = size.width * 0.03;
    double fontSize = size.width * 0.05;

    return Scaffold(
      backgroundColor: const Color(0xff090D14),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding * 1.6),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: _goBack,
                  child: SvgPicture.asset("assets/sign_up_assets/back.svg"),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Text(
                "Pick Location",
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontSize: fontSize * 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Text(
                "Our recommendation depends on your search result",
                style: GoogleFonts.urbanist(
                  color: Colors.white70,
                  fontSize: fontSize * 0.8,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: padding * 1.5),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xff202938)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: InkWell(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => MapScreen(),
                            ),
                          );
                          if (result != null &&
                              result is Map<String, dynamic>) {
                            LatLng? location = result['currentLocation'];
                            if (location != null) {
                              String? address = await _locationService
                                  .getAddressFromCoordinates(
                                    geo.Position(
                                      latitude: location.latitude,
                                      longitude: location.longitude,
                                      accuracy: 1,
                                      altitude: 0,
                                      heading: 0,
                                      speed: 0,
                                      speedAccuracy: 0,
                                      timestamp: DateTime.now(),
                                      altitudeAccuracy: 0.0,
                                      headingAccuracy: 0.0,
                                    ),
                                  );

                              setState(() {
                                _currentAddress = address;
                              });
                              await _updateUserLocation(
                                location.latitude,
                                location.longitude,
                              );
                            }
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add, color: Colors.white),
                            SizedBox(width: size.width * 0.03),
                            Text(
                              "Add address",
                              style: GoogleFonts.urbanist(
                                color: Colors.white,
                                fontSize: fontSize * 0.9,
                              ),
                            ),
                            Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white54,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Color(0xff202938)),
                    GestureDetector(
                      onTap: _getCurrentLocation,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: padding),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/home_assets/location.svg",
                              height: 24,
                              width: 24,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: padding),
                            Expanded(
                              child: Text(
                                _isFetching
                                    ? "Fetching location..."
                                    : _currentAddress ??
                                        "Use your current location",
                                style: GoogleFonts.urbanist(
                                  color: Colors.white54,
                                  fontSize: fontSize * 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
