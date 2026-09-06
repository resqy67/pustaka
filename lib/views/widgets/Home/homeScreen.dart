import 'package:flutter/material.dart';
import 'package:pustaka/data/models/users.dart';
import 'package:pustaka/data/services/auth_service.dart';
import 'package:pustaka/views/components/book/index.dart';
import 'package:pustaka/data/services/get_service.dart';
import 'package:pustaka/data/services/post_service.dart';
import 'package:pustaka/data/models/book.dart';
import 'package:pustaka/views/components/search.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _getService = GetService();
  final AuthService _authService = AuthService();

  int page = 1;
  GetUser? _getUser;
  List<Book> _bookList = [];
  late ScrollController _scrollController;
  bool isLoading = false;
  bool isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchBooks();
    _postToken();
    _fetchUser();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _postToken() async {
    final postService = PostService();
    postService.updateTokenFcm();
  }

  void _fetchUser() async {
    try {
      GetUser getUser = await _authService.getUser();
      if (!mounted) return;
      setState(() => _getUser = getUser);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat data pengguna')),
      );
    }
  }

  void _fetchBooks() async {
    if (isLoading || isFetchingMore) return;

    setState(() {
      page == 1 ? isLoading = true : isFetchingMore = true;
    });

    try {
      BookList bookList = await _getService.books(page.toString());
      if (!mounted) return;
      setState(() {
        _bookList.addAll(bookList.books);
        page++;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat buku: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          isFetchingMore = false;
        });
      }
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchBooks();
    }
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi,';
    if (hour < 15) return 'Selamat Siang,';
    if (hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.green[700],
          onRefresh: () async {
            page = 1;
            _bookList.clear();
            _fetchBooks();
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // --- STICKY TOP BAR (SLIVER APP BAR) ---
              SliverAppBar(
                backgroundColor: const Color(
                    0xFFFBFBFB), // Warna sama dengan background agar menyatu
                surfaceTintColor: Colors
                    .transparent, // Mencegah perubahan warna abu-abu saat di-scroll di Material 3
                elevation: 0,
                pinned:
                    true, // <-- INI KUNCINYA AGAR SEARCH SELALU MENEMPEL DI ATAS
                toolbarHeight: 90, // Ruang yang lega untuk sapaan
                titleSpacing: 24, // Jarak padding kiri-kanan
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Sapaan Kiri
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _getUser != null ? _getUser!.name : 'Memuat...',
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Aksi Kanan (Search Icon + Avatar)
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.search_rounded,
                                color: Colors.black87, size: 22),
                            onPressed: () {
                              showSearch(
                                  context: context,
                                  delegate: BookSearchDelegate(_bookList));
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.green[400]!, width: 2),
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.green.withOpacity(0.1),
                            child: Icon(Icons.person_rounded,
                                color: Colors.green[700], size: 22),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // --- BUKU TERBARU (POSTER CAROUSEL) ---
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _buildSectionHeader('Buku Terbaru', onSeeAll: () {}),
                    isLoading || _bookList.isEmpty
                        ? _buildCarouselShimmer()
                        : CarouselSlider(
                            options: CarouselOptions(
                              height: 320,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.22,
                              viewportFraction: 0.75,
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 1000),
                            ),
                            items: _bookList
                                .take(5)
                                .map((book) => _buildPosterCard(book))
                                .toList(),
                          ),
                  ],
                ),
              ),

              // --- REKOMENDASI (MINIMALIST GRID) ---
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 16),
                  child: _buildSectionHeader('Rekomendasi', onSeeAll: () {}),
                ),
              ),

              _bookList.isNotEmpty
                  ? SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 32,
                          childAspectRatio: 0.55,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // Melewati 5 buku pertama agar yang direkomendasikan berbeda dari yang di atas
                            int actualIndex = (index + 5) % _bookList.length;
                            return _buildMinimalistGridCard(
                                _bookList[actualIndex]);
                          },
                          childCount: _bookList.length > 5
                              ? _bookList.length - 5
                              : _bookList.length,
                        ),
                      ),
                    )
                  : SliverToBoxAdapter(child: _buildGridShimmer()),

              if (isFetchingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // GOKIL UI COMPONENTS
  // =========================================================================

  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          InkWell(
            onTap: onSeeAll,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                'Semua',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterCard(Book book) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BookPage(bookUuid: book.uuid))),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                book.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child:
                      const Icon(Icons.menu_book, color: Colors.grey, size: 50),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'BARU ✨',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        color: Colors.grey[300],
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
  }

  Widget _buildMinimalistGridCard(Book item) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BookPage(bookUuid: item.uuid))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  item.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // SHIMMER LOADING
  // =========================================================================
  Widget _buildCarouselShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 320,
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Widget _buildGridShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 32,
            childAspectRatio: 0.55,
          ),
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }
}
