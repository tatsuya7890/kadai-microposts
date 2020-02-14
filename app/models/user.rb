class User < ApplicationRecord
  
  #self.email.downcase! は、文字を全て小文字に変換するというもの
  before_save {self.email.downcase!}

  #バリデーション
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }

  #パスワード暗号化
  has_secure_password
  
  #1対多の関係
  has_many :microposts

  ###多対他の関係###
    #relationshipsテーブルとの関係
    has_many :relationships
    has_many :followings, through: :relationships, source: :follow
    #reverses_of_relationshipテーブルとの関係(同じテーブルuserを参照するため)
    has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
    has_many :followers, through: :reverses_of_relationship, source: :user
  
    #favoritesテーブルとの関係
    has_many :favorites, dependent: :destroy
    has_many :likes, through: :favorites, source: :micropost
  ##################  
  
  ####フォロー機能###
  #フォロー
  def follow(other_user)
    #フォローしようとしている other_user が自分自身ではないかチェック
    unless self == other_user
      #見つかれば Relationshipモデル（クラス）のインスタンスを返す、見つからなければフォロー関係を保存(create = build + save)
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  #フォロー解除
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    #relationship が存在すれば destroy します
    relationship.destroy if relationship
  end
  
  #フォローしているかチェック
  def following?(other_user)
    #other_user が含まれていないかを確認。含まれている場合には、true を返し、含まれていない場合には、false を返す
    self.followings.include?(other_user)
  end
  #####################

  ####お気に入り機能###
    #お気に入り追加
    def favorite(other_favorite)
      #お気に入り登録しようとしている other_favorite が自分が作成したものかどうかのチェック
      unless self == other_favorite
        #見つかれば Favorites（クラス）のインスタンスを返す、見つからなければお気に入り関係を保存(create = build + save)
        self.favorites.find_or_create_by(micropost_id: other_favorite.id)
      end
    end
  
    #お気に入り解除
    def unfavorite(other_favorite)
      favorite = self.favorites.find_by(micropost_id: other_favorite.id)
      #favoriteが存在すれば削除
      favorite.destroy if favorite
    end
  
    #お気に入りされているかチェック
    def favorite?(other_favorite)
      self.likes.include?(other_favorite)
    end
  
  #####################

  #タイムライン用(Micropost.where(user_id:フォローユーザ＋自分自身)) ..._idsはhas_many ...によって自動的に生成されるメソッド
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
end
