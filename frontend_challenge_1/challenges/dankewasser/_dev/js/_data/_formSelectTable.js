/**
 * 電力会社と都道府県との対照表
 * todo 最小限の実装であるため、拡張性を考えてリレーショナルデータベース風に変えたい
 * @type {{provider: *[], providerToPref: {kyuden: {pref: *[]}, rikuden: {pref: *[]}, kepco: {pref: *[]}, other: {pref: {name: string, value: string}[]}, hepco: {pref: *[]}, energia: {pref: *[]}, tepco: {pref: *[]}, "tohoku-epco": {pref: *[]}, chuden: {pref: *[]}, okiden: {pref: *[]}, yonden: {pref: *[]}}}}
 */
export const formSelectTable = {
  provider: [
    {
      name: '東京電力',
      value: 'tepco',
    },
    {
      name: '北海道電力',
      value: 'hepco',
    },
    {
      name: '東北電力',
      value: 'tohoku-epco',
    },
    {
      name: '中部電力',
      value: 'chuden',
    },
    {
      name: '北陸電力',
      value: 'rikuden',
    },
    {
      name: '関西電力',
      value: 'kepco',
    },
    {
      name: '中国電力',
      value: 'energia',
    },
    {
      name: '四国電力',
      value: 'yonden',
    },
    {
      name: '九州電力',
      value: 'kyuden',
    },
    {
      name: '沖縄電力',
      value: 'okiden',
    },
    {
      name: 'その他',
      value: 'other',
    },
  ],
  providerToPref: {
    tepco: {
      pref: [
        {
          name: '東京都',
          value: 'tokyo',
        },
        {
          name: 'その他',
          value: 'other',
        },
      ],
    },
    hepco: {
      pref: [
        {
          name: '北海道',
          value: 'hokkaido',
        },
        {
          name: 'その他',
          value: 'other',
        },
      ],
    },
    'tohoku-epco': {
      pref: [
        {
          name: '宮城県',
          value: 'miyagi',
        },
        {
          name: 'その他',
          value: 'other',
        },
      ],
    },
    chuden: {
      pref: [
        {
          name: '長野県',
          value: 'nagano',
        },
        {
          name: 'その他',
          value: 'other',
        },
      ],
    },
    rikuden: {
      pref: [
        {
          name: '富山県',
          value: 'toyama',
        },
        {
          name: 'その他',
          value: 'other',
        },
      ],
    },
    kepco: {
      pref: [
        {
          name: '大阪府',
          value: 'osaka',
        },
        {
          name: 'その他',
          value: 'other',
        },
      ],
    },
    energia: {
      pref: [
        {
          name: '広島県',
          value: 'hiroshima',
        },
        {
          name: 'その他',
          value: 'other',
        },
      ],
    },
    yonden: {
      pref: [
        {
          name: '徳島県',
          value: 'tokushima',
        },
        {
          name: 'その他',
          value: 'other',
        },
      ],
    },
    kyuden: {
      pref: [
        {
          name: '福岡県',
          value: 'fukuoka',
        },
        {
          name: 'その他',
          value: 'other',
        },
      ],
    },
    okiden: {
      pref: [
        {
          name: '沖縄県',
          value: 'okinawa',
        },
        {
          name: 'その他',
          value: 'other',
        },
      ],
    },
    other: {
      pref: [
        {
          name: 'その他',
          value: 'other',
        },
      ],
    },
  },
};
