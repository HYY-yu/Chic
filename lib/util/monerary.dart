enum Monerary { RMB, US, HK, MOP, JPY, KRW, NT }

var _moneraryFlagMap = {
  Monerary.RMB: '人民币',
  Monerary.US: '美元',
  Monerary.HK: '港币',
  Monerary.MOP: '澳元',
  Monerary.JPY: '日元',
  Monerary.KRW: '韩元',
  Monerary.NT: '新台币'
};

String getMonetaryDisplayString(Monerary monerary) {
  return _moneraryFlagMap[monerary];
}
