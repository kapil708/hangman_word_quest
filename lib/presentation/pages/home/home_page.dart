import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/spacing.dart';
import '../../../core/route/route_names.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../injection_container.dart';
import '../../bloc/category/category_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator.get<CategoryBloc>()..add(CategoryLoading()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final double cardWidth = (MediaQuery.sizeOf(context).width / 2) - 10;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            onPressed: () => context.goNamed(RouteName.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            key: const Key('1'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  "https://images.squarespace-cdn.com/content/v1/520eab84e4b02d5660581bbb/1560907141786-R0QFQ5OCXKO1U1Y2DOWR/matt-anderson-duckduckgo-hero-banner-illustration-river-sunset-simplify.png?format=2500w",
                  height: 150,
                  width: MediaQuery.sizeOf(context).width,
                  fit: BoxFit.cover,
                ),
                const VSpace(24),
                Text(
                  "Categories",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const VSpace(16),
              ],
            ),
          ),
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              return state is CategoryLoaded
                  ? SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.39,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        childCount: state.categoryList.length,
                        (context, index) {
                          CategoryEntity category = state.categoryList[index];
                          return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    category.image,
                                    height: 100,
                                    width: cardWidth,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text(
                                    category.name,
                                    style: Theme.of(context).textTheme.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : state is CategoryLoading
                      ? const SliverToBoxAdapter(key: Key('2'), child: CircularProgressIndicator())
                      : state is CategoryFailed
                          ? SliverToBoxAdapter(key: const Key('3'), child: Text(state.message))
                          : const SliverToBoxAdapter(key: Key('4'), child: Text("Category init"));
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 80.0))
        ],
      ),
    );
  }
}
