import 'package:flutter/material.dart';
class ShopHomePage extends StatelessWidget {
  const ShopHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayurvedic Shop',
      theme: ThemeData(
        primaryColor: Colors.green[800],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green[800]!,
          primary: Colors.green[800]!,
          secondary: Colors.green[600]!,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[800],
            foregroundColor: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.green[800],
        ),
      ),
      home: const AyurvedicHomePage(),
    );
  }
}

// Model class for Ayurvedic products
class AyurvedicProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String category;
  final double rating;
  final List<String> benefits;
  final String dosage;

  AyurvedicProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.category,
    this.rating = 0.0,
    required this.benefits,
    required this.dosage,
  });
}

class AyurvedicHomePage extends StatefulWidget {
  const AyurvedicHomePage({Key? key}) : super(key: key);

  @override
  State<AyurvedicHomePage> createState() => _AyurvedicHomePageState();
}

class _AyurvedicHomePageState extends State<AyurvedicHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<AyurvedicProduct> _allProducts = [];
  List<AyurvedicProduct> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _filteredProducts = _allProducts;
  }

  void _loadProducts() {
    // In real app, this would be an API call or database fetch
    _allProducts = [
      AyurvedicProduct(
        id: '1',
        name: 'Ashwagandha Powder',
        description: 'Organic Ashwagandha root powder known for reducing stress and anxiety. A powerful adaptogen that helps the body manage stress.',
        price: 19.99,
        images: ['assets/ashwagandha1.jpg', 'assets/ashwagandha2.jpg', 'assets/ashwagandha3.jpg'],
        category: 'Herbs',
        rating: 4.7,
        benefits: ['Stress reduction', 'Improved sleep', 'Increased energy', 'Enhanced focus'],
        dosage: '1/2 teaspoon daily mixed with warm milk or water',
      ),
      AyurvedicProduct(
        id: '2',
        name: 'Triphala Capsules',
        description: 'Traditional Ayurvedic formulation of three fruits that promotes digestion and detoxification.',
        price: 24.99,
        images: ['assets/triphala1.jpg', 'assets/triphala2.jpg'],
        category: 'Supplements',
        rating: 4.5,
        benefits: ['Digestive health', 'Detoxification', 'Immunity support'],
        dosage: '2 capsules before bed with warm water',
      ),
      AyurvedicProduct(
        id: '3',
        name: 'Brahmi Oil',
        description: 'Cooling hair oil that promotes hair growth and reduces stress when used for head massage.',
        price: 15.99,
        images: ['assets/brahmi1.jpg', 'assets/brahmi2.jpg'],
        category: 'Oils',
        rating: 4.6,
        benefits: ['Hair strength', 'Stress relief', 'Improved sleep'],
        dosage: 'Apply to scalp and massage gently twice a week',
      ),
      AyurvedicProduct(
        id: '4',
        name: 'Chyawanprash',
        description: 'Traditional immunity booster made with herbs, honey and amla (Indian gooseberry).',
        price: 21.99,
        images: ['assets/chyawanprash1.jpg', 'assets/chyawanprash2.jpg'],
        category: 'Immunity',
        rating: 4.8,
        benefits: ['Immunity boost', 'Antioxidant properties', 'Energy enhancement'],
        dosage: '1 tablespoon daily in the morning',
      ),
      AyurvedicProduct(
        id: '5',
        name: 'Neem Face Pack',
        description: 'Natural face pack to purify skin and treat acne and blemishes.',
        price: 12.99,
        images: ['assets/neem1.jpg', 'assets/neem2.jpg'],
        category: 'Skincare',
        rating: 4.3,
        benefits: ['Acne treatment', 'Skin purification', 'Reduces blemishes'],
        dosage: 'Apply on face for 15 minutes twice a week',
      ),
      AyurvedicProduct(
        id: '6',
        name: 'Tulsi Tea',
        description: 'Holy Basil tea that boosts immunity and helps with respiratory health.',
        price: 9.99,
        images: ['assets/tulsi1.jpg', 'assets/tulsi2.jpg'],
        category: 'Teas',
        rating: 4.4,
        benefits: ['Respiratory health', 'Stress reduction', 'Immunity support'],
        dosage: 'Steep one teabag in hot water for 5 minutes, 2-3 times daily',
      ),
    ];
  }

  void _searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayurvedic Wellness'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Ayurvedic products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.green[800]!),
                ),
              ),
              onChanged: _searchProducts,
            ),
          ),

          // Categories
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryItem('Herbs', Icons.eco),
                _buildCategoryItem('Supplements', Icons.medication),
                _buildCategoryItem('Oils', Icons.opacity),
                _buildCategoryItem('Skincare', Icons.face),
                _buildCategoryItem('Teas', Icons.local_drink),
                _buildCategoryItem('Immunity', Icons.health_and_safety),
              ],
            ),
          ),

          // Recommended products title
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ayurvedic Essentials',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Product Grid
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(child: Text('No products found'))
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                return _buildProductCard(_filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(
              category: title,
              products: _allProducts,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.green[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(AyurvedicProduct product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  image: DecorationImage(
                    image: AssetImage(product.images.first),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[800],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(
                          product.rating.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Product details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.add_shopping_cart,
                        size: 20,
                        color: Colors.green[800],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Product Detail Page with image slider
class ProductDetailPage extends StatefulWidget {
  final AyurvedicProduct product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image slider
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.product.images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Image.asset(
                      widget.product.images[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
                // Image indicator
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.product.images.length,
                          (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index
                              ? Colors.green[800]
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(
                        ' ${widget.product.rating} | ',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Category: ${widget.product.category}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Benefits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.product.benefits.map((benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[800], size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(benefit)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 16),
                  const Text(
                    'Recommended Usage',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.green[800]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.product.dosage,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Customer Reviews',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildReviewItem(
                    name: 'Priya S.',
                    rating: 5.0,
                    comment: 'This product has helped me tremendously with stress reduction. Highly recommend!',
                    date: '2 days ago',
                  ),
                  _buildReviewItem(
                    name: 'Amit R.',
                    rating: 4.0,
                    comment: 'Good quality product, but took some time to show results.',
                    date: '1 week ago',
                  ),
                ],
              ),
            ),
          ),

          // Add to cart button
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${widget.product.name} added to cart'),
                          backgroundColor: Colors.green[800],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String name,
    required double rating,
    required String comment,
    required String date,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                date,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: List.generate(
              5,
                  (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(comment),
          const Divider(height: 24),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Category Page class
class CategoryPage extends StatelessWidget {
  final String category;
  final List<AyurvedicProduct> products;

  const CategoryPage({
    Key? key,
    required this.category,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter products by category
    final categoryProducts = products
        .where((product) => product.category == category)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: Column(
        children: [
          // Category banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.green[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getCategoryDescription(category),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          // Products list
          Expanded(
            child: categoryProducts.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('No products in this category'),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categoryProducts.length,
              itemBuilder: (context, index) {
                final product = categoryProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                              image: DecorationImage(
                                image: AssetImage(product.images.first),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green[800],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    Text(
                                      product.rating.toString(),
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[800],
                                    ),
                                  ),
                                  Icon(
                                    Icons.add_shopping_cart,
                                    size: 20,
                                    color: Colors.green[800],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case 'Herbs':
        return 'Traditional Ayurvedic herbs with healing properties';
      case 'Supplements':
        return 'Natural supplements to enhance your health and wellness';
      case 'Oils':
        return 'Therapeutic oils for massage and holistic treatments';
      case 'Skincare':
        return 'Natural skincare products based on Ayurvedic principles';
      case 'Teas':
        return 'Herbal teas with healing properties for mind and body';
      case 'Immunity':
        return 'Products designed to boost your natural immunity';
      default:
        return 'Explore our range of Ayurvedic products';
    }
  }
}