# frozen_string_literal: true
require 'spec_helper'

RSpec.describe(DisciplinesController) do
  describe "get disciplines ranking" do
    it "gets ranking with orm" do
      get 'get_disciplines_accesses',
      params: { orm: 'true' }

      assert_response :success
    end
    it "gets ranking from files" do
      get 'get_disciplines_accesses'

      assert_response :success

      body = JSON.parse(response.body)

      expect(body["access_ranking"]).to(be_an_instance_of(Array))
      expect(body["total_accesses"]).to(be_an_instance_of(Integer))
    end
  end
  describe "get disciplines with hottest questions" do
    it "gets with orm" do
      get 'get_hottest_disciplines'

      assert_response :success
    end
    it "gets from files" do
      get 'get_hottest_disciplines'

      assert_response :success

      body = JSON.parse(response.body)
      expect(body["hottest_disciplines"]).to(be_an_instance_of(Array))
    end
  end
end
