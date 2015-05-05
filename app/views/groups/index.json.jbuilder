json.array!(@groups) do |group|
  json.extract! group, :id, :title, :desc, :count, :admin_id
  json.url group_url(group, format: :json)
end
