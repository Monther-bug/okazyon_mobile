import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:okazyon_mobile/core/constants/image_strings.dart';
import 'package:okazyon_mobile/core/constants/sizes.dart';
import 'package:okazyon_mobile/features/home/presentation/widgets/category_card.dart';
import 'package:okazyon_mobile/features/home/presentation/widgets/deal_of_the_day_card.dart';
import 'package:okazyon_mobile/features/home/presentation/widgets/featured_deal_card.dart';
import 'package:okazyon_mobile/features/home/presentation/widgets/home_header.dart';
import 'package:okazyon_mobile/features/home/presentation/widgets/search_bar.dart';
import 'package:okazyon_mobile/features/home/presentation/widgets/section_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HomeHeader(),
            Padding(
              padding: EdgeInsets.all(AppSizes.defaultSpace),
              child: Column(
                children: [
                  const HomeSearchBar(),
                  SizedBox(height: AppSizes.spaceBtwSections),
                  Row(
                    children: [
                      Expanded(
                        child: CategoryCard(
                          title: 'Fresh Deals',
                          subtitle: 'Food & Groceries',
                          color: Color(0xFFE6F2E8),
                          image: AppImageStrings.freshDeals,
                        ),
                      ),
                      SizedBox(width: AppSizes.spaceBtwItems),
                      Expanded(
                        child: CategoryCard(
                          title: 'Store Finds',
                          subtitle: 'Apparel & Goods',
                          color: Color(0xFFE3F2F8),
                          image: AppImageStrings.storeFinds,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.spaceBtwSections),
                  const DealOfTheDayCard(),
                  SizedBox(height: AppSizes.spaceBtwSections),
                  SectionHeader(title: 'Featured Deals', onPressed: () {}),
                  SizedBox(height: AppSizes.spaceBtwItems),
                  _buildFeaturedDeals(),
                  SizedBox(height: AppSizes.spaceBtwSections),
                  SectionHeader(title: 'New Arrivals', onPressed: () {}),
                  SizedBox(height: AppSizes.spaceBtwItems),
                  _buildFeaturedDeals(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedDeals() {
    return SizedBox(
      height: 240,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FeaturedDealCard(
            image: AppImageStrings.headphones,
            title: 'Wireless Headphones',
            price: 49,
            originalPrice: 70,
            discount: 30,
            rating: 4.8,
          ),
          SizedBox(width: AppSizes.spaceBtwItems),
          FeaturedDealCard(
            image: AppImageStrings.coffee,
            title: 'Premium Coffee Beans',
            price: 15,
            originalPrice: 20,
            discount: 25,
            rating: 4.6,
          ),
          SizedBox(width: AppSizes.spaceBtwItems),
          FeaturedDealCard(
            image: AppImageStrings.jacket,
            title: 'Winter Jacket',
            price: 60,
            originalPrice: 120,
            discount: 50,
            rating: 4.9,
          ),
        ],
      ),
    );
  }
}
