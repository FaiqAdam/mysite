json.array!(@reports) do |report|
  json.extract! report, :id, :reportnumber, :reference, :species, :variety, :weight, :dimension, :shapecut, :colour, :item, :transparency, :requesof, :comments
  json.url report_url(report, format: :json)
end
