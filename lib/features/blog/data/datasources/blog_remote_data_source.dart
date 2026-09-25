import 'dart:io';

import 'package:blog_app_supabase/core/error/exceptions.dart';
import 'package:blog_app_supabase/core/error/failure.dart';
import 'package:blog_app_supabase/core/networks/connection_checker.dart';
import 'package:blog_app_supabase/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  // for uploading the images separately
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  //  display the created blogs
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  final ConnectionChecker connectionChecker;
  BlogRemoteDataSourceImpl(this.supabaseClient,this.connectionChecker);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blog.toJson())
          .select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage
          .from('blog_images')
          .upload(
            blog.id, // '${blog.id}/image',  blog.id  ---  remains the folder name
            image,
          );

      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      // need to get the name field from profile table , we operated a join operation
      final blogs = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)');
      //  if we want to know how the blog lis is look like --  just print it
      return blogs
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(posterName: blog['profiles']['name']),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerExceptions(e.message);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
