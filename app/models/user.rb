class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable and :omniauthable, :trackable, :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, :lockable

  store :settings, coder: JSON
end
