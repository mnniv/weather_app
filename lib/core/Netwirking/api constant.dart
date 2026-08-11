class ApiConstant {
  ///// GET ////////////////////
  static const String getTechProfile = "/accounts/technician/profile/";
  static const String orders = "/orders/technician/my-work/";
  static const String getnotifications = "/notifications/";
  static const String getAviableJobs = "/orders/technician/available-jobs/";
  static const String chatsList = "/chat/list/";
  static const String jobDeatils = "/orders/jobs/";
  static const String charRoom = "/chat/room/";
  static const String uplodeFile = "/chat/upload/";
  static const String myrequest = "/orders/client/requests/";
  static const String updateProfile = "/accounts/client/profile/";
  static const String dashbordDAta = "/orders/technician/dashboard";
  static const String changeProviderStatus = "/accounts/technician/is-online/";
  static const String registerdevice = "/notifications/register-device/";
  static const String availberequest = "/orders/technician/available-jobs//";
  static const String recviedOffers = "/orders/requests";
  static const String getAds = "/ads/";
  static const String recentRequest = "/orders/client/requests/recent/";

  ///// POST ////////////////////
  static const String loginClient = "/accounts/login/client/";
  static const String loginTech = "/accounts/login/technician/";
  static const String refreshtoken = "/accounts/token/refresh/";
  static const String PostServiceSelction = "/accounts/technician/service-selection/";
  static const String createOffer = "/orders/requests/create/";
  static const String addRequest = "/orders/requests/create/";
  static const String responsereqest = "/WorkFlow/api/ResponseOnRequest";
  static const String register = "/accounts/signup/client/";
  static const String signupTech = "/accounts/signup/technician/";
  static const String services = "/accounts/services/";
  static const String orderLoeaded = "/WorkFlow/api/OrderLoaded";
  static const String sendemailCode =
      "/Authentication/api/Confirmations/SendConfirmCode";
  static const String Leatest = "/Authentication/api/Versions/GetLastDriver";
  static const String acceptOffer = "/orders/requests/";
  static const String negOffer = "/orders/negotiations/create/";
  static const String restPassword =
      "/Authentication/api/Confirmations/SendConfairmResetPassword";
}

// class APiConstantMap {
//   static const String Place_id = "/Map/api/GetPlace";
//   static const String getgecod = "/Map/api/GetGeocode";
// }

// class ApiConstantPending {
//   static const String ReqeustPending = "/Order/api/DriverPendingRequestsList";
//   static const String DriverORderList = "/Order/api/DriverOrdersList";
//   static const String ActiverOrderDriver = "/Order/api/GetActiveOrder";
// }

// class SinglRconstant {
//   static const String conectionhub = "/connecthub";
// }

// class ApiConstantSearch {
//   static const String searchvicile = "/Vehicle/api/Closest";
// }

// class ApiConstantAuth {
//   static const String logout = "/Authentication/api/Sings/Logout";
// }

// class ApiConstantNotfication {
//   static const String notficationenabled = "/Notification/api/ActiveMember";
//   static const String notficationdisabled = "/Notification/api/UnactiveMember";
//   static const String notficationChangeLanguage =
//       "/Notification/api/ChangeLanguage";
// }

// class ApIWorkFlow {
//   static const String orderLoeadedConfirmation =
//       "/WorkFlow/api/OrderLoadedConfirmation";
//   static const String orderRecivedConfirmation =
//       "/WorkFlow/api/OrderReceivedConfirmation";
//   static const String cansleOrder = "/WorkFlow/api/CanceleOrder";
// }
