FactoryBot.define do
  factory :access_token, class: Doorkeeper::AccessToken do
    sequence(:resource_owner_id) { |n| n }
    application
    expires_in { 2.hours }
    scopes { "all" }

    factory :clientless_access_token do
      application { nil }
    end
  end
end
