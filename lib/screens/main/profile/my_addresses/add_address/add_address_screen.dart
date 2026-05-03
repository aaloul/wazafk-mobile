import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wazafak_app/components/primary_button.dart';
import 'package:wazafak_app/components/primary_text.dart';
import 'package:wazafak_app/components/progress_bar.dart';
import 'package:wazafak_app/components/top_header.dart';
import 'package:wazafak_app/utils/res/AppContextExtension.dart';
import 'package:wazafak_app/utils/res/Resources.dart';

import '../../../../../components/labeled_text_field.dart';
import 'add_address_controller.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key});

  static const _cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(12)),
    border: Border.fromBorderSide(
      BorderSide(color: Color(0xFFE5E5E5), width: 1),
    ),
    boxShadow: [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 12,
        offset: Offset(0, 4),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddAddressController());

    final lat = double.tryParse(controller.latitude) ?? 0.0;
    final lng = double.tryParse(controller.longitude) ?? 0.0;
    final hasLocation = lat != 0.0 || lng != 0.0;

    return Scaffold(
      backgroundColor: context.resources.color.background2,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => TopHeader(
                hasBack: true,
                title: controller.isEditMode.value
                    ? Resources.of(context).strings.editAddress
                    : Resources.of(context).strings.addAddress,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small map preview
                    if (hasLocation) ...[
                      SizedBox(height: 8,),

                      PrimaryText(text: Resources.of(context).strings.locationPin, fontWeight: FontWeight.w600, fontSize: 14,),
                      SizedBox(height: 8,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: 155,
                          child: AbsorbPointer(
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(lat, lng),
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId('selected'),
                                  position: LatLng(lat, lng),
                                ),
                              },
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              scrollGesturesEnabled: false,
                              zoomGesturesEnabled: false,
                              rotateGesturesEnabled: false,
                              tiltGesturesEnabled: false,
                              liteModeEnabled: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Fields card
                    Container(
                      width: double.infinity,
                      decoration: _cardDecoration,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        children: [
                          LabeledTextFiled(
                            controller: controller.labelController,
                            hint: Resources.of(context).strings.label,
                            label: Resources.of(context).strings.label,
                            isMandatory: true,
                            isPassword: false,
                            inputType: TextInputType.text,
                          ),
                          LabeledTextFiled(
                            controller: controller.addressController,
                            hint: Resources.of(context).strings.address,
                            label: Resources.of(context).strings.address,
                            isMandatory: true,
                            isPassword: false,
                            inputType: TextInputType.text,
                          ),
                          LabeledTextFiled(
                            controller: controller.cityController,
                            hint: Resources.of(context).strings.city,
                            label: Resources.of(context).strings.city,
                            isMandatory: true,
                            isPassword: false,
                            inputType: TextInputType.text,
                          ),
                          LabeledTextFiled(
                            controller: controller.streetController,
                            hint: Resources.of(context).strings.street,
                            label: Resources.of(context).strings.street,
                            isMandatory: true,
                            isPassword: false,
                            inputType: TextInputType.text,
                          ),
                          LabeledTextFiled(
                            controller: controller.buildingController,
                            hint: Resources.of(context).strings.building,
                            label: Resources.of(context).strings.building,
                            isMandatory: true,
                            isPassword: false,
                            inputType: TextInputType.text,
                          ),
                          LabeledTextFiled(
                            controller: controller.apartmentController,
                            hint: Resources.of(context).strings.apartment,
                            label: Resources.of(context).strings.apartment,
                            isMandatory: true,
                            isPassword: false,
                            inputType: TextInputType.text,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            Obx(
              () => controller.isLoading.value
                  ? const ProgressBar()
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: PrimaryButton(
                        title: controller.isEditMode.value
                            ? Resources.of(context).strings.saveAddress
                            : Resources.of(context).strings.addAddress,
                        onPressed: () => controller.saveAddress(),
                      ),
                    ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
