# Создание админа
if User.count.zero?
  puts "Создаём тестового админа..."
  User.create!(
    email: 'admin@test.com',
    password: 'password',
    password_confirmation: 'password',
    role: 'admin',
    first_name: 'Admin',
    last_name: 'User'
  )
  puts "Админ создан: admin@test.com / password"
else
  puts "Пользователи уже есть, пропускаем создание админа..."
end

# Твои товары
if Item.count.zero?
  puts "Создаём тестовые товары..."
  10.times do |i|
    Item.create!(
      name: "Товар ##{i+1}",
      description: "Описание товара ##{i+1}",
      price: rand(100..1000)
    )
  end
  puts "Товары созданы!"
else
  puts "Товары уже есть, пропускаем..."
end