// 茶韵 TEA 代购选品数据 - 2026年春茶爆款更新
// 数据来源: 淘宝/天猫/京东/1688 热销榜单
const PRODUCTS = [
  {
    id: 1,
    name: "西湖龙井 明前特级",
    name_en: "West Lake Longjing (Pre-Qingming Grade)",
    price: "¥458",
    origPrice: "¥698",
    source: "天猫超市",
    sourceUrl: "https://chaoshi.tmall.com",
    tags: ["代购", "明前茶", "绿茶", "2026新茶"],
    hot: true,
    rating: 4.9,
    sold: "5.6万"
  },
  {
    id: 2,
    name: "洞庭碧螺春 明前特级",
    name_en: "Dongting Biluochun (Pre-Qingming)",
    price: "¥880",
    origPrice: "¥1280",
    source: "天猫国际",
    sourceUrl: "https://tmall.hk",
    tags: ["代购", "明前茶", "绿茶", "花果香"],
    hot: true,
    rating: 4.9,
    sold: "3.2万"
  },
  {
    id: 3,
    name: "安吉白茶 明前特级",
    name_en: "Anji White Tea (Pre-Qingming)",
    price: "¥568",
    origPrice: "¥780",
    source: "京东自营",
    sourceUrl: "https://jd.com",
    tags: ["代购", "白茶", "2026新茶", "鲜爽"],
    hot: true,
    rating: 4.8,
    sold: "4.1万"
  },
  {
    id: 4,
    name: "竹叶青 论道级",
    name_en: "Zhuyeqing (Lundao Grade)",
    price: "¥1688",
    origPrice: "¥2288",
    source: "天猫旗舰店",
    sourceUrl: "https://detail.tmall.com",
    tags: ["代购", "高端茶", "四川名茶", "国宴用茶"],
    hot: true,
    rating: 4.9,
    sold: "1.8万"
  },
  {
    id: 5,
    name: "黄山毛峰 明前特级",
    name_en: "Huangshan Maofeng (Pre-Qingming)",
    price: "¥458",
    origPrice: "¥628",
    source: "拼多多",
    sourceUrl: "https://pinduoduo.com",
    tags: ["代购", "明前茶", "绿茶", "兰花香"],
    hot: false,
    rating: 4.7,
    sold: "2.9万"
  },
  {
    id: 6,
    name: "太平猴魁 谷雨特级",
    name_en: "Taiping Houkui (Guyu Grade)",
    price: "¥680",
    origPrice: "¥980",
    source: "网易严选",
    sourceUrl: "https://yanxuan.com",
    tags: ["代购", "安徽名茶", "绿茶", "兰香高锐"],
    hot: false,
    rating: 4.8,
    sold: "1.5万"
  },
  {
    id: 7,
    name: "武夷山正岩大红袍",
    name_en: "Wuyi Da Hong Pao (Zhengyan)",
    price: "¥528",
    origPrice: "¥758",
    source: "京东自营",
    sourceUrl: "https://jd.com",
    tags: ["代购", "乌龙茶", "岩茶", "2026新茶"],
    hot: true,
    rating: 4.8,
    sold: "4.3万"
  },
  {
    id: 8,
    name: "云南古树普洱熟茶",
    name_en: "Yunnan Ancient Tree Pu'er (Ripe)",
    price: "¥298",
    origPrice: "¥458",
    source: "淘宝心选",
    sourceUrl: "https://taobao.com",
    tags: ["代购", "普洱", "熟茶", "收藏"],
    hot: false,
    rating: 4.7,
    sold: "3.8万"
  },
  {
    id: 9,
    name: "福鼎白茶 白毫银针",
    name_en: "Fuding White Silver Needle",
    price: "¥528",
    origPrice: "¥698",
    source: "天猫国际",
    sourceUrl: "https://tmall.hk",
    tags: ["代购", "白茶", "银针", "升值"],
    hot: false,
    rating: 4.9,
    sold: "2.1万"
  },
  {
    id: 10,
    name: "信阳毛尖 雨前特级",
    name_en: "Xinyang Maojian (Pre-Rain)",
    price: "¥358",
    origPrice: "¥498",
    source: "京东自营",
    sourceUrl: "https://jd.com",
    tags: ["代购", "毛尖", "江北名茶", "2026新茶"],
    hot: true,
    rating: 4.6,
    sold: "6.2万"
  }
];

window.PRODUCTS = PRODUCTS;
