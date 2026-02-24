# Создание админа
admin_email = 'admin@test.com'

# Ищем пользователя по email, если не находим — создаем
admin = User.find_or_initialize_by(email: admin_email)

if admin.new_record?
  puts "Создаём тестового админа..."
  admin.password = 'password'
  admin.password_confirmation = 'password'
  admin.role = 'admin'
  admin.first_name = 'Admin'
  admin.last_name = 'User'
  admin.save!
  puts "Админ создан: #{admin_email} / password"
else
  puts "Админ с email #{admin_email} уже существует, обновляем роль до admin..."
  admin.update!(role: 'admin') # На всякий случай убедимся, что роль верная
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
  puts "Товары уже есть, пропускаем создание товаров..."
end