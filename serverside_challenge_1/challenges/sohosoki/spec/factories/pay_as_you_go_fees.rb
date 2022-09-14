FactoryBot.define do
  {
    'to120': [nil, 120],
    '120to300': [120, 300],
    '300to600': [300, 600],
    'over600': [600, nil],
    'single_fee': [nil, nil],
  }.each.with_index(1) do |(name, values), i|
    factory name, class: PayAsYouGoFee do
      min_usage { values[0] }
      max_usage { values[1] }
      price { 100 * i }
    end
  end
end
