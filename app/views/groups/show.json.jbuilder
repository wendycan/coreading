json.id @group.id
json.title @group.title
json.desc @group.desc
json.count @group.count
json.admin_id @group.admin_id
json.created_at @group.created_at
json.articles @group.articles
json.usernames @group.users.collect { |u| u.username  }
