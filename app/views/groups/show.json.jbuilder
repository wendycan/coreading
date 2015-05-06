json.id @group.id
json.title @group.title
json.desc @group.desc
json.count @group.count
json.admin_id @group.admin_id
json.created_at @group.created_at
json.articles @group.articles.collect {|a| {
  title: a.title, created_at: a.created_at, username: User.find(a.user_id).username, id: a.id} 
}
json.usernames @group.users.collect { |u| u.username  }
