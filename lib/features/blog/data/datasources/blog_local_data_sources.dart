import 'package:blog_app_supabase/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSources {
  Future<void> uploadLocalBlogs({required List<BlogModel> blogs});

  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourcesImpl implements BlogLocalDataSources {
  final Box box;

  BlogLocalDataSourcesImpl(this.box);

  @override
  List<BlogModel> loadBlogs() {
    final List<BlogModel> blogs = [];

    for (final key in box.keys) {
      final blogData = box.get(key);

      if (blogData is Map) {
        //  hive deserializes maps from disk as Map<dynamic, dynamic> , so it has
        //  to be converted back before passing it to fromJson
        blogs.add(
          BlogModel.fromJson(Map<String, dynamic>.from(blogData)),
        );
      }
    }

    return blogs;
  }

  @override
  Future<void> uploadLocalBlogs({required List<BlogModel> blogs}) async {
    // Remove all existing data from Hive
    await box.clear();

    // Store fresh data
    for (int i = 0; i < blogs.length; i++) {
      await box.put(
        i.toString(),
        blogs[i].toCacheJson(),
      );
    }
  }
}