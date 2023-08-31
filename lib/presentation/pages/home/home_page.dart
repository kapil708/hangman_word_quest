import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hangman_word_quest/core/extensions/textstyle_extensions.dart';

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
        bottom: PreferredSize(
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
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const VSpace(8),
              Image.network(
                "https://images.squarespace-cdn.com/content/v1/520eab84e4b02d5660581bbb/1560907169107-RQNT2337VK26WH9ZAUPS/matt-anderson-duckduckgo-hero-banner-illustration-space-spread.png?format=2500w",
                height: 150,
                width: MediaQuery.sizeOf(context).width,
                fit: BoxFit.cover,
              ),
              const VSpace(16),
              Text(
                "Categories",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const VSpace(16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://is3-ssl.mzstatic.com/image/thumb/Purple122/v4/e0/c2/38/e0c238f0-4d6f-c3a8-105e-a8cc633cd31b/AppIcon-106105-0-0-1x_U007emarketing-0-0-0-10-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/512x512bb.jpg",
                          height: 48,
                          width: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const HSpace(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Maths",
                              style: Theme.of(context).textTheme.titleLarge,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              "Completed 20 out of 100 Questions",
                              style: Theme.of(context).textTheme.labelSmall?.textColor(Theme.of(context).colorScheme.outline),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const HSpace(16),
                      const Stack(
                        alignment: Alignment.center,
                        children: [
                          Text("60"),
                          CircularProgressIndicator(value: 0.6, backgroundColor: Colors.white24),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const VSpace(8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://cdn-icons-png.flaticon.com/128/10089/10089731.png",
                          height: 48,
                          width: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const HSpace(16),
                      Expanded(
                        child: Text(
                          "History",
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const HSpace(16),
                      TextButton(onPressed: () {}, child: const Text("Play")),
                    ],
                  ),
                ),
              ),
              const VSpace(16),
              GridView.builder(
                itemCount: 4,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://img.freepik.com/free-vector/cute-astronaut-box-cartoon-icon-illustration-science-technology-concept-flat-cartoon-style_138676-1998.jpg?t=st=1693475934~exp=1693476534~hmac=e3bcef6a29c9d5ac783874d2aaab8189f491361441162fd529d6c57e32b11aa7",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Expanded(
                          child: Text(
                            "Space",
                            style: Theme.of(context).textTheme.headlineMedium?.semiBold.textColor(Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const VSpace(16),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  return state is CategoryLoaded
                      ? ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: state.categoryList.length,
                          itemBuilder: (_, index) {
                            CategoryEntity category = state.categoryList[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        category.image,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const HSpace(24),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            category.name,
                                            style: Theme.of(context).textTheme.titleLarge,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                          const VSpace(2),
                                          Text(
                                            "10 Questions",
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          const VSpace(8),
                                          SizedBox(
                                            height: 30,
                                            child: FilledButton(
                                              onPressed: () {},
                                              child: const Text("Play now"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const VSpace(10);
                          },
                        )
                      : state is CategoryLoading
                          ? const CircularProgressIndicator()
                          : state is CategoryFailed
                              ? Text(state.message)
                              : const Text("Category init");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
