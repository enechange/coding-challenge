json.array!(@results) do |result|
  json.(result, :plan, :company, :price)
end