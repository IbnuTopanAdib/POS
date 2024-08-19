import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'images_state.dart';

class ImagesCubit extends Cubit<ImagesState> {
  ImagesCubit() : super(const ImagesState());

  Future<void> uploadImage({required String path}) async {
    final imageRef = FirebaseStorage.instance.ref().child("product_images");

    try {
      emit(const ImagesState(isLoading: true));

      final randomID = "${Random().nextInt(999999)}";

      final uploadTask = imageRef.child(randomID).putFile(File(path));

      uploadTask.snapshotEvents.listen((event) {
        switch (event.state) {
          case TaskState.running:
            final progress = 100 * (event.bytesTransferred / event.totalBytes);
            emit(ImagesState(isLoading: true, uploadProgress: progress / 100));
            break;
          case TaskState.success:
            event.ref.getDownloadURL().then((value) =>
                emit(ImagesState(isLoading: false, linkGambar: value)));
            break;
          case TaskState.error:
            emit(ImagesState(errorMessage: e.toString()));
            break;
          case TaskState.canceled:
          case TaskState.paused:
            break;
        }
      });
    } catch (e) {
      emit(ImagesState(errorMessage: e.toString()));
    }
  }

  Future<void> editImage({
    required String path,
    required String imageUrl,
  }) async {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();
      final newStorageRef = FirebaseStorage.instance.ref().child(
          'product_images/${Random().nextInt(999999)}'); 
      final uploadTask = newStorageRef.putFile(File(path));
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      emit(ImagesState(isLoading: false, linkGambar: downloadUrl));
    } catch (e) {
      emit(ImagesState(errorMessage: e.toString()));
    }
  }

  Future<void> deleteImage({required String imageUrl}) async {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();
      emit(ImagesState(isLoading: false));
    } catch (e) {
      emit(ImagesState(errorMessage: e.toString()));
    }
  }

  void deleteImageLink() {
    emit(const ImagesState(linkGambar: null));
  }
}
