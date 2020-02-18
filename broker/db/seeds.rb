# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "WTF!!!"
puts ENV.fetch("ADMIN_TOKEN")
if admin_token = ENV.fetch("ADMIN_TOKEN")
  admin = User.first_or_create(email: 'admin@admin.admin')
  admin.update(token: admin_token, role: 'admin')
end