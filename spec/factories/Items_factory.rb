FactoryBot.define do
  factory :item do
    area { 1.25 }
    for_sale { 'Для продажи' }
    item_files { { } }
    sequence :name do |n|
      "item#{n}"
    end
    size_a { 2.25 }
    size_b { 3.25 }
    size_l { 4.25 }
    unit { 0 }
    volume { 5.25 }
    item_group
  end
end