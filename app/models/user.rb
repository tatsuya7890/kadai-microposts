class User < ApplicationRecord
  
  #self.email.downcase! は、文字を全て小文字に変換するというもの
  before_save {self.email.downcase!}
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  #1対多の関係
  has_many :microposts
  #多対他の関係
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  def follow(other_user)
    unless self == other_user
      #見つかれば Relationshipモデル（クラス）のインスタンスを返す、見つからなければフォロー関係を保存(create = build + save)
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    #relationship が存在すれば destroy します
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    #other_user が含まれていないかを確認。含まれている場合には、true を返し、含まれていない場合には、false を返す
    self.followings.include?(other_user)
  end
  
  #タイムライン用(Micropost.where(user_id:フォローユーザ＋自分自身)) ..._idsはhas_many ...によって自動的に生成されるメソッド
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
end
