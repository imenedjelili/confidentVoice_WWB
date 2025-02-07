import 'package:flutter/material.dart';
import 'package:confident_voice/models/classes/slide.dart';
import 'package:confident_voice/views/screens/pdf_viewer.dart';

class DocumentListScreen extends StatelessWidget {
  final String title;
  final List<Slide> documents;
  final bool isSlideView;

  const DocumentListScreen({
    super.key,
    required this.title,
    required this.documents,
    required this.isSlideView,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: documents.isEmpty
          ? const Center(
              child: Text('No documents available'),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                return _buildDocumentCard(context, document);
              },
            ),
    );
  }

  Widget _buildDocumentCard(BuildContext context, Slide document) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _openDocument(context, document),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF412963).withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Icon(
                    isSlideView ? Icons.slideshow : Icons.description,
                    size: 48,
                    color: const Color(0xFF412963),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      'Uploaded on ${document.uploadedAt.toString().split(' ')[0]}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      document.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).primaryColor,
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

  void _openDocument(BuildContext context, Slide document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          url: document.url,
          title: document.title,
        ),
      ),
    );
  }
}
