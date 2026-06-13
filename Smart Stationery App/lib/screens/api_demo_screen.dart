import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ApiDemoScreen extends StatefulWidget {
  const ApiDemoScreen({super.key});

  @override
  State<ApiDemoScreen> createState() => _ApiDemoScreenState();
}

class _ApiDemoScreenState extends State<ApiDemoScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _apiData = [];
  bool _isLoading = false;
  String _selectedMethod = 'GET';
  String _operationMessage = '';

  final List<String> _httpMethods = ['GET', 'POST', 'PUT', 'DELETE'];

  @override
  void initState() {
    super.initState();
    _executeGet(); // Load data when screen opens
  }

  Future<void> _executeGet() async {
    setState(() {
      _isLoading = true;
      _operationMessage = '';
    });

    final data = await _apiService.fetchStationeryProducts();
    setState(() {
      _apiData = data;
      _isLoading = false;
      _operationMessage = 'GET completed - Loaded ${data.length} stationery items';
    });
  }

  Future<void> _executePost() async {
    setState(() {
      _isLoading = true;
      _operationMessage = '';
    });

    final result = await _apiService.createProduct(
      'New Stationery Item',
      'This is a new stationery product added via POST request',
    );

    if (result != null) {
      setState(() {
        _apiData.insert(0, result);
        _isLoading = false;
        _operationMessage = 'POST successful! Added: ${result['title']}';
      });
      _showSnackbar('POST successful!', Colors.green);
    } else {
      setState(() {
        _isLoading = false;
        _operationMessage = 'POST failed';
      });
      _showSnackbar('POST failed', Colors.red);
    }
  }

  Future<void> _executePut() async {
    if (_apiData.isEmpty) {
      _showSnackbar('No items to update. Use GET first.', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
      _operationMessage = '';
    });

    final firstItem = _apiData[0];
    final result = await _apiService.updateProduct(
      firstItem['id'],
      'UPDATED: ${firstItem['title']}',
      'This stationery item was updated via PUT request',
    );

    if (result != null) {
      setState(() {
        _apiData[0] = result;
        _isLoading = false;
        _operationMessage = 'PUT successful! Updated item ID: ${result['id']}';
      });
      _showSnackbar('PUT successful!', Colors.orange);
    } else {
      setState(() {
        _isLoading = false;
        _operationMessage = 'PUT failed';
      });
      _showSnackbar('PUT failed', Colors.red);
    }
  }

  Future<void> _executeDelete() async {
    if (_apiData.isEmpty) {
      _showSnackbar('No items to delete. Use GET first.', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
      _operationMessage = '';
    });

    final firstItem = _apiData[0];
    final success = await _apiService.deleteProduct(firstItem['id']);

    if (success) {
      setState(() {
        _apiData.removeAt(0);
        _isLoading = false;
        _operationMessage = 'DELETE successful! Removed ID: ${firstItem['id']}';
      });
      _showSnackbar('DELETE successful!', Colors.red);
    } else {
      setState(() {
        _isLoading = false;
        _operationMessage = 'DELETE failed';
      });
      _showSnackbar('DELETE failed', Colors.red);
    }
  }

  void _executeRequest() {
    switch (_selectedMethod) {
      case 'GET':
        _executeGet();
        break;
      case 'POST':
        _executePost();
        break;
      case 'PUT':
        _executePut();
        break;
      case 'DELETE':
        _executeDelete();
        break;
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stationery Products API'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // HTTP Method Selector
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('HTTP Method:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedMethod,
                    isExpanded: true,
                    items: _httpMethods.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getMethodColor(method),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(method, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMethod = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _isLoading ? null : _executeRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getMethodColor(_selectedMethod),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_selectedMethod),
                ),
              ],
            ),
          ),
          // Operation Message
          if (_operationMessage.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _operationMessage,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
            ),
          const SizedBox(height: 8),
          // Results
          Expanded(
            child: _isLoading
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF2196F3)),
                  SizedBox(height: 16),
                  Text('Loading stationery products...'),
                ],
              ),
            )
                : _apiData.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No stationery products'),
                  SizedBox(height: 8),
                  Text('Click GET to load products'),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _apiData.length,
              itemBuilder: (context, index) {
                final item = _apiData[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getMethodColor(_selectedMethod),
                      child: Text('${item['id']}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    title: Text(
                      item['title'] ?? 'No Title',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      item['description'] ?? 'No description',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Chip(
                      label: Text(item['category'] ?? 'General', style: const TextStyle(fontSize: 10)),
                      backgroundColor: Colors.blue.shade100,
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(item['title']),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${item['id']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              const Text('Category:', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(item['category'] ?? 'General'),
                              const SizedBox(height: 8),
                              const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(item['description'] ?? 'No description'),
                              if (item['price'] != null && item['price'] > 0) ...[
                                const SizedBox(height: 8),
                                const Text('Price:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('KES ${item['price']}'),
                              ],
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'GET': return Colors.green;
      case 'POST': return Colors.blue;
      case 'PUT': return Colors.orange;
      case 'DELETE': return Colors.red;
      default: return Colors.grey;
    }
  }
}