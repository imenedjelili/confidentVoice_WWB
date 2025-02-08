import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:confident_voice/models/classes/slide.dart';
import 'package:confident_voice/views/screens/pdf_viewer.dart';
import 'package:confident_voice/views/screens/document_list.dart';

class PdfLibraryPage extends StatefulWidget {
  const PdfLibraryPage({super.key});

  @override
  State<PdfLibraryPage> createState() => _PdfLibraryPageState();
}

class _PdfLibraryPageState extends State<PdfLibraryPage> {
  List<Slide> _pdfs = [];
  bool _isLoading = false;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchPdfs();
  }

Future<void> _fetchPdfs() async {
    try {
      setState(() => _isLoading = true);

      final response = await Supabase.instance.client.storage
          .from('documents')
          .list(path: 'pdfs');

      if (response.error != null) {
        throw Exception('Supabase error: ${response.error!.message}');
      }

      final files = response.data ?? [];
      final pdfFiles = files
          .where((file) => file.name.toLowerCase().endsWith('.pdf'))
          .toList();

      final pdfs = await Future.wait(
        pdfFiles.map((file) async {
          try {
            // Inner try-catch for getPublicUrl
            final urlResponse = Supabase.instance.client.storage
                .from('documents')
                .getPublicUrl('pdfs/${file.name}');

            return Slide(
              id: file.id ?? '',
              title: file.name.split('.').first,
              url: urlResponse.data ??
                  '', // urlResponse is already the URL string
              category: selectedCategory ?? 'General',
              uploadedBy: 'Unknown',
              uploadedAt:
                  DateTime.tryParse(file.updatedAt ?? '') ?? DateTime.now(), uploaderName: '', type: '',
            );
          } catch (e) {
            // Catch errors from getPublicUrl
            throw Exception(
                'Error getting URL for ${file.name}: $e'); // Re-throw the exception
          }
        }),
      );

      setState(() {
        _pdfs = pdfs;
        _isLoading = false;
      });
    } catch (e) {
      // Outer try-catch handles all exceptions
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading PDFs: $e')),
      );
    }
  }

  void _openPdf(Slide pdf) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          url: pdf.url,
          title: pdf.title,
        ),
      ),
    );
  }

  void _viewAllPdfs(String title, List<Slide> pdfs) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentListScreen(
          title: title,
          documents: pdfs,
          isSlideView: false,
        ),
      ),
    );
  }

  Widget _buildPdfItem(Slide pdf) {
    return GestureDetector(
      onTap: () => _openPdf(pdf),
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 125,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF412963).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Icon(
                  Icons.picture_as_pdf,
                  size: 48,
                  color: Color(0xFF412963),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pdf.title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      'Uploaded on ${pdf.uploadedAt.toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      pdf.category,
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

  Widget _buildCarouselSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
    required VoidCallback onViewAll,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text('View all'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: items,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Library'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pdfs.isEmpty
              ? const Center(child: Text('No PDFs available'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildCarouselSection(
                        context,
                        title: "Recent PDFs",
                        items: _pdfs.take(5).map((pdf) => _buildPdfItem(pdf)).toList(),
                        onViewAll: () => _viewAllPdfs("All PDFs", _pdfs),
                      ),
                      const SizedBox(height: 20),
                      if (_pdfs.length > 5)
                        _buildCarouselSection(
                          context,
                          title: "More PDFs",
                          items: _pdfs.skip(5).take(5).map((pdf) => _buildPdfItem(pdf)).toList(),
                          onViewAll: () => _viewAllPdfs("All PDFs", _pdfs),
                        ),
                    ],
                  ),
                ),
    );
  }
}
