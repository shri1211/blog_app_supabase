import 'dart:io';

import 'package:blog_app_supabase/core/error/exceptions.dart';
import 'package:blog_app_supabase/core/error/failure.dart';
import 'package:blog_app_supabase/core/networks/connection_checker.dart';
import 'package:blog_app_supabase/features/blog/data/datasources/blog_local_data_sources.dart';
import 'package:blog_app_supabase/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app_supabase/features/blog/data/models/blog_model.dart';
import 'package:blog_app_supabase/features/blog/domain/entities/blog.dart';
import 'package:blog_app_supabase/features/blog/domain/repositories/blog_repositories.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoriesImpl implements BlogRepositories {
  final BlogRemoteDataSource blogRemoteDataSource;
  final ConnectionChecker connectionChecker;
  final BlogLocalDataSources blogLocalDataSources;
  BlogRepositoriesImpl(
    this.blogRemoteDataSource,
    this.blogLocalDataSources,
    this.connectionChecker,
  );
  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet message'));
      }
      BlogModel blogModel = BlogModel(
        id: Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      //  we uploaded the model to the supabase storage
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      // we uploading the model to the supabase Database
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return right(uploadedBlog);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      //  if internet connection is not there , fetch data from local storage
      if (!await (connectionChecker.isConnected)) {
        final blogs = blogLocalDataSources.loadBlogs();
        return right(blogs);
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();
      //  if internet connection is there upload to local storage then return
      blogLocalDataSources.uploadLocalBlogs(blogs: blogs);

      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}
