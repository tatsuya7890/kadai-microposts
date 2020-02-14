class Micropost < ApplicationRecord
  
  #ユーザモデルとの関係
  belongs_to :user
  
  #バリデーション
  validates :content, presence: true, length: { maximum: 255 }

  ###多対他の関係###
    #favoritesテーブルとの関係
    has_many :favorites, dependent: :destroy
    has_many :is_liked, through: :favorites, source: :user
  ##################  

end
