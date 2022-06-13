import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:q4me/app/routes/app_pages.dart';
import 'package:q4me/injector/injector.dart';
import 'package:q4me/model/additional_credits_model.dart';
import 'package:q4me/model/call_status_model.dart';
import 'package:q4me/model/did_you_know_model.dart';
import 'package:q4me/model/ivr_mapping_model.dart';
import 'package:q4me/model/login_model.dart';
import 'package:q4me/model/online_status_model.dart';
import 'package:q4me/model/otp_response_model.dart';
import 'package:q4me/model/privacy_policy_model.dart';
import 'package:q4me/model/retrieve_dashboard_component_model.dart';
import 'package:q4me/model/sign_in_with_apple_login_model.dart';
import 'package:q4me/model/sign_in_with_google.dart';
import 'package:q4me/model/subscription_status_model.dart';
import 'package:q4me/model/time_breakdown_model.dart';
import 'package:q4me/model/user_stats_model.dart';
import 'package:q4me/service/user_stats_service.dart';
import 'package:q4me/storage/shared_preferences_manager.dart';
import 'package:q4me/utils/flavor_config.dart';
import 'package:q4me/utils/interceptor.dart';
import 'package:q4me/utils/string.dart';
import 'dart:developer' as dev;

class ApiAuthProvider {
  final Dio _dio = new Dio();

  DioCacheManager _dioCacheManager;
  Options _cacheOptions;
  final String _baseUrl = Config.baseUrl;
  final Connectivity _connectivity = Connectivity();

  SharedPreferencesManager sharedPreferencesManager =
      locator<SharedPreferencesManager>();

  ApiAuthProvider() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = 30000;
    _dioCacheManager = DioCacheManager(CacheConfig(baseUrl: _baseUrl));
    _dio.interceptors.add(DioLoggingInterceptors());
    _dio.interceptors.add(_dioCacheManager.interceptor);
    _cacheOptions = buildCacheOptions(Duration(days: 7),
        options: Options(
          headers: {'Content-Type': 'application/json', 'requirestoken': true},
        ));
  }

  clearCache() async {
    ConnectivityResult connectivityResult =
        await _connectivity.checkConnectivity();
    try {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        await _dioCacheManager
            .deleteByPrimaryKey(_baseUrl + '/api/dashboard-component/');
        _dioCacheManager.clearAll();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  String errors;

  Future<dynamic> loginUser(Map loginBody) async {
    try {
      final response = await _dio.post(
        '/api/login/',
        data: loginBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      print("${_baseUrl}");
      if (response.statusCode == 200) {
        if (response.data["error"] != null) {
          // Get.snackbar("Login Error", "${response.data["error"]}",
          //     backgroundColor: Colors.white);
          return null;
        } else
          return LoginResponse.fromJson(response.data);
      }
    } on DioError catch (error) {
      print("error: ${error.response.statusCode}");
      print("login error ${error.response}");

      if (error.type == DioErrorType.connectTimeout) {
        return null;
      }

      switch (error.response.statusCode) {
        case 400:
          // Get.snackbar("Login Error", "${error.response.data["error"]}",
          //     backgroundColor: Colors.white);
          errors = await error.response.data["error"]
                  .replaceAll(RegExp(r"[^\s\w]"), '') +
              error.response.statusCode.toString();
          return errors;
          break;

        case 404:
          // Get.snackbar("Login Error", "${error.response.data["error"]}",
          //     backgroundColor: Colors.white);
          errors = await error.response.data["error"]
                  .replaceAll(RegExp(r"[^\s\w]"), '') +
              error.response.statusCode.toString();
          return errors;
          break;

        case 500:
          errors = await error.response.data["error"]
                  .replaceAll(RegExp(r"[^\s\w]"), '') +
              error.response.statusCode.toString();
          // Get.snackbar("Login Error", "Something went wrong.");
          return errors;
          break;

        case 502:
          errors = await error.response.data["error"]
                  .replaceAll(RegExp(r"[^\s\w]"), '') +
              error.response.statusCode.toString();
          // Get.snackbar("Login Error", "Something went wrong.");
          return errors;
          break;
        default:
          return null;
      }
    }
    return null;
  }

  String get errorData {
    return errors;
  }

  // Future<LoginResponse> loginUser(Map loginBody) async {
  //   try {
  //     final response = await _dio.post(
  //       '/api/login/',
  //       data: loginBody,
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //       ),
  //     );
  //     print("${_baseUrl}");
  //     if (response.statusCode == 200) {
  //       if (response.data["error"] != null) {
  //         Get.snackbar("Login Error", "${response.data["error"]}",
  //             backgroundColor: Colors.white);
  //         return null;
  //       } else
  //         return LoginResponse.fromJson(response.data);
  //     }
  //   } on DioError catch (error) {
  //     print("error: ${error.response.statusCode}");
  //     print("login error ${error.response}");

  //     switch (error.response.statusCode) {
  //       case 400:
  //         Get.snackbar("Login Error!", "${error.response.data["error"]}",
  //             backgroundColor: Colors.white);
  //         return null;
  //         break;

  //       case 404:
  //         Get.snackbar("Login Error!", "${error.response.data["error"]}",
  //             backgroundColor: Colors.white);
  //         return null;
  //         break;

  //       case 502:
  //         Get.snackbar("Login Error!", "Something went wrong.",
  //             backgroundColor: Colors.white);
  //         return null;
  //         break;
  //       default:
  //         return null;
  //     }
  //   }
  //   return null;
  // }

  Future<dynamic> logout() async {
    try {
      final response = await _dio.get(
          '/api/logout/?fcm_token=${locator<SharedPreferencesManager>().getString("FCMToken")}',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'requirestoken': true,
            },
          ));
      if (response.statusCode == 200) {
        sharedPreferencesManager.clearKey("accessToken");
        return true;
      }
    } on DioError catch (error) {
      dev.log("logout error=======");
      print(error.response);
      return null;
    }
    return null;
  }

  Future<dynamic> register(Map registerBody) async {
    try {
      final response = await _dio.post(
        '/api/signup/',
        data: registerBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 201) {
        return true;
      }
    } on DioError catch (error) {
      print(error.response.statusCode);
      switch (error.response.statusCode) {
        case 400:
          print(error.response.data);
          print(error.response.data.runtimeType);
          print(error.response.data is Map<String, List>);
          if (error.response.data is Map) {
            print('Data is error map.');
            Map<String, List> errorData =
                Map<String, List>.from(error.response.data);
            print(errorData);

            // checking if error with email
            if (errorData.containsKey('email')) {
              if (errorData["email"].length != 0)
                Get.snackbar(
                    "Registration failed.", error.response.data["email"][0],
                    backgroundColor: Colors.white);
            }
            if (errorData.containsKey('non_field_errors')) {
              if (errorData["non_field_errors"].length != 0)
                Get.snackbar("Registration failed.",
                    error.response.data["non_field_errors"][0],
                    backgroundColor: Colors.white);
            }
          }
          return false;
          break;

        case 500:
          Get.snackbar("Registration failed.", error.response.data.toString());
          return false;
          break;

        default:
          return false;
      }
    }
  }

  Future<GoogleLoginResponse> googleLogin(Map loginBody) async {
    try {
      final response = await _dio.post('/api/rest/google/',
          data: loginBody,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ));
      if (response.statusCode == 200) {
        return GoogleLoginResponse.fromJson(response.data);
      }
    } catch (error) {
      print("google login error $error");
      return null;
    }
    return null;
  }

  Future<AppleLoginResponse> appleLogin(Map loginBody) async {
    try {
      final response = await _dio.post(
        '/api/rest/apple/',
        data: loginBody,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        return AppleLoginResponse.fromJson(response.data);
      }
    } on DioError catch (error) {
      switch (error.response.statusCode) {
        case 404:
          Get.snackbar("Login Error!", "${error.response.data["error"]}");
          break;

        case 500:
          Get.snackbar("Login Error!", "Something went wrong.",
              backgroundColor: Colors.white);
          break;
        default:
          Get.snackbar("Login Error!", "${error.response.data["error"]}");
          break;
      }
      // Get.snackbar("Login Error!", error.response.data);
      print("login error ${error.response.data}");
      return null;
    }
    return null;
  }

  Future<UserStats> fetchUserStat() async {
    try {
      final response = await _dio.get(
        '/api/user/status/',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'requirestoken': true,
          },
        ),
      );
      print("response: ${response.statusCode}");
      if (response.statusCode == 200) return UserStats.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response.statusCode == 401) {
        Future.delayed(Duration(seconds: 2), () {
          locator<UserStatService>().firstTime = true;
        });
        logout();

        Get.offAllNamed(Routes.LOGIN_PAGE);
        locator<SharedPreferencesManager>().clearKey("username");
        locator<SharedPreferencesManager>().putBool("isLogin", false);
        locator<SharedPreferencesManager>().clearKey("userID");
        locator<SharedPreferencesManager>().clearKey("phonenumber");
        locator<SharedPreferencesManager>().clearKey("accessToken");
        locator<SharedPreferencesManager>().clearKey("isCreditZero");
        locator<SharedPreferencesManager>().clearKey("callGoing");
        locator<SharedPreferencesManager>().getBool("isGoogleLogin") == true
            ? GoogleSignIn().signOut()
            : null;
        locator<UserStatService>().userStats = null;
        locator<SharedPreferencesManager>().putBool("isSubscribed", false);
        locator<SharedPreferencesManager>().putBool("isLoggedOut", true);
        locator<SharedPreferencesManager>().putInt("remainingCredit", 0);
        locator<SharedPreferencesManager>().putDouble("hoursSaved", 0.0);
        locator<SharedPreferencesManager>().clearKey("phoneNumberAdded");
        locator<SharedPreferencesManager>().clearKey("serviceId");
        sharedPreferencesManager.putBool("isSocial", false);
      }
      print("userstat error $error");
      return null;
    }
    return null;
  }

  Future<List<RetrieveDashboardComponent>>
      getRetrieveDashboardComponent() async {
    try {
      print('RetrieveDashboardComponent');
      final response = await _dio.get(
        '/api/dashboard-component/',
        options: _cacheOptions,
      );

      if (response.statusCode == 200) {
        dev.log('Data recieved${response.data}');
        return RetrieveDashboardComponent.mapArray(response.data);
      } else {
        print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode;
      }
    } on DioError catch (error) {
      print(' RetrieveDashboardComponent API Error ${error.response}');
      print(error);
    }
    return null;
  }

  performCall(int componentId, String queryParameters) async {
    try {
      final response = await _dio.get(
        "/api-call/place-call/?to_call_id=$componentId${queryParameters}",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Token ${sharedPreferencesManager.getString("accessToken")}'
          },
        ),
      );

      print("response status ${response.statusCode}");

      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (error) {
      // print(url);
      print("Call Status error ${error}");
      print("Call Status error ${error.response.data}");
      switch (error.response.statusCode) {
        case 403:
          print("call error: ${error.response.data}");
          Get.snackbar("Error!", error.response.data["msg"],
              snackPosition: SnackPosition.TOP,
              backgroundColor: Color(0xfff2f2f2));
          break;
        default:
      }
      return false;
    }
    return null;
  }

  performCallEnd(int id) async {
    String url = '$_baseUrl/api-call/terminate-call/';
    print(url);
    try {
      final response = await Dio().get(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Token ${sharedPreferencesManager.getString("accessToken")}'
          }));
      print("response status ${response.statusCode}");
      print(response);

      if (response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      print("call end Status error $error");
      return false;
    }
    return null;
  }

  retryCall({String conferenceSid}) async {
    String url = '$_baseUrl/api-call/call/retry/?conference_sid=$conferenceSid';
    print(url);
    try {
      final response = await _dio.get(url,
          options: Options(headers: {
            'Content-type': 'application/json',
            'requirestoken': true,
          }));
      print("response: ${response}");
      if (response.data["status"] == true) {
        return true;
      } else
        Get.snackbar("Error", response.data["msg"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Color(0xfff2f2f2));
      return false;
    } on DioError catch (error) {
      print("error ${error.response.data}");
      print("status code: ${error.response.statusCode}");

      switch (error.response.statusCode) {
        case 403:
          Get.snackbar(
            error.response.data["status"],
            error.response.data["msg"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Color(0xfff2f2f2),
          );
          break;
        default:
      }
      return false;
    }
  }

  Future<dynamic> updatePhoneNumber({String otpCode, String serviceId}) async {
    try {
      print('phone number response');
      final response = await _dio.get(
        '/api/mobile/number/?verification_code=$otpCode&service_sid=$serviceId',
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );

      if (response.data["msg"] == "Mobile number verified successfully") {
        return true;
      } else {
        Fluttertoast.showToast(
            msg: response.data["msg"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: GLOBAL_GREEN_COLOR,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      }
    } on DioError catch (error) {
      print('PhoneNumberResponse API Error');
      print("error:::${error.response}");
      print(error);
      return false;
    }
  }

  Future<CallStatusModel> fetchNetworkStatus() async {
    try {
      final response = await _dio.get(
        '/api/call-status/',
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      print("status code ${response.statusCode}");
      print(" response ${response.data}");
      if (response.statusCode == 200) {
        return CallStatusModel.fromJson(response.data);
      } else {
        print(response.data.toString());
      }
    } catch (error) {
      print("call start error ${error}");
      return null;
    }
    return null;
  }

  Future<List<AdditionalCredits>> fetchAdditionalCredits() async {
    try {
      final response = await _dio.get(
        Platform.isIOS
            ? '/api/additional-credit/ios/'
            : '/api/additional-credit/android/',
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      print("status code ${response.statusCode}");
      print(" response ${response.data}");
      if (response.statusCode == 200) {
        return AdditionalCredits.mapArray(response.data);
      }
    } on DioError catch (error) {
      print("call start error ${error}");
      return null;
    }
    return null;
  }

  uploadRecording(recordMap) async {
    try {
      final response = await _dio.post(
        '/api/file/upload/create/',
        data: recordMap,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      print("status code ${response.statusCode}");
      print(" response ${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print(response.data.toString());
      }
    } on DioError catch (error) {
      print("create product address error ${error.response}");
    }
  }

  enableAutoRetryFeature() async {
    try {
      final response = await _dio.get(
        '/api/auto/retry',
        options: Options(
          headers: {
            'Content-type': 'application/json',
            'requirestoken': true,
          },
        ),
      );
      if (response.statusCode == 200) return true;
    } on DioError catch (error) {
      print("error: $error");
      print("error: ${error.error}");
      return false;
    }
    return null;
  }

  acceptTermsAndConditions({Map body}) async {
    try {
      final response = await _dio.post("/api/terms-condition/privacy/",
          data: body,
          options: Options(headers: {
            'Content-type': 'application/json',
            'requirestoken': true
          }));
      if (response.statusCode == 200) {
        print("response: ${response.data}");
        return true;
      }
    } on DioError catch (error) {
      print("error: $error");
      print("Terms error: ${error.response}");
      print("error: ${error.error}");
      return false;
    }
    return null;
  }

  resetPassword(Map body) async {
    try {
      final response = await _dio.post("/api/password/reset/",
          data: body,
          options: Options(headers: {
            'Content-type': 'Application/json',
          }));
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (error) {
      if (error.type == DioErrorType.connectTimeout) {
        Get.snackbar("Error", "Connection Timed Out.");
        return false;
      } else if (error.type == DioErrorType.response) {
        print("password reset error: ${error.response.data}");

        switch (error.response.statusCode) {
          case 401:
            Get.snackbar("Error!", error.response.data["msg"],
                backgroundColor: GLOBAL_GREEN_COLOR);
            return false;
            break;

          case 404:
            Get.snackbar("Detail", "${error.response.data["detail"]}",
                backgroundColor: GLOBAL_GREEN_COLOR);
            return false;
            break;

          case 500:
            Get.snackbar("Error", "Server Error.",
                backgroundColor: GLOBAL_GREEN_COLOR);
            return false;
            break;

          case 502:
            Get.snackbar("Error", "Server Error.",
                backgroundColor: GLOBAL_GREEN_COLOR);
            return false;
            break;

          default:
        }

        Get.snackbar("Error", "${error.response.data}",
            backgroundColor: GLOBAL_GREEN_COLOR);
        return false;
      }
    }
    return null;
  }

  Future<PageModel> fetchPage({int id}) async {
    try {
      final response = await _dio.get(
        '/api/pages/$id/',
        options: _cacheOptions,
      );

      return PageModel.fromJson(response.data);
    } on DioError catch (error) {
      print("page error ${error.error}");
      return null;
    }
  }

  Future<List<TimeBreakdownResponse>> fetchTimeBreakdown() async {
    try {
      final response = await _dio.get(
        '/api/time/breakdown/',
        options: Options(headers: {'requirestoken': true}),
      );

      return TimeBreakdownResponse.mapArray(response.data);
    } catch (error) {
      print("page error $error");
      return null;
    }
  }

  Future<List<DidYouKnow>> fetchDidYouKnow() async {
    try {
      final response = await _dio.get(
        '/api/did-you-know/',
        options: Options(headers: {'requirestoken': true}),
      );
      print("did you know data: ${response.data}");
      return DidYouKnow.mapArray(response.data);
    } catch (error) {
      print("page error $error");
      return null;
    }
  }

  Future<OtpResponse> getOTPStatus({String phoneNumber}) async {
    try {
      final response = await _dio.post(
        '/api/send/otp/',
        data: {"phone_number": phoneNumber},
        options: Options(
          headers: {"requirestoken": true},
        ),
      );
      print("OTP response: $response");
      if (response.data["msg"] ==
          "verification code has been sent to your device") {
        return OtpResponse.fromJson(response.data);
      } else {
        Get.snackbar("Error", "${response.data["msg"]}",
            backgroundColor: GLOBAL_GREEN_COLOR);
        return null;
      }
    } on DioError catch (error) {
      print("OTP error: $error");
      Get.snackbar("Error", "Error ", backgroundColor: GLOBAL_GREEN_COLOR);
      return null;
    }
  }

  Future<SubscriptionStatus> getSubscriptionStatus() async {
    try {
      final response = await _dio.get('/api/subscription-status/',
          options: Options(
            headers: {"requirestoken": true},
          ));
      print("${_baseUrl}/api/subscription-status}");
      if (response.statusCode == 200) {
        return SubscriptionStatus.fromJson(response.data);
      } else {
        return null;
      }
    } on DioError catch (error) {
      print("Subscription status error: ${error}");
      return null;
    }
  }

  Future<List<PrivacyPolicy>> getPrivacyPolicy() async {
    try {
      final response = await _dio.get(
        '/api/privacy-policy/',
      );
      if (response.statusCode == 200) {
        return PrivacyPolicy.mapArray(response.data);
      } else {
        // Get.snackbar("Error", "Error while fetching subscription status");
        return null;
      }
    } on DioError catch (error) {
      print("Privacy policy error: ${error}");
      // Get.snackbar("Error", "Error while fetching subscription status");
      return null;
    }
  }

  Future<List<OnlineStatus>> getOnlineStatus() async {
    try {
      final response = await _dio.get('/api/dashboard-component/status/');
      if (response.statusCode == 200) {
        return OnlineStatus.mapArray(response.data);
      } else {
        return null;
      }
    } on DioError catch (error) {
      print("Online Status error: ${error}");
      // Get.snackbar("Error", "Error while fetching subscription status");
      return null;
    }
  }
}
