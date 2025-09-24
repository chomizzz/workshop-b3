puts "=== Starting seed ==="

puts "Creating users..."
user_admin = User.find_or_create_by(email: "j.rougerie@proton.me") do |user|
  user.nickname = "chomizzz"
  user.password = "password"
end

user_1 = User.find_or_create_by!(email: "user1@mail.com", nickname: "user1") do |user|
  user.password = "123456abcdef"
end

user_2 = User.find_or_create_by!(email: "user2@mail.com", nickname: "user2") do |user|
  user.password = "123456abcdef"
end

user_3 = User.find_or_create_by!(email: "user3@mail.com", nickname: "user3") do |user|
  user.password = "123456abcdef"
end

puts "Users created successfully"

community_1 = Community.find_or_create_by!(name: "EPSIEN")
community_2 = Community.find_or_create_by!(name: "ENIEN")

puts "Communities created successfully"

puts "Adding user to communities"
users = User.all.to_a
users_1 = users[0, users.size/2]
users_2 = users[users.size/2, users.size]

users_1.each do |user|
  community_1.add_user_to_community(user)
end

users_2.each do |user|
  community_2.add_user_to_community(user)
end


# Correction ici : utiliser include? au lieu de exists?
unless user_admin.contacts.include?(user_1)


  puts "Adding contact and creating conversation..."

  user_admin.add_contact(user_1)
  user_admin.add_contact(user_2)
  conversation_1 = user_admin.create_conversation(user_1)
  conversation_2 = user_admin.create_conversation(user_2)

  puts "Conversation created"

  message1 = conversation_1.send_message(user_admin, "Bonjour, premier message de Chomizzz")
  message2 = conversation_1.send_message(user_1, "Bonjour, second message de user1")

  message3 = conversation_2.send_message(user_admin, "Bonjour, premier message de Chomizzz poru user_2")
  message4 = conversation_2.send_message(user_2, "Bonjour, second message de user2 pour Chomizz")



else
  puts "Contact already exists"
end




puts "=== Seed completed ==="
puts "Total users: #{User.count}"
puts "Total communities: #{Conversation.count}"
puts "Total conversations: #{Conversation.count}"
puts "Total messages: #{Message.count}"
