import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:ai_image_generator_using_bloc/presentation/home/repo/promt_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:meta/meta.dart';

part 'home_bloc_event.dart';
part 'home_bloc_state.dart';

class HomeBlocBloc extends Bloc<HomeBlocEvent, HomeBlocState> {
  HomeBlocBloc() : super(HomeBlocInitialState()) {
    on<PromptInitialEvent>(promptInitialEvent);
    on<PromptEnteredEvent>(enteredEvent);
    on<ImageDownloadEvent>(imageDownloadEvent);
  }

  FutureOr<void> enteredEvent(
      PromptEnteredEvent event, Emitter<HomeBlocState> emit) async {
    emit(HomeBlocPromptLoadingState());
    Uint8List? bytes = await PromptRepo.generateImage(event.text);

    // log("kjnneddn=> " + bytes.toString());
    if (bytes == null) {
      emit(HomeBlocPromptErrorState());
      await Future.delayed(const Duration(seconds: 5), () {
        emit(HomeBlocInitialState());
        log("Error State=> 3");
      });
    } else {
      log("Success=> 1");
      emit(HomeBlocPromptSuccessState(unit8List: bytes));
      await Future.delayed(const Duration(seconds: 5), () {
        emit(HomeBlocInitialState());
        log("Success=> 2");
      });
    }
  }

  FutureOr<void> promptInitialEvent(
      PromptInitialEvent event, Emitter<HomeBlocState> emit) {
    emit(HomeBlocInitialState());
  }

  FutureOr<void> imageDownloadEvent(
      ImageDownloadEvent event, Emitter<HomeBlocState> emit) async {
    emit(ImageDownloadLoadingState(message: "Downloading image..."));

    await ImageGallerySaver.saveImage(Uint8List.fromList(event.image),
        quality: 60, name: "@Artistry ${DateTime.now()}");

    await Future.delayed(const Duration(seconds: 3), () {
      emit(ImageDownloadSuccessState(
          message: "Image was successfully downloaded"));
    });
  }
}
