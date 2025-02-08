import 'package:confident_voice/services/document_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:confident_voice/models/classes/slide.dart';
import 'package:confident_voice/views/screens/pdf_viewer.dart';
import 'package:confident_voice/views/screens/document_list.dart';
import 'package:confident_voice/views/screens/search_screen.dart';
import 'package:confident_voice/widgets/styled_snackbar.dart';

class SpeechLibraryPage extends StatelessWidget {
  const SpeechLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SpeechLibraryView();
  }
}

class _SpeechLibraryView extends StatefulWidget {
  const _SpeechLibraryView();

  @override
  State<_SpeechLibraryView> createState() => _SpeechLibraryViewState();
}

class _SpeechLibraryViewState extends State<_SpeechLibraryView> {
  final DocumentService _documentService = DocumentService();
  int _currentIndex = 0;
  List<Slide> _slides = [];
  List<Slide> _texts = [];
  bool _isSlidesLoading = false;
  bool _isTextsLoading = false;
  bool _isCategoriesLoading = false;
  List<String> _categories = [];
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchSlides();
    _fetchTexts();
  }

  Future<void> _fetchCategories() async {
    try {
      setState(() => _isCategoriesLoading = true);
      final categories = await _documentService.getCategories();
      setState(() {
        _categories = ['For You', ...categories];
        _isCategoriesLoading = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() => _isCategoriesLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          StyledSnackBar.show(
            message: 'Error loading categories: $e',
            isError: true,
          ),
        );
      }
    }
  }

  Future<void> _fetchSlides() async {
    try {
      setState(() => _isSlidesLoading = true);
      final slides = await _documentService.getSlides();
      setState(() {
        _slides = selectedCategory == null || selectedCategory == 'For You'
            ? slides
            : slides.where((slide) => slide.category == selectedCategory).toList();
        _isSlidesLoading = false;
      });
    } catch (e) {
      print('Error fetching slides: $e');
      setState(() => _isSlidesLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          StyledSnackBar.show(
            message: 'Error loading slides: $e',
            isError: true,
          ),
        );
      }
    }
  }

  Future<void> _fetchTexts() async {
    try {
      setState(() => _isTextsLoading = true);
      final texts = await _documentService.getPdfs();
      setState(() {
        _texts = selectedCategory == null || selectedCategory == 'For You'
            ? texts
            : texts.where((text) => text.category == selectedCategory).toList();
        _isTextsLoading = false;
      });
    } catch (e) {
      print('Error fetching PDFs: $e');
      setState(() => _isTextsLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          StyledSnackBar.show(
            message: 'Error loading PDFs: $e',
            isError: true,
          ),
        );
      }
    }
  }

  Widget _buildCategoryChips() {
    if (_isCategoriesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      height: 50,
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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return _buildCategoryChip(category);
        },
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    bool isSelected = selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF412963),
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            selectedCategory = selected ? label : null;
            _fetchSlides();
            _fetchTexts();
          });
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF412963),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: isSelected ? Colors.transparent : const Color(0xFF412963),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(bool isSlideView) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF412963),
            const Color(0xFF9370DB),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSlideView ? Icons.slideshow : Icons.picture_as_pdf,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  isSlideView ? 'Speech Slides' : 'PDF Resources',
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
              isSlideView
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
                    isSlideView ? Icons.auto_stories : Icons.menu_book,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isSlideView
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
    );
  }

  Widget _buildDocumentCarousel(String title, List<Slide> documents, VoidCallback onViewAll) {
    if (documents.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final document = documents[index];
              return SizedBox(
                width: 160,
                child: Card(
                  child: InkWell(
                    onTap: () => _openDocument(document),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF412963).withOpacity(0.1),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _currentIndex == 0 ? Icons.slideshow : Icons.picture_as_pdf,
                                size: 48,
                                color: const Color(0xFF412963),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                document.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'By ${document.uploaderName}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF412963).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  document.category,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF412963),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
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

  void _viewAllDocuments(String title, bool isSlideView) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentListScreen(
          title: title,
          isSlideView: isSlideView, documents: [],
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
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
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
                ? _buildSlidesContent()
                : _buildPdfContent(),
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

  Widget _buildSlidesContent() {
    if (_isSlidesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _fetchSlides,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(true),
            const SizedBox(height: 16),
            _buildDocumentCarousel(
              'Recent Slides',
              _slides.take(5).toList(),
              () => _viewAllDocuments('Recent Slides', true),
            ),
            if (_slides.length > 5) ...[
              const SizedBox(height: 16),
              _buildDocumentCarousel(
                'More Slides',
                _slides.skip(5).take(5).toList(),
                () => _viewAllDocuments('More Slides', true),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPdfContent() {
    if (_isTextsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _fetchTexts,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(false),
            const SizedBox(height: 16),
            _buildDocumentCarousel(
              'Recent PDFs',
              _texts.take(5).toList(),
              () => _viewAllDocuments('Recent PDFs', false),
            ),
            if (_texts.length > 5) ...[
              const SizedBox(height: 16),
              _buildDocumentCarousel(
                'More PDFs',
                _texts.skip(5).take(5).toList(),
                () => _viewAllDocuments('More PDFs', false),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
