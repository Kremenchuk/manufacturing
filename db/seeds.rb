# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.find_or_initialize_by(email: 'kremenchuk@bk.ru').tap do |f|
  f.password = '1440518'
  f.save!
end

c = Counterparty.find_or_initialize_by(name: 'Форстор').tap do |f|
  f.short_name = 'Ф'
  f.c_type = 0
  f.save!
end

100.times do |i|
  OrderManufacturing.find_or_initialize_by(number: "Ф-#{i}").tap do |f|
    f.date = Time.now.strftime('%d.%m.%Y')
    f.invoice = "A-#{i}"
    f.counterparty = c
    f.save!
  end
end