# frozen_string_literal: true

module Auth
  # TODO: documentation is missing for this class
  # We should consider addig some documentation here
  class OauthsController < BaseController
    skip_before_action :require_login, raise: false

    def oauth
      login_at(provider)
    end

    def callback
      if (@user = login_from(provider))
        redirect_to root_path, notice: t('.notice', provider: provider.titleize)
      else
        create_user
      end
    end

    private

    def create_user
      @user = create_from(provider) { |user| user.roles = ['junior'] }
      reset_session
      auto_login(@user)
      redirect_to root_path, notice: t('.notice', provider: provider.titleize)
    rescue StandardError => e
      redirect_to root_path, alert: t('.alert', error: e.message)
    end

    def auth_params
      params.permit(:code, :provider)
    end

    def provider
      auth_params[:provider]
    end
  end
end
