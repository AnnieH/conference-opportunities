require 'rails_helper'

RSpec.describe Organizers::OmniauthCallbacksController do
  let(:uid) { '123545' }
  let(:valid_twitter_auth) do
    OmniAuth::AuthHash.new(
      provider: 'twitter',
      uid: uid,
      info: {nickname: 'conf'}
    )
  end

  describe "#twitter" do
    before do
      request.env['omniauth.auth'] = valid_twitter_auth
    end

    context 'when the corresponding conference exists' do
      let!(:conference) do
        Conference.create!(twitter_handle: 'conf', uid: uid)
      end

      it "redirects the organizer's conference edit page" do
        get :twitter
        expect(response).to redirect_to edit_conference_path(conference)
      end
    end

    context 'when there is no corresponding conference' do
      it 'redirects to the home page' do
        get :twitter
        expect(response).to redirect_to root_path
      end

      it 'warns the user that they are not a conference' do
        get :twitter
        expect(flash[:alert]).to eq 'You are not a conference'
      end
    end
  end
end
