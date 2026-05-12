import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pashboi/core/extensions/app_context.dart';
import 'package:pashboi/features/authenticated/payment/domain/entities/service_entity.dart';
import 'package:pashboi/features/authenticated/payment/presentation/pages/payment_page/sections/pay_to_section/bloc/payment_service_bloc.dart';
import 'package:pashboi/shared/widgets/app_dropdown_select.dart';

class PayToSection extends StatefulWidget {
  final String? serviceError;
  final String? notifyPersonError;

  final String? selectedServiceId;
  final void Function(String?) onServiceChanged;

  final String? notifyPerson;
  final void Function(String?) onNotifyPersonChanged;

  const PayToSection({
    super.key,
    required this.serviceError,
    required this.notifyPersonError,
    required this.selectedServiceId,
    required this.onServiceChanged,
    required this.notifyPerson,
    required this.onNotifyPersonChanged,
  });

  @override
  State<PayToSection> createState() => _PayToSectionState();
}

class _PayToSectionState extends State<PayToSection> {
  ServiceEntity? _selectedService;

  @override
  void initState() {
    super.initState();
    // Load services when this section is built
    context.read<PaymentServiceBloc>().add(FetchPaymentServicesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border.all(color: colorScheme.primary),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Center(
              child: Text(
                Locales.string(context, 'pay_to'),
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Form Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<PaymentServiceBloc, PaymentServiceState>(
              builder: (context, state) {
                if (state is PaymentServiceLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PaymentServiceError) {
                  return Center(child: Text(state.message));
                }

                if (state is PaymentServiceLoaded) {
                  final services = state.services;

                  // map ServiceEntity → DropdownMenuItem
                  final serviceItems =
                      services
                          .map(
                            (service) => DropdownMenuItem<String>(
                              value: service.id.toString(),
                              child: Text(service.serviceName),
                            ),
                          )
                          .toList();

                  // pick current service
                  _selectedService = services.firstWhere(
                    (s) => s.id.toString() == widget.selectedServiceId,
                    orElse: () => services.first,
                  );

                  final notifyPersonItems =
                      _selectedService?.notifyPersons
                          .map(
                            (service) => DropdownMenuItem<String>(
                              value: service.id.toString(),
                              child: Text(service.fullName),
                            ),
                          )
                          .toList() ??
                      [];

                  return Column(
                    children: [
                      const SizedBox(height: 5),

                      // ✅ Service Name Dropdown
                      AppDropdownSelect(
                        label: Locales.string(context, 'service_name'),
                        value: widget.selectedServiceId,
                        items: serviceItems,
                        onChanged: (val) {
                          widget.onServiceChanged(val);
                          setState(() {
                            _selectedService = services.firstWhere(
                              (s) => s.id.toString() == val,
                              orElse: () => services.first,
                            );
                          });
                        },
                        prefixIcon: FontAwesomeIcons.briefcase,
                      ),

                      const SizedBox(height: 16),

                      // ✅ Notify Person Dropdown
                      AppDropdownSelect(
                        label: Locales.string(context, 'notify_person'),
                        value: widget.notifyPerson,
                        items: notifyPersonItems,
                        onChanged: widget.onNotifyPersonChanged,
                        prefixIcon: FontAwesomeIcons.userCheck,
                      ),

                      const SizedBox(height: 16),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
