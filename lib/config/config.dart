class Config {
  // static const env = 'product';
  static const env = 'test';
  // static const env = 'dev';
  static const urls = {
    'dev': 'http://192.168.1.128/api/v1/',
    'test': 'http://xz_safety.peersafe.cn/api/v1/',
    'product': 'http://user.notary-tech.com/api/v1/'
  };
  static String baseurl = urls[env];
  static const maxCache = 1000; //htpp请求最大缓存数
  static const expired = 60 * 60 * 24; //缓存过期时间
  static const searchParam = {'limit': 10, 'offset': 0, 'total': 0};
}
