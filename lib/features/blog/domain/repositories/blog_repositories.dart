import 'dart:io';
import 'package:blog_app_supabase/core/error/failure.dart';
import 'package:blog_app_supabase/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

// passing the parameters from remote to interface
abstract interface class BlogRepositories {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });
//  display blogs
  Future<Either<Failure, List<Blog>>> getAllBlogs();
}
