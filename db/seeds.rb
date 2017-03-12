# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

adm = Role.find_or_initialize_by(name: :admin)
user = Role.find_or_initialize_by(name: :manager)


User.find_or_initialize_by(email: 'kremenchuk@bk.ru').tap do |f|
  f.password = '1440518'
  f.role = adm
  f.save!
end

User.find_or_initialize_by(email: 'kremenchuk1@bk.ru').tap do |f|
  f.password = '1440518'
  f.role = user
  f.save!
end

c1 = Counterparty.find_or_initialize_by(name: 'Форстор').tap do |f|
  f.short_name = 'Ф'
  f.c_type = 0
  f.save!
end

c2 =Counterparty.find_or_initialize_by(name: 'Складские технологии Харьков').tap do |f|
  f.short_name = 'СТХ'
  f.c_type = 0
  f.save!
end

100.times do |i|
  OrderManufacturing.find_or_initialize_by(number: i.odd? ? "Ф-#{i}" : "СТХ-#{i}").tap do |f|
    f.date = Time.now.strftime('%d.%m.%Y')
    f.invoice = "A-#{i}"
    f.counterparty = i.odd? ? c1 : c2
    f.save!
  end
end

w = Worker.find_or_initialize_by(first_name: "Фамилия").tap do |f|
  f.middle_name = 'Отчество'
  f.last_name = 'Имя'
  f.position = 'Электрик'
end


100.times do |i|
  Payroll.create do |f|
    f.date = Time.now.strftime('%d.%m.%Y')
    f.worker = w
    f.save!
  end
end

100.times do |i|
  Item.find_or_initialize_by(name: "стеллаж х#{i}х#{i}х#{i}").tap do |f|
    f.unit = 'Шт.'
    f.item_type = 1
    f.area = 120
    f.price = 2551.05
    f.volume = 0.02
    f.weight = 22.5
    f.save!
  end
end

100.times do |i|
  Job.find_or_initialize_by(name: "Работа №#{i}").tap do |f|
    f.price = 10.2 + i
    f.time = 1 + i
    f.print = true
    f.save!
  end

end