import 'package:flutter/material.dart';
import '../models/stationery_item.dart';

class ItemDetailScreen extends StatelessWidget {
  final StationeryItem item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.inventory_2, size: 80, color: Color(0xFF2196F3)),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow('Item Name', item.name),
                const Divider(),
                _buildInfoRow('Category', item.category),
                const Divider(),
                _buildInfoRow('Quantity', '${item.quantity}'),
                const Divider(),
                _buildInfoRow('Price', 'KES ${item.price.toStringAsFixed(2)}'),
                const Divider(),
                _buildInfoRow('Total Value', 'KES ${(item.quantity * item.price).toStringAsFixed(2)}', isHighlighted: true),
                const Divider(),
                _buildInfoRow('Description', item.description),
                const Divider(),
                _buildInfoRow('Date Added', '${item.dateAdded.day}/${item.dateAdded.month}/${item.dateAdded.year}'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isHighlighted ? 18 : 16,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? Colors.green : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}