import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rilybricoule_mobile_app/l10n/app_localizations.dart';
import '../../../core/constants/app_colors.dart';
import '../../map/widgets/map_preview.dart';
import '../widgets/custom_calendar.dart';
import '../widgets/time_slot_button.dart';
import '../widgets/edit_address_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookingDateTimeScreen extends StatefulWidget {
  const BookingDateTimeScreen({super.key});

  @override
  State<BookingDateTimeScreen> createState() => _BookingDateTimeScreenState();
}

class _BookingDateTimeScreenState extends State<BookingDateTimeScreen> {
  bool _isLoading = true;
  String? _providerId;
  String? _serviceId;
  DateTime? _selectedDate;
  String? _selectedTime;
  bool _useRegisteredAddress = true;
  String _address = '69, avenue Abdelkrim Al Khattabi, Océan';
  String _addressDetails = 'Appartement 4B, 2ème étage';
  final TextEditingController _noteController = TextEditingController();

  final List<String> _morningSlots = ['08:30', '09:00', '10:30'];
  final List<String> _afternoonSlots = ['14:00', '15:30', '17:00'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadArguments();
  }

  Future<void> _loadArguments() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    
    if (args == null) {
      setState(() => _isLoading = false);
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _providerId = args['providerId'];
      _serviceId = args['serviceId'];
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  bool get _canContinue => _selectedDate != null && _selectedTime != null;

  void _continue() {
    if (!_canContinue) return;

    Navigator.pushNamed(
      context,
      '/booking-summary',
      arguments: {
        'providerId': _providerId,
        'serviceId': _serviceId,
        'date': _selectedDate,
        'time': _selectedTime,
        'note': _noteController.text,
        'address': _address,
        'addressDetails': _addressDetails,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.mainAppPrimary),
        ),
      );
    }

    if (_providerId == null || _serviceId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.scheduling)),
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.errorMissingData,
            style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildCalendarSection(),
                        const SizedBox(height: 16),
                        _buildTimeSlotsSection(),
                        const SizedBox(height: 16),
                        _buildAddressSection(),
                        const SizedBox(height: 16),
                        _buildNotesSection(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.scheduling,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.bookingProgress,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.stepXofY(2, 5),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainAppPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.4,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.mainAppPrimary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.mainAppPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppColors.mainAppPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.chooseDate,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomCalendar(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                _selectedTime = null;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.mainAppPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.access_time,
                  size: 20,
                  color: AppColors.mainAppPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.availableSlots,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.morning,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _morningSlots.map((time) {
              return TimeSlotButton(
                time: time,
                isSelected: _selectedTime == time,
                isDisabled: _selectedDate == null,
                onTap: () => setState(() => _selectedTime = time),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.afternoon,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _afternoonSlots.map((time) {
              return TimeSlotButton(
                time: time,
                isSelected: _selectedTime == time,
                isDisabled: _selectedDate == null,
                onTap: () => setState(() => _selectedTime = time),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.mainAppPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.location_on,
                  size: 20,
                  color: AppColors.mainAppPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.confirmAddress,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => EditAddressDialog(
                      currentAddress: _address,
                      currentDetails: _addressDetails,
                      onSave: (address, details) {
                        setState(() {
                          _address = address;
                          _addressDetails = details;
                        });
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.edit, size: 20, color: AppColors.mainAppPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _address,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _addressDetails,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _useRegisteredAddress,
                onChanged: (value) {
                  setState(() => _useRegisteredAddress = value ?? true);
                },
                activeColor: AppColors.mainAppPrimary,
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.useRegisteredAddress,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MapPreview(
            position: const LatLng(33.5731, -7.5898),
            height: 200,
            borderRadius: 12,
            interactive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.mainAppPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.note_alt_outlined,
                  size: 20,
                  color: AppColors.mainAppPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.noteForProvider,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.noteHint,
              hintStyle: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: ElevatedButton(
            onPressed: _canContinue ? _continue : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainAppPrimary,
              disabledBackgroundColor: AppColors.textSecondary.withOpacity(0.3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.btnContinue,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
