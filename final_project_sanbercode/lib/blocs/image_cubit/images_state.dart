part of 'images_cubit.dart';

class ImagesState extends Equatable {
  final String? linkGambar;
  final bool isLoading;
  final double uploadProgress;
  final String errorMessage;

  const ImagesState({
    this.linkGambar,
    this.isLoading = false,
    this.uploadProgress = 0,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [linkGambar, isLoading, uploadProgress];
}
