# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

adm = Role.find_or_initialize_by(name: :admin)
user = Role.find_or_initialize_by(name: :manager)

counterparties = [['Складские технологии Харьков', 'СТХ', 'Покупатель'], ['Форстор', 'Ф', 'Покупатель'],
    ['Иприс профиль', 'ИПРИС', 'Продавец']]

materials = [['Уголок 34х34', 'м/п', 15.52, 0.7, 'РОЛФОРМ'], ['Лист 2х1х0,7 Оц', 'шт', 283.0, 10.4],
    ['Лист 2х1х0,7 ХК', 'шт', 283.0, 10.4, 'Бис групп'], ['Лист 2,5х1,25х0,7', 'шт', 439.4, 15.4, 'Бис групп'],
    ['Штрипса 100х1,5', 'м/п', 27.4, 1.17, 'Бис групп'], ['Лист 2х1х2', 'шт', 770.0, 32.1, 'Бис групп'],
    ['Штрипса 79х1', 'м/п', 24.4, 0.62, 'Бис групп']]

jobs = [['Упаковка полок', 'Упаковка', 10.2, 5], ['Рубка зацепа СК', 'Рубка зацепа СК', 0.12, 14],
        ['Пробивка стоек 34х34', 'Пробивка стоек ПК', 3, 50], ['Пробивка уголка полки ПК', 'Пробивка уголка полки ПК', 3.5, 12],
        ['Гибка полки ПК', 'Гибка ПК', 1.2, 30], ['Сверловка укосов', 'Сверловка укосов', 0.8, 25],
        ['Упаковка рам', 'Упаковка', 10.2, 5], ['Обрубка стойки ПК', 'Обрубка стойки ПК', 10.2, 0.5],
        ['Рубка полки ПК гильотина', 'Рубка полки ПК', 10.2, 3.5], ['Упаковка стеллажа ПК', 'Упаковка', 10.2, 15]
]

users = [['kremenchuk@bk.ru', '123456', adm,], ['kremenchuk1@bk.ru', '123456', user]]

workers = [['Чмель', 'Александр', 'Валеревич', 'Сарщик'], ['Томин', 'Сергей', 'Викторович', 'Штамповщик']]

items = [['Стойка ПК 2000', 'шт', 2000, 10, 200,[[8, 'Job', 1.0, false], [1, 'Material', 2.0, false], [2, 'Job', 1.0, false]]],
         ['Полка ПК 900х400', 'шт', 0, 900, 400,[[5, 'Job', 4.0, false], [2, 'Material', 0.25, true], [4, 'Job', 4.0, false], [5, 'Job', 4.0, false]]],
         ['Стеллаж 2000х900х400 5п', 'шт', 2000, 900, 400,[[1, 'Item', 4.0, true], [2, 'Item', 5, true], [10, 'Job', 1.0, true]]],
         ['Стойка ПК 2500', 'шт', 2500, 10, 200,[[8, 'Job', 1.0, false], [1, 'Material', 2.5, false], [2, 'Job', 1.0, false]]],
         ['Стеллаж 2500х900х400 5п', 'шт', 2500, 900, 400,[[4, 'Item', 4.0, true], [2, 'Item', 5, true], [10, 'Job', 1.0, true]]]
         ]


counterparties.each do |i|
  Counterparty.find_or_initialize_by(name: i[0]).tap do |f|
    f.short_name = i[1]
    f.c_type     = i[2]
    f.save!
  end
end

materials.each do |i|
  Material.find_or_initialize_by(name: i[0]).tap do |f|
    f.unit    = i[1]
    f.price   = i[2]
    f.weight  = i[3]
    f.note    = i[4]
    f.save!
  end
end

jobs.each do |i|
  Job.find_or_initialize_by(name: i[0]).tap do |f|
    f.name_for_print = i[1]
    f.price          = i[2]
    f.time           = i[3]
    f.save!
  end
end

users.each do |i|
  User.find_or_initialize_by(email: i[0]).tap do |f|
    f.password = i[1]
    f.role     = i[2]
    f.save!
  end
end

workers.each do |i|
  Worker.find_or_initialize_by(first_name: i[0]).tap do |f|
    f.last_name   = i[1]
    f.middle_name = i[2]
    f.position    = i[3]
    f.save!
  end
end

items.each do |i|
  Item.find_or_initialize_by(name: i[0]).tap do |f|
    f.unit    = i[1]
    f.size_l  = i[2]
    f.size_a  = i[3]
    f.size_b  = i[4]
    f.details = i[5]
    f.save!
  end
end