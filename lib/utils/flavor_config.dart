enum Flavor { DEVELOPMENT, STAGE, PRODUCTION, RELEASE }

class Config {
  static Flavor appFlavor;
  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.PRODUCTION:
        return 'https://app.q4me.com';
        break;

      case Flavor.DEVELOPMENT:
        return 'https://q4me.prixa.live';
        break;

      case Flavor.STAGE:
        return 'https://app.q4me.co.uk';
        break;

      default:
        return 'https://app.q4me.com';
        break;
    }
  }

  static String get APPLE_SECRET_KEY {
    switch (appFlavor) {
      case Flavor.PRODUCTION:
        return 'appl_VfHfMSUTDPdzAVvAbMHnpGCouGN';
        break;

      case Flavor.DEVELOPMENT:
        return 'appl_PRtEibQrfbsWKBoTRsOyoNPVefX';
        break;

      case Flavor.STAGE:
        return 'appl_xuZxoQdebDoVDrpbsYaZuCiUeLV';
        break;

      default:
        return 'appl_VfHfMSUTDPdzAVvAbMHnpGCouGN';
        break;
    }
  }

  static String get GOOGLE_SECRET_KEY {
    switch (appFlavor) {
      case Flavor.PRODUCTION:
        return 'goog_SgOtHssRsLMpnGupSInPhowAWrT';
        break;

      case Flavor.DEVELOPMENT:
        return 'goog_nySlYPVSUkYeOBcIoIqldPNEKiG';
        break;

      case Flavor.STAGE:
        return 'goog_YsnJwXpyyQTVbljphKxJtyYPCQf';
        break;

      default:
        return 'goog_SgOtHssRsLMpnGupSInPhowAWrT';
        break;
    }
  }
}
