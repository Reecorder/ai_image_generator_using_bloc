part of 'home_bloc_bloc.dart';

@immutable
sealed class HomeBlocState {}

final class HomeBlocInitialState extends HomeBlocState {}

final class HomeBlocPromptLoadingState extends HomeBlocState {}

final class HomeBlocPromptErrorState extends HomeBlocState {}

final class HomeBlocPromptSuccessState extends HomeBlocState {
  final Uint8List unit8List;
  HomeBlocPromptSuccessState({required this.unit8List});
}

final class HomeBlocActionState extends HomeBlocState {}

final class ImageDownloadLoadingState extends HomeBlocActionState {
  final String message;

  ImageDownloadLoadingState({required this.message});
}

final class ImageDownloadSuccessState extends HomeBlocActionState {
  final String message;

  ImageDownloadSuccessState({required this.message});
}

final class ImageDownloadErrorState extends HomeBlocActionState {}
