# frozen_string_literal: true
class CreateQuestionAccesses < ActiveRecord::Migration[6.0]
  def change
    create_table :question_accesses do |t|
      t.datetime(:date)
      t.integer(:times_accessed)
      t.timestamps
    end
    add_reference(:question_accesses, :question, foreign_key: true)
  end
end
