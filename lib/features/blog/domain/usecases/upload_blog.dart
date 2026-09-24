import 'dart:io';
import 'package:blog_app_supabase/core/error/failure.dart';
import 'package:blog_app_supabase/core/usecase/usecase.dart';
import 'package:blog_app_supabase/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';
import '../entities/blog.dart';

class UploadBlog implements UseCases<Blog, UploadBlogParams> {
  final BlogRepositories blogRepositories;
  UploadBlog(this.blogRepositories);
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepositories.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
