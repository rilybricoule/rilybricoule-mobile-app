import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../data/prestataire_mock_data.dart';
import '../widget/provider_header_wrapper.dart';

class ProviderServicesView extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const ProviderServicesView({
    super.key,
    this.scaffoldKey,
  });

  @override
  State<ProviderServicesView> createState() => _ProviderServicesViewState();
}

class _ProviderServicesViewState extends State<ProviderServicesView> {
  final List<Map<String, dynamic>> _myServices = List.from(PrestataireMockData.services);

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredServices {
    var filtered = _myServices;
    // Filter by search
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((service) {
        final name = service['name'].toString().toLowerCase();
        final query = _searchController.text.toLowerCase();
        return name.contains(query);
      }).toList();
    }
    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((service) {
        return service['category'] == _selectedCategory;
      }).toList();
    }

    return filtered;
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Filter by Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            RadioListTile<String>(
              title: Text('All Categories'),
              value: 'All',
              groupValue: _selectedCategory,
              onChanged: (v) {
                setState(() => _selectedCategory = v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Plumbing'),
              value: 'Plumbing',
              groupValue: _selectedCategory,
              onChanged: (v) {
                setState(() => _selectedCategory = v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Electricity'),
              value: 'Electricity',
              groupValue: _selectedCategory,
              onChanged: (v) {
                setState(() => _selectedCategory = v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Painting'),
              value: 'Painting',
              groupValue: _selectedCategory,
              onChanged: (v) {
                setState(() => _selectedCategory = v!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text('Cleaning'),
              value: 'Cleaning',
              groupValue: _selectedCategory,
              onChanged: (v) {
                setState(() => _selectedCategory = v!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // NOUVEAU: Confirm delete dialog
  void _confirmDeleteService(Map<String, dynamic> service, int index) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.delete_forever, color: AppColors.error),
            SizedBox(width: 8),
            Text('Delete Service'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete this service?'),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.build_circle_outlined, color: AppColors.error, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      service['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _myServices.removeAt(index);
              });
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Service deleted successfully'),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Delete'),
          ),
        ],
      ),
    );
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
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add New Service',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: AppColors.textSecondary),
                      tooltip: 'Cancel',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

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
                    Text('${radius.toInt()} km', style: const TextStyle(color: AppColors.providerPrimary, fontWeight: FontWeight.bold)),
                  ],
                ),
                Slider.adaptive(
                  value: radius,
                  min: 5,
                  max: 20,
                  divisions: 15,
                  activeColor: AppColors.providerPrimary,
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
              borderSide: const BorderSide(color: AppColors.providerPrimary, width: 2),
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
      body: SafeArea(
        child: Column(
          children: [
            // HEADER COMPACT
            ProviderHeaderWrapper(
              scaffoldKey: widget.scaffoldKey,
              compact: true,
            ),

            // SEARCH & FILTER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {}); //  Rebuild to filter
                      },
                      decoration: InputDecoration(
                        hintText: 'Search services...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(Icons.clear, size: 20),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                            : null,
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
                      color: _selectedCategory != 'All' // Show active state
                          ? AppColors.providerPrimary
                          : AppColors.providerPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedCategory != 'All' ? AppColors.providerPrimary : AppColors.providerPrimary.withOpacity(0.2),
                      ),
                    ),
                    child: InkWell(
                      onTap: _showCategoryFilter,
                      child: Icon(
                        Icons.tune,
                        color: _selectedCategory != 'All' ? Colors.white : AppColors.providerPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SERVICE LIST
            Expanded(
              child: _filteredServices.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.build_circle_outlined, size: 64, color: AppColors.textSecondary.withOpacity(0.5)),
                    const SizedBox(height: 16),
                    Text(
                      _searchController.text.isNotEmpty || _selectedCategory != 'All' ? 'No services found' : 'No services listed yet',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                    if (_searchController.text.isNotEmpty || _selectedCategory != 'All') ...[
                      SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _selectedCategory = 'All';
                          });
                        },
                        child: Text('Clear Filters'),
                      ),
                    ] else ...[
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _showAddServiceSheet,
                        child: const Text('Add your first service'),
                      ),
                    ],
                  ],
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                itemCount: _filteredServices.length,
                itemBuilder: (context, index) {
                  final service = _filteredServices[index];
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
                                  color: AppColors.providerPrimary.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  image: service['image'] != null
                                      ? DecorationImage(
                                    image: NetworkImage(service['image']),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: service['image'] == null ? const Icon(Icons.image_outlined, color: AppColors.border, size: 30) : null,
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
                                        // NOUVEAU: Menu button
                                        PopupMenuButton<String>(
                                          icon: Icon(Icons.more_vert, size: 20, color: AppColors.textSecondary),
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Edit service - Coming soon')),
                                              );
                                            } else if (value == 'delete') {
                                              _confirmDeleteService(service, index);
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit, size: 18, color: AppColors.providerPrimary),
                                                  SizedBox(width: 12),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.delete, size: 18, color: AppColors.error),
                                                  SizedBox(width: 12),
                                                  Text('Delete', style: TextStyle(color: AppColors.error)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      service['price'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        color: AppColors.providerPrimary,
                                      ),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddServiceSheet,
        backgroundColor: AppColors.providerPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}