# frozen_string_literal: true
require 'spec_helper'

RSpec.describe(QuestionsController) do
  describe "get most accessed" do
    context "with correct parameters" do
      it "gets accesses with orm" do
        get 'index',
        params: { orm: 'true', offset: 0, limit: 10, range: 'weekly', start_timestamp: 1561939200 }

        assert_response :success
      end
      it "gets accesses from files" do
        get 'index',
        params: { offset: 0, limit: 10, range: 'weekly', start_timestamp: 1561939200 }

        assert_response :success

        body = JSON.parse(response.body)

        expect(body["questions"]).to(be_an_instance_of(Array))
        expect(body["total"]).to(be_an_instance_of(Integer))
      end
    end
    context "with incorrect parameters" do
      it "should not succeed" do
        get 'index',
        params: { offset: 0, limit: 10, range: 'daily' }

        assert_response :bad_request
      end
    end
  end
end
