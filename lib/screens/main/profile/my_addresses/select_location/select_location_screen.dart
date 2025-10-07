import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';

import 'select_location_controller.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SelectLocationController());

    return Scaffold(
      backgroundColor: context.resources.color.background,
      body: SafeArea(
        child: Column(
          children: [
            TopHeader(hasBack: true, title: 'Select Location'),
            Expanded(
              child: Obx(
                () => controller.isLoading.value
                    ? Center(child: ProgressBar())
                    : Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target:
                                  controller.currentPosition.value ??
                                  const LatLng(0, 0),
                              zoom: 15,
                            ),
                            onMapCreated: controller.onMapCreated,
                            onTap: controller.onMapTap,
                            markers: controller.marker.value != null
                                ? {controller.marker.value!}
                                : {},
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            compassEnabled: false,
                            mapToolbarEnabled: false,
                          ),
                          if (controller.selectedPosition.value != null)
                            Positioned(
                              top: 16,
                              left: 16,
                              right: 16,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected Location',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: context
                                            .resources
                                            .color
                                            .colorPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Lat: ${controller.selectedPosition.value!.latitude.toStringAsFixed(6)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: context
                                            .resources
                                            .color
                                            .colorPrimary,
                                      ),
                                    ),
                                    Text(
                                      'Lng: ${controller.selectedPosition.value!.longitude.toStringAsFixed(6)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: context
                                            .resources
                                            .color
                                            .colorPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          Positioned(
                            bottom: 20,
                            right: 20,
                            left: 20,
                            child: PrimaryButton(
                              title: "Confirm",
                              onPressed: controller.saveLocation,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
