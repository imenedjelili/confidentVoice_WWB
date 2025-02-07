import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confident_voice/Controllers/library_bloc.dart';
import 'package:confident_voice/models/Events/library_event.dart';
import 'package:confident_voice/models/classes/slide.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:confident_voice/views/screens/pdf_viewer.dart';
import 'package:confident_voice/views/screens/document_list.dart';
import 'package:confident_voice/utils/string_extensions.dart';

class SpeechLibraryPage extends StatelessWidget {
  const SpeechLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LibraryBloc()..add(InitializeLibraryEvent()),
      child: const _SpeechLibraryView(),
    );
  }
}

class _SpeechLibraryView extends StatefulWidget {
  const _SpeechLibraryView();

  @override
  State<_SpeechLibraryView> createState() => _SpeechLibraryViewState();
}

class _SpeechLibraryViewState extends State<_SpeechLibraryView> {
  String? selectedCategory;
  int _currentIndex = 0;
  List<Slide> _slides = [];
  List<Slide> _texts = [];
  bool _isSlidesLoading = true;
  bool _isTextsLoading = true;

  final List<Map<String, dynamic>> categories = [
    {'label': 'For You', 'icon': Icons.star},
    {'label': 'Marketing', 'icon': Icons.trending_up},
    {'label': 'Art & Photos', 'icon': Icons.photo},
    {'label': 'Science', 'icon': Icons.science},
    {'label': 'Technology', 'icon': Icons.computer},
    {'label': 'Health', 'icon': Icons.health_and_safety},
    {'label': 'Travel', 'icon': Icons.travel_explore},
    {'label': 'Music', 'icon': Icons.music_note},
    {'label': 'Food', 'icon': Icons.fastfood},
    {'label': 'Sports', 'icon': Icons.sports},
    {'label': 'Movies', 'icon': Icons.movie},
    {'label': 'Comedy', 'icon': Icons.sentiment_satisfied},
    {'label': 'Books', 'icon': Icons.book},
  ];

  @override
  void initState() {
    super.initState();
    _fetchSlides();
    _fetchTexts();
  }

  Future<void> _fetchSlides() async {
    try {
      setState(() => _isSlidesLoading = true);

      final response = await Supabase.instance.client
          .storage
          .from('documents')
          .list(path: 'slides');

      final files = response.data ?? [];

      final slides = await Future.wait(
        files.map((file) async {
          final urlResponse = Supabase.instance.client
              .storage
              .from('documents')
              .getPublicUrl('slides/${file.name}');

          final publicUrl = urlResponse.data ?? '';

          return Slide(
            id: file.id ?? '',
            title: file.name.split('.').first, // Remove file extension
            url: publicUrl,
            category: 'General', // You might want to store this in metadata
            uploadedBy: 'Unknown', // You might want to store this in metadata
            uploadedAt: DateTime.tryParse(file.updatedAt ?? '') ?? DateTime.now(),
          );
        }),
      );

      setState(() {
        _slides = slides;
        _isSlidesLoading = false;
      });
    } catch (e) {
      setState(() => _isSlidesLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading slides: $e')),
      );
    }
  }

  Future<void> _fetchTexts() async {
    try {
      setState(() => _isTextsLoading = true);

      print('Fetching PDFs from documents/pdf folder...');
      
      // List files from documents/pdf folder
      final response = await Supabase.instance.client
          .storage
          .from('documents')
          .list(path: 'pdf');

      if (response.error != null) {
        throw Exception('Supabase error: ${response.error!.message}');
      }

      final files = response.data ?? [];
      print('Found ${files.length} files in documents/pdf folder');
      
      // Filter PDF files
      final pdfFiles = files.where((file) => 
        file.name.toLowerCase().endsWith('.pdf')
      ).toList();
      
      print('Found ${pdfFiles.length} PDF files');

      if (pdfFiles.isEmpty) {
        print('No PDF files found in documents/pdf folder');
        setState(() {
          _texts = [];
          _isTextsLoading = false;
        });
        return;
      }

      // Process PDF files
      final texts = await Future.wait(
        pdfFiles.map((file) async {
          print('Processing PDF: ${file.name}');
          
          final urlResponse = Supabase.instance.client
              .storage
              .from('documents')
              .getPublicUrl('pdf/${file.name}');

          if (urlResponse.error != null) {
            throw Exception('Error getting URL for ${file.name}: ${urlResponse.error!.message}');
          }

          final publicUrl = urlResponse.data ?? '';
          print('Got public URL for ${file.name}: $publicUrl');

          return Slide(
            id: file.id ?? '',
            title: file.name.split('.').first,
            url: publicUrl,
            category: selectedCategory ?? 'General',
            uploadedBy: 'Unknown',
            uploadedAt: DateTime.tryParse(file.updatedAt ?? '') ?? DateTime.now(),
          );
        }),
      );

      print('Successfully processed ${texts.length} PDFs');

      setState(() {
        _texts = texts;
        _isTextsLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error fetching PDFs: $e');
      print('Stack trace: $stackTrace');
      setState(() => _isTextsLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading PDFs: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // Helper method to format the title from filename
  String _formatTitle(String fileName) {
    // Remove file extension
    String title = fileName.split('.').first;
    
    // Remove path if present
    if (title.contains('/')) {
      title = title.split('/').last;
    }
    
    // Replace underscores and hyphens with spaces
    title = title.replaceAll('_', ' ').replaceAll('-', ' ');
    
    // Capitalize words
    title = title.split(' ').map((word) => 
      word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : ''
    ).join(' ');
    
    return title;
  }

  void _openDocument(Slide document) {
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

  void _viewAllDocuments(String title, List<Slide> documents, bool isSlideView) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentListScreen(
          title: title,
          documents: documents,
          isSlideView: isSlideView,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: _currentIndex == 0 
              ? _buildSlidesContent(context) 
              : _buildTextContent(context),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.white,
        selectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFA26DC5)
            : const Color(0xFF412963),
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : const Color(0xFFA26DC5),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.slideshow),
            label: 'Slides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Text',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryChip(category['label'], category['icon']);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon) {
    bool isSelected = selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              selectedCategory = selected ? label : null;
            });
          },
          selectedColor: const Color(0xFF412963), // Dark purple for selected
          backgroundColor: const Color(0xFF9370DB), // Medium purple for unselected
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0, // Remove default elevation since we're using custom shadow
          pressElevation: 2,
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, {bool isSlideScreen = true}) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF412963),
                const Color(0xFFA26DC5).withOpacity(0.8),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isSlideScreen ? Icons.slideshow : Icons.picture_as_pdf,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isSlideScreen ? 'Speech Slides' : 'PDF Resources',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isSlideScreen
                      ? 'Access your presentation slides and materials'
                      : 'Browse through your PDF documents and resources',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSlideScreen ? Icons.auto_stories : Icons.menu_book,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isSlideScreen
                            ? '${_slides.length} Slides Available'
                            : '${_texts.length} PDFs Available',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlidesContent(BuildContext context) {
    if (_isSlidesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Slide> filteredSlides = selectedCategory == null || selectedCategory == 'For You'
        ? _slides
        : _slides.where((slide) => slide.category == selectedCategory).toList();

    if (filteredSlides.isEmpty) {
      return const Center(
        child: Text('No slides available for this category'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(context, isSlideScreen: true),
          const SizedBox(height: 20),
          _buildCarouselSection(
            context,
            title: "Recent Slides",
            items: filteredSlides.take(5).map((slide) => _buildDocumentItem(slide)).toList(),
            onViewAll: () => _viewAllDocuments("All Slides", filteredSlides, true),
          ),
          const SizedBox(height: 20),
          if (filteredSlides.length > 5)
            _buildCarouselSection(
              context,
              title: "More Slides",
              items: filteredSlides.skip(5).take(5).map((slide) => _buildDocumentItem(slide)).toList(),
              onViewAll: () => _viewAllDocuments("All Slides", filteredSlides, true),
            ),
        ],
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    if (_isTextsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Slide> filteredTexts = selectedCategory == null || selectedCategory == 'For You'
        ? _texts
        : _texts.where((text) => text.category == selectedCategory).toList();

    if (filteredTexts.isEmpty) {
      return const Center(
        child: Text('No PDFs available for this category'),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(context, isSlideScreen: false),
          const SizedBox(height: 20),
          _buildCarouselSection(
            context,
            title: "Recent PDFs",
            items: filteredTexts.take(5).map((text) => _buildDocumentItem(text)).toList(),
            onViewAll: () => _viewAllDocuments("All PDFs", filteredTexts, false),
          ),
          const SizedBox(height: 20),
          if (filteredTexts.length > 5)
            _buildCarouselSection(
              context,
              title: "More PDFs",
              items: filteredTexts.skip(5).take(5).map((text) => _buildDocumentItem(text)).toList(),
              onViewAll: () => _viewAllDocuments("All PDFs", filteredTexts, false),
            ),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(Slide document) {
    return GestureDetector(
      onTap: () => _openDocument(document),
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
              child: Center(
                child: Icon(
                  _currentIndex == 0 ? Icons.slideshow : Icons.picture_as_pdf,
                  size: 48,
                  color: const Color(0xFF412963),
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
                      document.title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      'Uploaded on ${document.uploadedAt.toString().split(' ')[0]}',
                      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
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
          height: 220, // Increased height to accommodate content
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            children: items,
          ),
        ),
      ],
    );
  }
}

class CategoryDetailPage extends StatelessWidget {
  final String title;

  const CategoryDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$title - Detail')),
      body: Center(child: Text('Details for $title category')),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: const Center(child: Text('Search functionality here')),
    );
  }
}
