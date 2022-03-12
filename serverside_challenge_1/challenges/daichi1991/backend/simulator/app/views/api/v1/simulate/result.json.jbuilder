json.array!(@results) do |result|
  json.call(result, :plan, :company, :price)
end
