/**
 * タブレットではviewportを1024pxに固定
 */
export default function() {
  const getDeviceType = function() {
    const ua = window.navigator.userAgent;
    const deviceTypes = {};
    deviceTypes.isIPhone = /iPhone/i.test(ua);
    deviceTypes.isIPad = /iPad/i.test(ua);
    deviceTypes.isWindowsPhone = /Windows Phone/i.test(ua);
    deviceTypes.isWindowsTablet = /Windows/i.test(ua) && /Touch/i.test(ua) && !/Tablet PC/i.test(ua);
    deviceTypes.isAndroid = /Android/i.test(ua) && !ua.isWindowsPhone;
    deviceTypes.isAndroidMobile = deviceTypes.isAndroid && /Mobile/i.test(ua);
    deviceTypes.isAndroidTablet = deviceTypes.isAndroid && !deviceTypes.isAndroidMobile;
    deviceTypes.isBlackBerry = /BlackBerry+/i.test(ua);
    deviceTypes.isBlackBerryTablet = /PlayBook+/i.test(ua);

    deviceTypes.isMobile =
      deviceTypes.isIPhone || deviceTypes.isWindowsPhone || deviceTypes.isAndroidMobile || deviceTypes.isBlackBerry;
    deviceTypes.isTablet =
      deviceTypes.isIPad ||
      deviceTypes.isWindowsTablet ||
      deviceTypes.isAndroidTablet ||
      deviceTypes.isBlackBerryTablet;

    return deviceTypes;
  };

  if (getDeviceType().isTablet) $('meta[name="viewport"]').attr('content', 'width=1024');
}
