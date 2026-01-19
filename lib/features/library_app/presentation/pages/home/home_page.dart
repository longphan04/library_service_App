import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/book.dart';
import '../../bloc/book/book_bloc.dart';
import '../../widgets/section_header.dart';
import '../book/hot_list.dart';
import '../book/list_books.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load books when page opens
    context.read<BookBloc>().add(const LoadBooksEvent(page: 1, limit: 20));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(
      builder: (context, state) {
        // Get books from state
        List<Book> books = [];

        if (state is ListBooksFailure) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is ListBooksLoaded) {
          books = state.books;
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: 'Hot List', color: Colors.orange),
                const HotList(),
                SectionHeader(
                  title: 'Mới nhất',
                  color: Colors.green,
                  showViewAll: true,
                  onViewAll: () {
                    // Handle view all action
                  },
                ),
                SizedBox(
                  height: books.length < 4 ? 250 : 0,
                  child: books.length < 4
                      ? const Center(child: CircularProgressIndicator())
                      : null,
                ),
                ListBooks(
                  books: books.sublist(0, books.length < 4 ? books.length : 4),
                ),
                const SizedBox(height: 10),
                SectionHeader(title: 'Đề xuất', color: Colors.blue),
                SizedBox(
                  height: books.length < 4 ? 250 : 0,
                  child: books.length < 4
                      ? const Center(child: CircularProgressIndicator())
                      : null,
                ),
                ListBooks(books: books),
              ],
            ),
          ),
        );
      },
    );
  }
}
