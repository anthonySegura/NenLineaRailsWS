class User < ApplicationRecord

  validates :name , presence: true
  validates :nickname, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates_uniqueness_of :nickname
  validates_uniqueness_of :email

  has_many :sesions
end
