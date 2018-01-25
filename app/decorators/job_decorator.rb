# frozen_string_literal: true

# Decorate methods for Job model. Example: @jobs = Job.all.decorate
class JobDecorator < ApplicationDecorator
  delegate_all

  def status
    object.status? ? t('decorators.job.active_status') : t('decorators.job.expired_status')
  end
end
