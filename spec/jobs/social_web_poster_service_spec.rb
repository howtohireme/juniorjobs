# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SocialWebPosterService do
  ActiveJob::Base.queue_adapter = :test
  let(:post) { SocialWebPosterService.new.post_job(1) }

  it 'VkontakteWorker is working' do
    expect { post }.to have_enqueued_job(VkontaktePostJob)
  end
  it 'FacebookWorker is working' do
    expect { post }.to have_enqueued_job(FacebookPostJob)
  end
  it 'TelegramWorker is working' do
    expect { post }.to have_enqueued_job(TelegramPostJob)
  end
  it 'TwitterWorker is working' do
    expect { post }.to have_enqueued_job(TwitterPostJob)
  end
end
