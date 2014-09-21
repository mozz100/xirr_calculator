require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  
  setup do
    @pension = accounts(:pension)
    sign_in users(:alice)
  end


  test "should create entry" do
    assert_difference('Entry.valuation.count', +1) do
      post :create, description: "Valuation", entry: { account_id: @pension.id, value: 300, entrydate: "2014-08-02" }
    end
    assert_equal "Saved new entry.", flash[:notice]
    assert_redirected_to @pension
  end

  test "should create withdrawal" do
    [-300, +300].each do |amount|
      assert_difference('Entry.deposit.count', +1) do
        post :create, description: "Withdrawal", entry: { account_id: @pension.id, value: amount, entrydate: "2014-08-02" }
      end
      # Check that amount is negative independent of submission
      assert_equal -300, assigns[:new_entry].value
      assert_equal "Saved new entry.", flash[:notice]
      assert_redirected_to @pension
    end
  end

  test "should reject invalid entries" do
    # test missing value, invalid value
    ["", "xyz"].each do |amount|
      assert_difference('Entry.valuation.count', 0) do
        # missing value
        post :create, description: "Valuation", entry: { account_id: @pension.id, value: amount, entrydate: "2014-08-02" }
      end
      assert_equal "Unable to save. Invalid entry?", flash[:notice]
      assert_redirected_to @pension
    end
  end

  test "should destroy entry" do
    assert_difference('Entry.count', -1) do
      delete :destroy, id: entries(:pension_later).id
    end
  end
end
