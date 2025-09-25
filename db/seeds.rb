# 開発用の初期ユーザーを投入（存在しない場合のみ）
if User.where(user_id: "admin").exists?
  puts "Seed: user 'admin' already exists"
else
  User.create!(user_id: "admin", password: "password123", password_confirmation: "password123", name: "管理者")
  puts "Seed: created user_id=admin / password=password123"
end
