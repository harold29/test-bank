# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(email: 'potato-admin@potato.com', password: '12345678', admin: true)
User.create(email: 'potato-user-1@potato.com', password: '12345678', admin: false)
User.create(email: 'potato-user-2@potato.com', password: '12345678', admin: false)
