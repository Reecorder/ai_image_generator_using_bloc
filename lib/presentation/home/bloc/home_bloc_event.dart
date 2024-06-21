part of 'home_bloc_bloc.dart';

@immutable
sealed class HomeBlocEvent {}

class PromptInitialEvent extends HomeBlocEvent {}

class PromptEnteredEvent extends HomeBlocEvent {
  final String text;
  PromptEnteredEvent({required this.text});
}

class ImageDownloadEvent extends HomeBlocEvent {
  final Uint8List image;

  ImageDownloadEvent({required this.image});
}
