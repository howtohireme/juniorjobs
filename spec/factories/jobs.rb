# frozen_string_literal: true

FactoryBot.define do
  factory :job do
    title 'Разработчик'
    employment 'full'
    city 'Москва'
    description 'Штатный программист'
    requirements 'Работать много и пить кофе'

    company_name 'Бадишоп'
    company_contact 'Директор Бадишопа'
    company_email 'email@example.com'
    expired_at Date.current + 1 .week
    token 'token'

    trait :invalid do
      description nil
    end

    trait :approved do
      status :approved
    end

    trait :with_tag_list do
      tag_list %i[ruby java php js]
    end
  end
end
