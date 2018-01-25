# frozen_string_literal: true

module Auth
  # TODO: documentation is missing for this class
  # We should consider addig some documentation here
  class UsersController < BaseController
    before_action :load_user, only: %i[edit update destroy]
    before_action :load_roles, only: %i[new edit create update]
    before_action :require_login, :check_user, only: %i[edit update destroy]

    def new
      @user = User.new
    end

    def create
      if valid_user?
        auto_login(@user)
        redirect_back_or_to(root_path, notice: t('auth.users.create.signup_success'))
      else
        flash[:alert] = t('auth.users.create.signup_fail', errors: @user.errors.full_messages)
        render :new
      end
    end

    def edit; end

    def update
      if valid_user?
        redirect_back_or_to(root_path, notice: t('auth.users.update.update_success'))
      else
        flash[:alert] = t('auth.users.update.update_fail', errors: @user.errors.full_messages)
        render :edit
      end
    end

    def destroy
      @user.destroy
      redirect_to root_path, notice: t('auth.users.destroy.success')
    end

    private

    def valid_user?
      if @user&.persisted?
        validate_params.success? && @user.update(validate_params.output)
      else
        @user = User.new(validate_params.output)
        validate_params.success? && @user.save
      end
    end

    def check_user
      authorize @user
    end

    def validate_params
      UserSchema.with(valid_roles: @roles).call(user_params.to_h)
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, roles: [])
    end

    def load_user
      @user = User.find(params[:id])
    end

    def load_roles
      @roles = Settings.valid_roles - Settings.unpermitted_roles
    end
  end
end
