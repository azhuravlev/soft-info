FactoryBot.define do
  factory :tool do
    sequence :name do |n|
      "SuperTool##{n}"
    end

    sequence :repo_url do |n|
      "SuperTool##{n}.git.repo"
    end
  end
end