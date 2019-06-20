FactoryBot.define do
  factory :shared_asset do
    user { nil }
    shared_email { "MyString" }
    shared_user_id { 1 }
    asset_id { 1 }
    message { "MyString" }
    shared_file_token { "MyString" }
  end
end
