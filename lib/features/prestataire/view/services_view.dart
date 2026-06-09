import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../data/prestataire_mock_data.dart';

class ProviderServicesView extends StatefulWidget {
  const ProviderServicesView({super.key});

  @override
  State<ProviderServicesView> createState() => _ProviderServicesViewState();
}

class _ProviderServicesViewState extends State<ProviderServicesView> {
  bool _isInit = false;
  late List<Map<String, dynamic>> _myServices;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _myServices = List.from(PrestataireMockData.getServices(context));
      _isInit = true;
    }
  }

  void _showAddServiceSheet() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final categoryController = TextEditingController();
    final descController = TextEditingController();
    final durationController = TextEditingController();
    double radius = 10.0;
    String selectedCategory = 'Plumbing';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Add New Service',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                ),
                const SizedBox(height: 24),
                _buildField('Service Name *', 'e.g. Leak Repair', nameController),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildField('Price (MAD) *', 'e.g. 150', priceController, keyboardType: TextInputType.number)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildField('Duration', 'e.g. 1h 30m', durationController)),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Category *', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      isExpanded: true,
                      items: ['Plumbing', 'Electricity', 'Painting', 'Cleaning', 'Handyman']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setModalState(() => selectedCategory = v!),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildField('Description * (20-300 chars)', 'Provide details...', descController, maxLines: 4),
                const SizedBox(height: 4),
                ValueListenableBuilder(
                  valueListenable: descController,
                  builder: (context, value, _) {
                    final len = value.text.length;
                    return Text(
                      '$len/300 characters',
                      style: TextStyle(
                        color: (len < 20 || len > 300) ? AppColors.error : AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Service Radius', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text('${radius.toInt()} km', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider.adaptive(
                  value: radius,
                  min: 5,
                  max: 20,
                  divisions: 15,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setModalState(() => radius = v),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty && 
                          priceController.text.isNotEmpty && 
                          descController.text.length >= 20) {
                        setState(() {
                          _myServices.insert(0, {
                            'id': DateTime.now().toString(),
                            'name': nameController.text,
                            'price': '${priceController.text} MAD',
                            'category': selectedCategory,
                            'description': descController.text,
                            'isActive': true,
                            'radius': radius.toInt(),
                          });
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Service added successfully!')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please fill all required fields correctly')),
                        );
                      }
                    },
                    child: const Text('Save Service'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, TextEditingController controller, {TextInputType? keyboardType, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Services'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showAddServiceSheet,
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search services...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  child: const Icon(Icons.tune, color: AppColors.primary, size: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: _myServices.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.build_circle_outlined, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        const Text(
                          'No services listed yet',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _showAddServiceSheet,
                          child: const Text('Add your first service'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: _myServices.length,
                    itemBuilder: (context, index) {
                      final service = _myServices[index];
                      // Defaulting missing fields for mock stability
                      final bool isActive = service['isActive'] ?? true;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      image: service['image'] != null
                                          ? DecorationImage(
                                              image: NetworkImage(service['image']),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: service['image'] == null
                                        ? const Icon(Icons.image_outlined, color: AppColors.border, size: 30)
                                        : null,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                service['name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              service['price'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          service['category'],
                                          style: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          service['description'],
                                          style: TextStyle(
                                            color: AppColors.textSecondary.withOpacity(0.8),
                                            fontSize: 13,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Divider(height: 1, color: AppColors.border),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.amber, size: 14),
                                      const SizedBox(width: 4),
                                      const Text('4.8', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                      const SizedBox(width: 8),
                                      Text('(12 bookings)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        isActive ? 'Active' : 'Inactive',
                                        style: TextStyle(
                                          color: isActive ? AppColors.success : AppColors.textSecondary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      SizedBox(
                                        height: 24,
                                        child: Switch.adaptive(
                                          value: isActive,
                                          activeColor: AppColors.success,
                                          onChanged: (v) {
                                            setState(() {
                                              _myServices[index]['isActive'] = v;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddServiceSheet,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}