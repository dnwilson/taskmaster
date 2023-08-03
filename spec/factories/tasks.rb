FactoryBot.define do
  factory :task do
    user { nil }
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4) }
    due_date { 3.days.from_now  }
    completed_at { nil }
    priority { Task.priorities.values.sample }

    trait :with_user do
      user
    end
  end
end
