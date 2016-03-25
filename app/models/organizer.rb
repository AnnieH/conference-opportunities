class Organizer < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:twitter]

  has_one :organizer_conference
  has_one :conference, through: :organizer_conference

  validates :organizer_conference, presence: true, associated: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: {scope: :provider, case_sensitive: false}

  def self.from_omniauth(auth)
    Organizer.find_or_initialize_by(uid: auth.uid, provider: auth.provider) do |organizer|
      organizer.conference = Conference.find_by(twitter_handle: auth.info.nickname)
    end
  end
end
