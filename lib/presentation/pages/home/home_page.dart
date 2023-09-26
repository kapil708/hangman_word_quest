import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hangman_word_quest/core/extensions/text_style_extensions.dart';

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
    final double cardWidth = (MediaQuery.sizeOf(context).width / 2);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            context.read<CategoryBloc>().add(LinkWordIds());
          },
          child: const Text("Hangman"),
          //child: Text(l10n.home),
        ),
        actions: [
          IconButton(
            onPressed: () => context.goNamed(RouteName.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
        /*bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, ",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "Kapil R Singh ",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                ClipOval(
                  child: InkWell(
                    onTap: () => context.goNamed(RouteName.settings),
                    child: Image.network(
                      "https://images.unsplash.com/photo-1584999734482-0361aecad844?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2960&q=80",
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),*/
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VSpace(8),

              // Banner
              Image.network(
                "https://images.squarespace-cdn.com/content/v1/520eab84e4b02d5660581bbb/1560907169107-RQNT2337VK26WH9ZAUPS/matt-anderson-duckduckgo-hero-banner-illustration-space-spread.png?format=2500w",
                height: 150,
                width: MediaQuery.sizeOf(context).width,
                fit: BoxFit.cover,
              ),
              const VSpace(16),

              // Categories
              Text(
                l10n.categories,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const VSpace(16),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  return state is CategoryLoaded
                      ? GridView.builder(
                          itemCount: state.categoryList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            CategoryEntity category = state.categoryList[index];
                            return InkWell(
                              onTap: () => context.goNamed(
                                RouteName.gamePlay,
                                queryParameters: {
                                  'categoryId': category.id,
                                  'categoryName': category.name,
                                },
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Image.network(
                                      category.image,
                                      height: cardWidth,
                                      width: cardWidth,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      color: Colors.black26,
                                      width: MediaQuery.sizeOf(context).width,
                                      child: Text(
                                        category.name,
                                        style: Theme.of(context).textTheme.titleLarge?.semiBold.textColor(Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : state is CategoryFailed
                          ? Text(state.message)
                          : state is CategoryLoading
                              ? const CircularProgressIndicator()
                              : const Text("Category init");
                },
              ),

              const VSpace(32),
            ],
          ),
        ),
      ),
    );
  }
}
