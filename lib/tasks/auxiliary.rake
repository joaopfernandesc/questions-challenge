# frozen_string_literal: true
namespace :aux do
  # Checking whether question_access is somehow ordered with questions
  task check_order: :environment do
    questions_ids = JSON.parse(File.open("#{Rails.root}/questions.json", 'r').read).pluck("id")
    access_questions_ids = JSON.parse(File.open("#{Rails.root}/question_access.json", 'r').read).pluck("question_id")
    ordered = true

    questions_ids.enum_for(:each_with_index)
      .map do |_q, i|
        ordered = false if questions_ids[i] != access_questions_ids[i * 100]
      end

    p ordered
  end

  # Recreating id column so it can be imported
  task recreate_questions: :environment do
    questions = JSON.parse(File.open("#{Rails.root}/questions.json", 'r').read)
    question_access = JSON.parse(File.open("#{Rails.root}/question_access.json", 'r').read)

    questions.enum_for(:each_with_index).map do |_q, i|
      questions[i]["id"] = i + 1
      question_access[i * 100..((i + 1) * 100 - 1)]
        .enum_for(:each_with_index)
        .map { |_aq, j| question_access[i * 100 + j]["question_id"] = i + 1 }
    end

    File.open("new_questions.json", 'wb') { |f| f << questions.to_json }
    File.open("new_question_access.json", 'wb') { |f| f << question_access.to_json }
  end
end
