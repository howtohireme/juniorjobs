# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::Admin::UsersController, type: :controller do
  describe 'GET #index' do
    subject do
      login_user(user)
      get :index
    end

    context 'admin can see users list' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to render_template(:index) }
      it { is_expected.to have_http_status(:success) }
    end

    context 'non admin cant see users list' do
      let(:user) { create(:user, :junior) }

      it { is_expected.to have_http_status(:forbidden) }
    end

    context 'anonym cant see users list' do
      it 'redirects to login path' do
        get :index
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'PUT #update' do
    context 'admin can update user' do
      let(:user) { create(:user, :junior) }
      let(:admin) { create(:user, :admin) }
      let(:new_password) { 'newpassword' }
      let(:params) do
        { id: user.id,
          user:
               { email: user.email,
                 password: new_password,
                 password_confirmation: new_password,
                 roles: ['admin'] } }
      end

      before do
        login_user(admin)
        put 'update', params: params
      end

      it 'updates user password' do
        expect(user.reload.valid_password?(new_password)).to eq true
      end

      it 'updates user role' do
        expect(user.reload.roles).to eq(['admin'])
      end

      it 'redirects to user list' do
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'other user cannot update profile' do
      let(:user) { create(:user, :junior) }
      let(:params) do
        { id: user.id,
          user:
              { email: user.email,
                password: 'secret',
                password_confirmation: 'secret',
                roles: ['admin'] } }
      end

      before do
        login_user(user)
        put 'update', params: params
      end

      it 'not updates user role' do
        expect(user.reload.roles).not_to eq(['admin'])
      end

      it 'show forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'anonym cant edit users in admin namespace' do
      let(:user) { create(:user, :junior) }
      let(:params) do
        { id: user.id,
          user:
            { email: user.email,
              password: 'secret',
              password_confirmation: 'secret',
              roles: ['admin'] } }
      end

      it 'redirects to login path' do
        put 'update', params: params
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user, :company) }

    context 'admin can delete users' do
      let(:admin) { create(:user, :admin) }

      before do
        login_user(admin)
        delete 'destroy', params: { id: user.id }
      end

      it 'delete user' do
        expect(User.exists?(user.id)).to eq false
      end

      it 'redirects to main page' do
        expect(response).to redirect_to admin_users_path
      end
    end

    context 'other user cant delete profiles in admin namespace' do
      before do
        login_user(user)
        delete 'destroy', params: { id: user.id }
      end

      it 'not delete user' do
        expect(User.exists?(user.id)).to eq true
      end

      it 'show forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'anonym cant delete users in admin namespace' do
      it 'redirects to login path' do
        delete 'destroy', params: { id: user.id }
        expect(response).to redirect_to login_path
      end
    end
  end
end
