json.array! @groups do |group|
  json.id group.id
  json.title group.title
  json.desc group.desc
  json.count group.count
  json.admin User.find(group.admin_id)
  json.created_at group.created_at
end
