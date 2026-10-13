import 'package:dio/dio.dart';
import 'package:gallery_app/core/exception/exception.dart';
import '../../../../core/constant/constant.dart';
import '../../../../core/constant/string_values.dart';
import '../models/gallery_image.dart';

class ImageApiService {
  final Dio _dio;

  ImageApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 20),
              headers: {'Accept-Version': 'v1'},
            ),
          );

  Future<List<GalleryImage>> fetchImages({
    required int page,
    required String query,
    int perPage = 30,
  }) async {
    try {
      final response = await _dio.get(
        imgEndPoint,
        queryParameters: {
          'client_id': accessKey,
          'per_page': perPage,
          'page': page,
        },
      );
      final List<dynamic> data = response.data;
      print("skldfndskjfkdsnfkjdsfkjdskjf${data.length}");
      return data.map((e) => GalleryImage.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResponseException(message: connectionTimeOut);
      }
      throw ResponseException(message: checkInternetConnection);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<GalleryImage>> searchImages({
    required int page,
    required String query,
    int perPage = 30,
  }) async {
    try {
      final response = await _dio.get(
        searchingImgEndPoint,
        queryParameters: {
          'client_id': accessKey,
          'query': query,
          'per_page': perPage,
          'page': page,
        },
      );
      print('response status code is ::: ${response.statusCode}');
      print('response status code is ::: ${response.statusMessage}');
      print('response status code is121212121 ::: ${response.data}');
      final List<dynamic> data = response.data['results'];
      print("search Image api response is ------${data.length}--=---$data");
      return data.map((e) => GalleryImage.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ResponseException(message: connectionTimeOut);
      }
      throw ResponseException(message: checkInternetConnection);
    } catch (e) {
      rethrow;
    }
  }
}
