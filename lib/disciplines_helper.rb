# frozen_string_literal: true
module DisciplinesHelper
  def get_disciplines_daily_access
    questions = JSON.parse(File.open('new_questions.json', 'r').read)

    daily_access = Hash.new { |h, k| h[k] = 0 }

    questions.map { |q| daily_access[q["discipline"]] += q["daily_access"] }

    daily_access
  end
end
