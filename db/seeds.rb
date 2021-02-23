# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

super_user = Role.find_or_initialize_by(name: :superuser).tap do |f|
  f.available_classes = :all
  f.save
end
adm = Role.find_or_initialize_by(name: :admin).tap do |f|
  f.available_classes ='Counterparty, Material, Job, User, Worker, ItemGroup, Item, OrderManufacturing, Payroll'
  f.save
end

user = Role.find_or_initialize_by(name: :manager).tap do |f|
  f.available_classes = 'Worker, Counterparty, Job'
  f.save
end

counterparties = [['Складские технологии Харьков', 'СТХ', 'Покупатель'], ['Форстор', 'ФОРСТОР', 'Покупатель'],
    ['Иприс профиль', 'ИПРИС', 'Продавец'], ['Триометалл сервис', 'Триометалл', 'Покупатель']]

materials = [['Уголок 34х34', 'м/п', 15.52, 0.7, 'РОЛФОРМ'], ['Лист 2х1х0,7 Оц', 'шт', 283.0, 10.4],
    ['Лист 2х1х0,8 ХК', 'шт', 283.0, 10.4, 'Бис групп'], ['Лист 2,5х1,25х0,7 Оц', 'шт', 439.4, 15.4, 'Бис групп'],
    ['Штрипса 100х1,5 ХК', 'м/п', 27.4, 1.17, 'Бис групп'], ['Лист 2х1х2 ХК', 'шт', 770.0, 32.1, 'Бис групп'],
    ['Штрипса 79х1 ХК', 'м/п', 24.4, 0.62, 'Бис групп'], ['Штрипса 79х1 Оц', 'м/п', 26.4, 0.62, 'Бис групп']]

jobs = [['Упаковка полок', 'Упаковка', 10.2, 5], ['Рубка зацепа СК', 'Рубка зацепа СК', 0.12, 14],
        ['Пробивка стоек 34х34', 'Пробивка стоек ПК', 3, 50], ['Пробивка уголка полки ПК', 'Пробивка уголка полки ПК', 3.5, 12],
        ['Гибка полки ПК', 'Гибка ПК', 1.2, 30], ['Сверловка укосов', 'Сверловка укосов', 0.8, 25],
        ['Упаковка рам', 'Упаковка', 10.2, 5], ['Обрубка стойки ПК', 'Обрубка стойки ПК', 10.2, 0.5],
        ['Рубка полки ПК гильотина', 'Рубка полки ПК', 10.2, 3.5], ['Упаковка стеллажа ПК', 'Упаковка', 10.2, 15],
        ['Гибка зацепа складского стеллажа', 'Гибка зацепа складского стеллажа', 0.25, 25], ['Рубка полосы для зацепа складского стеллаж', 'Рубка полосы для зацепа складского стеллаж', 0.45, 36]
]

users = [['kremenchuk@bk.ru', '123456', super_user,],  ['kremenchuk1@bk.ru', '123456', adm], ['kremenchuk2@bk.ru', '123456', user]]

workers = [['Чмель Александр Валеревич', 'Сварщик'], ['Томин Сергей Викторович', 'Штамповщик'], ['Цыкал Сергей Александрович', 'Маляр']]

item_groups = [['Стойки', 0], ['Траверсы', 1], ['Полки', 2], ['Стеллажи', 3]]

items = [['Стойка ПК 2000', 'шт', 2000, 10, 200,[[8, 'Job', 1.0, false], [1, 'Material', 2.0, false], [2, 'Job', 1.0, false]], [0]],
         ['Полка ПК 900х400', 'шт', 0, 900, 400,[[5, 'Job', 4.0, false], [2, 'Material', 0.25, true], [4, 'Job', 4.0, false], [5, 'Job', 4.0, false]], [2]],
         ['Стеллаж 2000х900х400 5п', 'шт', 2000, 900, 400,[[1, 'Item', 4.0, true], [2, 'Item', 5, true], [10, 'Job', 1.0, true]], [3]],
         ['Стойка ПК 2500', 'шт', 2500, 10, 200,[[8, 'Job', 1.0, false], [1, 'Material', 2.5, false], [2, 'Job', 1.0, false]], [0]],
         ['Стеллаж 2500х900х400 5п', 'шт', 2500, 900, 400,[[4, 'Item', 4.0, true], [2, 'Item', 5, true], [10, 'Job', 1.0, true]], [3]]
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
  Worker.find_or_initialize_by(fio: i[0]).tap do |f|
    f.position    = i[1]
    f.save!
  end
end

item_groups.each do |i|
  ItemGroup.find_or_initialize_by(name: i[0]).tap do |f|
    f.range    = i[1]
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
    f.item_group = ItemGroup.find_by_range(i[6])
    f.save!
  end
end

