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
community_3 = Community.find_or_create_by!(name: "AFTECIEN")
community_4 = Community.find_or_create_by!(name: "SUBDEVINCIEN")
community_5 = Community.find_or_create_by!(name: "EPITECHIEN")

epsi_location = Location.find_or_create_by!(latitude: "48.132124", longitude: "-1.710573")
eni_location = Location.find_or_create_by!(latitude: "48.03893", longitude: "-1.692324")
aftec_location = Location.find_or_create_by!(latitude: "48.0907008", longitude: "-1.6969032")
subdevinci_location = Location.find_or_create_by!(latitude: "48.0977725", longitude: "-1.624893")
epitechien_location = Location.find_or_create_by!(latitude: "48.0907008", longitude: "-1.6319941")


community_1.update(location: epsi_location)
community_2.update(location: eni_location)
community_3.update(location: aftec_location)
community_4.update(location: subdevinci_location)
community_5.update(location: epitechien_location)

puts "Communities created successfully"

puts "Add items to communities"

# Items uniques pour chaque communauté
items_per_community = {
  community_1 => [
    { name: "Water Bottle", quantity: 10, unit: "L" },
    { name: "Chair", quantity: 50, unit: "pcs" },
    { name: "Laptop", quantity: 15, unit: "pcs" },
    { name: "Notebook", quantity: 200, unit: "pcs" },
    { name: "Pen", quantity: 500, unit: "pcs" }
  ],
  community_2 => [
    { name: "Projector", quantity: 5, unit: "pcs" },
    { name: "Table", quantity: 20, unit: "pcs" },
    { name: "Marker", quantity: 100, unit: "pcs" },
    { name: "Whiteboard", quantity: 10, unit: "pcs" },
    { name: "Cable", quantity: 50, unit: "m" }
  ],
  community_3 => [
    { name: "Chair Cushion", quantity: 30, unit: "pcs" },
    { name: "USB Drive", quantity: 60, unit: "pcs" },
    { name: "Printer Paper", quantity: 500, unit: "sheets" },
    { name: "Stapler", quantity: 10, unit: "pcs" },
    { name: "Ink Cartridge", quantity: 20, unit: "pcs" }
  ],
  community_4 => [
    { name: "Router", quantity: 8, unit: "pcs" },
    { name: "Switch", quantity: 5, unit: "pcs" },
    { name: "Ethernet Cable", quantity: 100, unit: "m" },
    { name: "Monitor", quantity: 12, unit: "pcs" },
    { name: "Keyboard", quantity: 15, unit: "pcs" }
  ],
  community_5 => [
    { name: "Mouse", quantity: 20, unit: "pcs" },
    { name: "Headset", quantity: 10, unit: "pcs" },
    { name: "Notebook", quantity: 150, unit: "pcs" },
    { name: "Pen", quantity: 300, unit: "pcs" },
    { name: "Desk Lamp", quantity: 8, unit: "pcs" }
  ]
}

# Création des items pour chaque communauté
items_per_community.each do |community, items|
  items.each do |item_data|
    Item.create!(
      name: item_data[:name],
      quantity: item_data[:quantity],
      unit: item_data[:unit],
      community: community
    )
  end
end

puts "Items added successfully!"

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
puts "Total communities: #{Community.count}"
puts "Total conversations: #{Conversation.count}"
puts "Total messages: #{Message.count}"
puts "Total locations: #{Location.count}"
