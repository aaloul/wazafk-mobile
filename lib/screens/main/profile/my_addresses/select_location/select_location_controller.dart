import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wazafak_app/constants/route_constant.dart';
import 'package:wazafak_app/model/AddressesResponse.dart';

class SelectLocationController extends GetxController {
  GoogleMapController? mapController;

  var selectedPosition = Rxn<LatLng>();
  var currentPosition = Rxn<LatLng>();
  var isLoading = false.obs;
  var marker = Rxn<Marker>();

  Address? editAddress;

  @override
  void onInit() {
    super.onInit();

    // Check if we're in edit mode with existing address
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map && arguments['address'] != null) {
      editAddress = arguments['address'] as Address;
      _loadExistingLocation();
    } else {
      _getCurrentLocation();
    }
  }

  void _loadExistingLocation() {
    try {
      isLoading.value = true;

      if (editAddress?.latitude != null && editAddress?.longitude != null) {
        final lat = double.tryParse(editAddress!.latitude!) ?? 0.0;
        final lng = double.tryParse(editAddress!.longitude!) ?? 0.0;

        if (lat != 0.0 && lng != 0.0) {
          final position = LatLng(lat, lng);
          currentPosition.value = position;
          selectedPosition.value = position;
          _updateMarker(position);

          // Move camera to existing location
          if (mapController != null) {
            mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(position, 15),
            );
          }
        } else {
          _getCurrentLocation();
        }
      } else {
        _getCurrentLocation();
      }
    } catch (e) {
      print('Error loading existing location: $e');
      _getCurrentLocation();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      isLoading.value = true;

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isLoading.value = false;
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        isLoading.value = false;
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition.value = LatLng(position.latitude, position.longitude);
      selectedPosition.value = LatLng(position.latitude, position.longitude);

      // Update marker
      _updateMarker(LatLng(position.latitude, position.longitude));

      // Move camera to current location
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            15,
          ),
        );
      }
    } catch (e) {
      print('Error getting current location: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Move camera to current location if available
    if (currentPosition.value != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition.value!, 15),
      );
    }
  }

  void onMapTap(LatLng position) {
    selectedPosition.value = position;
    _updateMarker(position);

    // Move camera to tapped location
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(position));
    }
  }

  void _updateMarker(LatLng position) {
    marker.value = Marker(
      markerId: const MarkerId('selected_location'),
      position: position,
      draggable: true,
      onDragEnd: (newPosition) {
        selectedPosition.value = newPosition;
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }

  void saveLocation() {
    if (selectedPosition.value != null) {
      final addArguments = {
        'latitude': selectedPosition.value!.latitude,
        'longitude': selectedPosition.value!.longitude,
      };

      final editArguments = {
        'latitude': selectedPosition.value!.latitude,
        'longitude': selectedPosition.value!.longitude,
        'address': editAddress,
      };

      // If editing, include the address data
      if (editAddress != null) {
        Get.toNamed(RouteConstant.addAddressScreen, arguments: editArguments);
      } else {
        Get.toNamed(RouteConstant.addAddressScreen, arguments: addArguments);
      }
    }
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}
