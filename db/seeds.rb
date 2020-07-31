# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

init = Process.clock_gettime(Process::CLOCK_MONOTONIC)
questions = JSON.parse(File.open("#{Rails.root}/new_questions.json", 'r').read)
question_access = JSON.parse(File.open("#{Rails.root}/new_question_access.json", 'r').read)

Question.transaction do
  Question.import(questions)
  QuestionAccess.import(question_access)
end

p("DB seeded in #{Process.clock_gettime(Process::CLOCK_MONOTONIC) - init} seconds.")
Rails.logger.info("DB seeded in #{Process.clock_gettime(Process::CLOCK_MONOTONIC) - init} seconds.")
