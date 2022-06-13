import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/model/address_finder.dart';
import 'package:q4me/model/faq.dart';
import 'package:q4me/model/privacy_policy_model.dart';
import 'package:q4me/model/profile.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/flavor_config.dart';
import 'package:q4me/utils/interceptor.dart';

class NewApi {
  final Dio _dio = new Dio();

  DioCacheManager _dioCacheManager;
  Options _cacheOptions;
  final String _baseUrl = Config.baseUrl;
  final Connectivity _connectivity = Connectivity();

  SharedPreferencesManager sharedPreferencesManager =
      locator<SharedPreferencesManager>();
  NewApi() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = 20000;
    _dioCacheManager = DioCacheManager(CacheConfig(baseUrl: _baseUrl));
    _dio.interceptors.add(DioLoggingInterceptors());
    _dio.interceptors.add(_dioCacheManager.interceptor);
    _cacheOptions = buildCacheOptions(Duration(days: 7),
        options: Options(
          headers: {'Content-Type': 'application/json', 'requirestoken': true},
        ));
  }

  clearCache({String endpoint}) async {
    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    try {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        await _dioCacheManager.deleteByPrimaryKey(_baseUrl + endpoint);
        _dioCacheManager.clearAll();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Faq>> fetchFaqData() async {
    try {
      final response = await _dio.get(
        '/api/faq/',
        options: Options(
          headers: {'Content-Type': 'application/json', 'requirestoken': true},
        ),
      );
      if (response.statusCode == 200) return Faq.mapArray(response.data);
    } on DioError catch (e) {
      print('=========== faq response ========= \n${e.response.data}');
      switch (e.response.statusCode) {
        case 400:
          Get.snackbar("Faq Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 404:
          Get.snackbar("Faq Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 502:
          Get.snackbar("Faq Error", "Something went wrong.");
          return null;
          break;

        default:
          return null;
      }
    }
    return null;
  }

  Future<List<PrivacyPolicy>> fetchPrivacyPolicyData() async {
    try {
      final response = await _dio.get(
        '/api/privacy-policy/',
        options: Options(
          headers: {'Content-Type': 'application/json', 'requirestoken': true},
        ),
      );
      if (response.statusCode == 200)
        return PrivacyPolicy.mapArray(response.data);
    } on DioError catch (e) {
      print(
          '=========== PrivacyPolicy response ========= \n${e.response.data}');
      switch (e.response.statusCode) {
        case 400:
          Get.snackbar("PrivacyPolicy Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 404:
          Get.snackbar("PrivacyPolicy Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 502:
          Get.snackbar("PrivacyPolicy Error", "Something went wrong.");
          return null;
          break;

        default:
          return null;
      }
    }
    return null;
  }

  Future<List<PrivacyPolicy>> fetchTermsOfUseData() async {
    try {
      final response = await _dio.get(
        '/api/terms-condition/',
        options: Options(
          headers: {'Content-Type': 'application/json', 'requirestoken': true},
        ),
      );
      if (response.statusCode == 200)
        return PrivacyPolicy.mapArray(response.data);
    } on DioError catch (e) {
      print('=========== TermsOfUse response ========= \n${e.response.data}');
      switch (e.response.statusCode) {
        case 400:
          Get.snackbar("TermsOfUse Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 404:
          Get.snackbar("TermsOfUse Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 502:
          Get.snackbar("TermsOfUse Error", "Something went wrong.");
          return null;
          break;

        default:
          return null;
      }
    }
    return null;
  }

  Future<AddressFinder> fetchAddressFinder({String postCode}) async {
    try {
      final response = await Dio().get(
          'https://api.craftyclicks.co.uk/address/1.1/find',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
          queryParameters: {
            "key": 'e5aa2-d0599-782ed-07bbd',
            'query': postCode,
            'country': 'GB'
          });
      print(response);
      if (response.statusCode == 200)
        return AddressFinder.fromJson(response.data);
    } on DioError catch (e) {
      print(e.response);
      print('=========== FetchAddress response ========= \n${e.response.data}');
      switch (e.response.statusCode) {
        case 400:
          Get.snackbar("FetchAddress Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 404:
          Get.snackbar("FetchAddress Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 502:
          Get.snackbar("FetchAddress Error", "Something went wrong.");
          return null;
          break;

        default:
          return null;
      }
    }
    return null;
  }

  Future<String> getChangePw({Map body}) async {
    try {
      final response = await _dio.post(
        '/api/change/password/',
        data: body,
        options: Options(
          headers: {'Content-Type': 'application/json', 'requirestoken': true},
        ),
      );
      if (response.statusCode == 200) {
        if (response.data["current_password"] != null) {
          return "${response.data["current_password"]}."
              .replaceAll(RegExp(r"[^\s\w]"), '');
        } else if (response.data["password"] != null) {
          return "${response.data["password"]}"
              .replaceAll(RegExp(r"[^\s\w]"), '');
        } else if (response.data["confirm_password"] != null) {
          return "${response.data["confirm_password"]}"
              .replaceAll(RegExp(r"[^\s\w]"), '');
        } else if (response.data["non_field_errors"] != null) {
          return "${response.data["non_field_errors"]}"
              .replaceAll(RegExp(r"[^\s\w]"), '');
        } else {
          return "${response.data["msg"]}".replaceAll(RegExp(r"[^\s\w]"), '');
        }
      }
      ;
    } on DioError catch (e) {
      Fluttertoast.showToast(msg: "${e.response}");
      print(e.response);
      print('=========== FetchAddress response ========= \n${e.response.data}');
      switch (e.response.statusCode) {
        case 400:
          Get.snackbar("FetchAddress Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 404:
          Get.snackbar("FetchAddress Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 502:
          Get.snackbar("FetchAddress Error", "Something went wrong.");
          return null;
          break;

        default:
          return null;
      }
    }
    return null;
  }

  Future<Profile> fetchProfileInfo() async {
    try {
      final response = await _dio.get(
        '/api/user/information/retrieve/',
        options: Options(
          headers: {'Content-Type': 'application/json', 'requirestoken': true},
        ),
      );
      if (response.statusCode == 200) return Profile.fromJson(response.data);
    } on DioError catch (e) {
      print('=========== Profile response ========= \n${e.response.data}');
      switch (e.response.statusCode) {
        case 400:
          Get.snackbar("Profile Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 404:
          Get.snackbar("Profile Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 502:
          Get.snackbar("Profile Error", "Something went wrong.");
          return null;
          break;

        default:
          return null;
      }
    }
    return null;
  }

  Future postAddresss({Map body}) async {
    try {
      print(body);
      final response = await _dio.post(
        '/api/user/information/',
        data: body,
        options: Options(headers: {'requirestoken': true}),
      );
      if (response.statusCode == 200) return response.statusMessage;
    } on DioError catch (e) {
      print(
          '=========== Address update response ========= \n${e.response.data}');
      switch (e.response.statusCode) {
        case 400:
          Get.snackbar("Address update Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 404:
          Get.snackbar("Address update Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 502:
          Get.snackbar("Address update Error", "Something went wrong.");
          return null;
          break;

        default:
          return null;
      }
    }
    return null;
  }

  Future postNpsRating({Map body}) async {
    try {
      print(body);
      final response = await _dio.post(
        '/api/rate/component/',
        data: body,
        options: Options(headers: {'requirestoken': true}),
      );
      if (response.statusCode == 201)
        return true;
      else
        Get.snackbar("Nps Rating  Error", "Could not complete your request.",
            backgroundColor: Colors.white);
      return false;
    } on DioError catch (e) {
      print('=========== Nps Rating response ========= \n${e.response.data}');
      switch (e.response.statusCode) {
        case 400:
          Get.snackbar("Nps Rating  Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 404:
          Get.snackbar("Nps Rating Error", "${e.response.data["error"]}",
              backgroundColor: Colors.white);
          return null;
          break;

        case 502:
          Get.snackbar("Nps Rating  Error", "Something went wrong.");
          return null;
          break;

        default:
          return null;
      }
    }
  }
}
