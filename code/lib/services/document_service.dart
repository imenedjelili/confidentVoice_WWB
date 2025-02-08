import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confident_voice/models/classes/slide.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocumentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _supabase = Supabase.instance.client;

  Future<List<Slide>> getSlides({String? category}) async {
    try {
      // First, get files from Supabase
      final response = await _supabase
          .storage
          .from('documents')
          .list(path: 'slides');

      if (response.error != null) {
        throw Exception('Supabase error: ${response.error!.message}');
      }

      final files = response.data ?? [];
      
      // Get metadata from Firebase
      final QuerySnapshot metadataSnapshot = await _firestore
          .collection('documents')
          .where('type', isEqualTo: 'slide')
          .get();

      final metadataMap = {
        for (var doc in metadataSnapshot.docs)
          doc.get('filename') as String: doc.data() as Map<String, dynamic>
      };

      // Combine Supabase files with Firebase metadata
      return Future.wait(files.map((file) async {
        final urlResponse = await _supabase
            .storage
            .from('documents')
            .getPublicUrl('slides/${file.name}');

        final metadata = metadataMap[file.name] ?? {};
        final uploaderId = metadata['uploaded_by'] as String? ?? 'unknown';
        final uploaderName = await getUploaderName(uploaderId);

        return Slide(
          id: file.id ?? '',
          title: metadata['title'] as String? ?? file.name.split('.').first,
          description: metadata['description'] as String?,
          url: urlResponse.data ?? '',
          category: metadata['category'] as String? ?? 'General',
          uploadedBy: uploaderId,
          uploaderName: uploaderName,
          uploadedAt: metadata['uploaded_at'] != null 
              ? (metadata['uploaded_at'] as Timestamp).toDate()
              : DateTime.tryParse(file.updatedAt ?? '') ?? DateTime.now(),
          type: 'slide',
          size: metadata['size'] as int?,
        );
      }));
    } catch (e) {
      print('Error fetching slides: $e');
      return [];
    }
  }

  Future<List<Slide>> getPdfs({String? category}) async {
    try {
      // First, get files from Supabase
      final response = await _supabase
          .storage
          .from('documents')
          .list(path: 'pdf');

      if (response.error != null) {
        throw Exception('Supabase error: ${response.error!.message}');
      }

      final files = response.data ?? [];
      
      // Get metadata from Firebase
      final QuerySnapshot metadataSnapshot = await _firestore
          .collection('documents')
          .where('type', isEqualTo: 'pdf')
          .get();

      final metadataMap = {
        for (var doc in metadataSnapshot.docs)
          doc.get('filename') as String: doc.data() as Map<String, dynamic>
      };

      // Combine Supabase files with Firebase metadata
      return Future.wait(files.where((file) => 
        file.name.toLowerCase().endsWith('.pdf')
      ).map((file) async {
        final urlResponse = await _supabase
            .storage
            .from('documents')
            .getPublicUrl('pdf/${file.name}');

        final metadata = metadataMap[file.name] ?? {};
        final uploaderId = metadata['uploaded_by'] as String? ?? 'unknown';
        final uploaderName = await getUploaderName(uploaderId);

        return Slide(
          id: file.id ?? '',
          title: metadata['title'] as String? ?? file.name.split('.').first,
          description: metadata['description'] as String?,
          url: urlResponse.data ?? '',
          category: metadata['category'] as String? ?? 'General',
          uploadedBy: uploaderId,
          uploaderName: uploaderName,
          uploadedAt: metadata['uploaded_at'] != null 
              ? (metadata['uploaded_at'] as Timestamp).toDate()
              : DateTime.tryParse(file.updatedAt ?? '') ?? DateTime.now(),
          type: 'pdf',
          size: metadata['size'] as int?,
        );
      }));
    } catch (e) {
      print('Error fetching PDFs: $e');
      return [];
    }
  }

  Future<String> getUploaderName(String userId) async {
    if (userId == 'unknown') return 'Unknown User';
    
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return userData['name'] ?? userData['displayName'] ?? 'Unknown User';
      }
      return 'Unknown User';
    } catch (e) {
      print('Error fetching uploader name: $e');
      return 'Unknown User';
    }
  }

  Future<Map<String, dynamic>?> getDocumentMetadata(String filename) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('documents')
          .where('filename', isEqualTo: filename)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        final uploaderName = await getUploaderName(data['uploaded_by'] as String? ?? 'unknown');
        return {
          ...data,
          'uploader_name': uploaderName,
        };
      }
      return null;
    } catch (e) {
      print('Error fetching document metadata: $e');
      return null;
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('documents')
          .get();

      final categories = <String>{};
      for (final doc in querySnapshot.docs) {
        final category = doc['category'] as String?;
        if (category != null && category.isNotEmpty) {
          categories.add(category);
        }
      }

      return categories.toList()..sort();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
}
