part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

// here we are doing 2 states for success because one is for after creating blog and other is for fetching the blog from supabase
final class BlogUploadSuccess extends BlogState {
  BlogUploadSuccess(List<dynamic> list);
}

final class BlogDisplaySuccess extends BlogState {
  final List<Blog> blog;
  BlogDisplaySuccess(this.blog);
}

final class BlogFailure extends BlogState {
  final String error;
  BlogFailure(this.error);
}
