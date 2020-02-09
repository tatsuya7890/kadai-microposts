class User < ApplicationRecord
  
  #self.email.downcase! は、文字を全て小文字に変換するというもの
  before_save {self.email.downcase!}
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  #1対多
  has_many :microposts
  
end
