import 'package:blog_app_supabase/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSources {
  void uploadLocalBlogs({required List<BlogModel> blogs});

  List<BlogModel> loadBlogs();
}

//  create a concrete class

class BlogLocalDataSourcesImpl implements BlogLocalDataSources {
  final Box box;
  BlogLocalDataSourcesImpl(this.box);

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fromJson(box.get(i.toString())));
      }
    });
    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    // remove the all existing data in the box ,,  start fresh
    blogs.clear();

    box.write(() {
      for (int i = 0; i <= blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
