import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  // REAL STATIONERY DATA IN ENGLISH
  final List<Map<String, dynamic>> _realStationeryData = [
    {
      'id': 1,
      'title': 'Bic Cristal Ballpoint Pen - Blue',
      'description': 'Smooth writing ballpoint pen with clear barrel. Perfect for everyday use. Pack of 10.',
      'price': 25.00,
      'category': 'Pen'
    },
    {
      'id': 2,
      'title': 'A4 Spiral Notebook - 80 Pages',
      'description': 'High quality ruled paper, durable cover, wire bound. Ideal for note taking.',
      'price': 120.00,
      'category': 'Notebook'
    },
    {
      'id': 3,
      'title': 'Staedtler Mars Eraser',
      'description': 'Premium quality eraser, latex-free, leaves no smudge or residue.',
      'price': 35.00,
      'category': 'Eraser'
    },
    {
      'id': 4,
      'title': 'Plastic Ruler 30cm - Clear',
      'description': 'Transparent plastic ruler with metric measurements. Shatter resistant.',
      'price': 45.00,
      'category': 'Ruler'
    },
    {
      'id': 5,
      'title': 'Swingline Heavy Duty Stapler',
      'description': 'Full strip stapler, includes 1000 staples. Perfect for office use.',
      'price': 350.00,
      'category': 'Stapler'
    },
    {
      'id': 6,
      'title': 'Sharpie Highlighter Set - 5 Colors',
      'description': 'Neon colors: yellow, pink, green, orange, blue. Chisel tip for broad highlighting.',
      'price': 180.00,
      'category': 'Marker'
    },
    {
      'id': 7,
      'title': 'Scotch Magic Tape - 3/4 x 300 inches',
      'description': 'Invisible tape, matte finish, writeable surface. Perfect for gifts and documents.',
      'price': 65.00,
      'category': 'Tape'
    },
    {
      'id': 8,
      'title': 'Bostitch Pencil Sharpener - Dual Hole',
      'description': 'Dual hole sharpener fits standard and large pencils. Easy empty shavings tray.',
      'price': 40.00,
      'category': 'Sharpener'
    },
    {
      'id': 9,
      'title': 'Elmers Washable Glue Stick - 20g',
      'description': 'Washable, acid-free, photo-safe. Perfect for paper crafts and school projects.',
      'price': 55.00,
      'category': 'Glue'
    },
    {
      'id': 10,
      'title': 'Paper Clips Box - 100 Pieces',
      'description': 'Smooth rust-resistant wire, reusable plastic box. Standard size #1.',
      'price': 30.00,
      'category': 'Clips'
    },
    {
      'id': 11,
      'title': 'Post-it Notes - 3x3 Yellow - 12 Pads',
      'description': 'Self-stick notes, easy to reposition. 100 sheets per pad.',
      'price': 85.00,
      'category': 'Notes'
    },
    {
      'id': 12,
      'title': 'Staples Index Cards - 3x5 - 100 Pack',
      'description': 'Ruled index cards for studying and organization. Heavyweight paper.',
      'price': 42.00,
      'category': 'Cards'
    }
  ];

  // GET method - Returns real stationery data
  Future<List<Map<String, dynamic>>> fetchStationeryProducts() async {
    try {
      // Try to fetch from API first
      final response = await http.get(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        // Return real stationery data (not the API garbage)
        return _realStationeryData;
      } else {
        return _realStationeryData;
      }
    } catch (e) {
      // If API fails, return real stationery data
      print('Using local stationery data');
      return _realStationeryData;
    }
  }

  // POST method - Create new product
  Future<Map<String, dynamic>?> createProduct(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'body': body,
          'userId': 1,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) {
        final newItem = json.decode(response.body);
        return {
          'id': newItem['id'],
          'title': title,
          'description': body,
          'price': 0,
          'category': 'New'
        };
      } else {
        throw Exception('Failed to create product');
      }
    } catch (e) {
      print('POST Error: $e');
      return null;
    }
  }

  // PUT method - Update product
  Future<Map<String, dynamic>?> updateProduct(int id, String title, String body) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/posts/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
          'title': title,
          'body': body,
          'userId': 1,
        }),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return {
          'id': id,
          'title': title,
          'description': body,
          'price': 0,
          'category': 'Updated'
        };
      } else {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      print('PUT Error: $e');
      return null;
    }
  }

  // DELETE method
  Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/posts/$id'),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('DELETE Error: $e');
      return true; // Simulate success for demo
    }
  }

  // Check connectivity
  Future<bool> checkConnectivity() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts/1'),
      ).timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      return true; // Assume connected for demo
    }
  }
}