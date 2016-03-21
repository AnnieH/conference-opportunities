class Organizer < ActiveRecord::Base
  devise :omniauthable, omniauth_providers: [:twitter]

  belongs_to :conference

  validates :conference_id, presence: true, uniqueness: {case_sensitive: false}
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: {scope: :provider, case_sensitive: false}

  def self.from_omniauth(auth)
    Organizer.find_or_initialize_by(uid: auth.uid, provider: auth.provider) do |organizer|
      organizer.conference = Conference.find_by(twitter_handle: auth.info.nickname)

    end
  end
end
