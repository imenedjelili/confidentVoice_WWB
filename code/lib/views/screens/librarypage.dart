import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confident_voice/Controllers/library_bloc.dart';
import 'package:confident_voice/models/Events/library_event.dart';

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
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Library'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
      body: _currentIndex == 0 ? _buildSlidesContent(context) : _buildTextContent(context),
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

  Widget _buildSlidesContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(context),
          const SizedBox(height: 20),
          _buildCarouselSection(
            context,
            title: "Popular Slides",
            items: List.generate(
              5,
              (index) => _buildCarouselItem(
                image: 'assets/images/slide_$index.jpg',
                title: 'Slide Title $index',
                subtitle: 'Subtitle $index',
              ),
            ),
            onViewAll: () {},
          ),
          const SizedBox(height: 20),
          _buildCarouselSection(
            context,
            title: "Recent Slides",
            items: List.generate(
              5,
              (index) => _buildCarouselItem(
                image: 'assets/images/slide_$index.jpg',
                title: 'Slide Title $index',
                subtitle: 'Subtitle $index',
              ),
            ),
            onViewAll: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(context),
          const SizedBox(height: 20),
          _buildCarouselSection(
            context,
            title: "Popular Texts",
            items: List.generate(
              5,
              (index) => _buildCarouselItem(
                image: 'assets/images/text_$index.jpg',
                title: 'Text Title $index',
                subtitle: 'Subtitle $index',
              ),
            ),
            onViewAll: () {},
          ),
          const SizedBox(height: 20),
          _buildCarouselSection(
            context,
            title: "Recent Texts",
            items: List.generate(
              5,
              (index) => _buildCarouselItem(
                image: 'assets/images/text_$index.jpg',
                title: 'Text Title $index',
                subtitle: 'Subtitle $index',
              ),
            ),
            onViewAll: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 125,
            width: MediaQuery.of(context).size.width - 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFA26DC5),
                  Color(0xFFB87D99),
                  Color(0xFFFCAC12),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Draw inspiration\nfrom the world around\nyou to fuel your creativity.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: -30,
            right: -5,
            child: Image.asset(
              'assets/images/Creativity_pana.png',
              width: 140,
              height: 140,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
    required VoidCallback onViewAll,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('View all'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem({
    required String image,
    required String title,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 200,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                image,
                height: 125,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
          ],
        ),
      ),
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
