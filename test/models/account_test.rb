require 'test_helper'
require 'bigdecimal'
include Finance

class AccountTest < ActiveSupport::TestCase
  setup do
    @pension = accounts(:pension)
  end
  test "sanity check" do
    assert true
    assert @pension.entries.count >= 2
  end

  test "should return correct value_at" do
    # check sanity at known valuation points
    assert_equal 1100, entries(:pension_later).value
    assert_equal 1200, entries(:pension_even_later).value
    assert_equal entries(:pension_later).value, @pension.value_at(entries(:pension_later).entrydate)
    assert_equal entries(:pension_even_later).value, @pension.value_at(entries(:pension_even_later).entrydate)

    # calculate interval and check it's as expected (100)
    interval = entries(:pension_even_later).entrydate - entries(:pension_later).entrydate
    assert_equal 100, interval
    delta = entries(:pension_even_later).value - entries(:pension_later).value

    # check linear interpolation at midpoint (known)
    mid_value = entries(:pension_later).value + 0.5 * delta
    assert_equal 1150, @pension.value_at(entries(:pension_later).entrydate + (0.5 * interval).days)

    # check linear interpolation at other points
    [0.5, 0.1, 0.25, 0.9, 1/7, 2 ** -0.5].each do |x|
      expected_value = entries(:pension_later).value + x * delta
      assert_equal expected_value, @pension.value_at(entries(:pension_later).entrydate + (x * interval).days)
    end

  end

  test "should calculate xirr" do
    # A simple example, explicitly, and then using the .apr_between method
    trans = []
    start = Time.new(2013,1,1)
    trans << Transaction.new( -1000, date: start )
    trans << Transaction.new(  -500, date: start + (366/2) * 24 * 60 * 60 )
    trans << Transaction.new( +1550, date: start +  366    * 24 * 60 * 60 )
    assert_equal "3.997%", (100 * trans.xirr.apr).to_f.round(3).to_s + "%"

    # should get same answer as above
    date1 = entries(:xirr_start).entrydate
    date2 = entries(:xirr_end).entrydate
    assert_equal 0.03997, accounts(:xirr_test).apr_between(date1, date2).round(5)

    # Now calculate on @pension, simple first...
    trans = []
    start = Time.new(2013,1,1)
    trans << Transaction.new( -1100, date: start )
    trans << Transaction.new( +1200, date: start + 100 * 24 * 60 * 60 )
    assert_equal "37.381%", (100 * trans.xirr.apr).to_f.round(3).to_s + "%"

    # ...and using the method
    date1 = entries(:pension_later).entrydate
    date2 = entries(:pension_even_later).entrydate
    assert_equal 0.37381, @pension.apr_between(date1, date2).round(5)

    # zero APR
    entries(:pension_even_later).value = entries(:pension_later).value
    entries(:pension_even_later).save
    assert_equal 0, @pension.apr_between(date1, date2).round(5)

    # and negative APR
    entries(:pension_even_later).value = entries(:pension_later).value - 100
    entries(:pension_even_later).save
    assert_equal -1.14814, @pension.apr_between(date1, date2).round(5)

  end

  test "should calculate overall apr" do
    assert_equal 0.30366, @pension.overall_apr.round(5)
  end

  test "should handle boundary conditions" do
    # check that a deposit on the same day as the first valuation is not included in
    # APR calculations
    # in other words, if a valuation and a deposit have the same date, 
    # the deposit is treated as if it occurred before the valuation.
    @pension.entries << Entry.new(entrytype: 1, entrydate: entries(:initial_pension).entrydate, value: 1000)
    assert_equal 0.30366, @pension.overall_apr.round(5)

    # a deposit on the final day does affect apr
    @pension.entries << Entry.new(entrytype: 1, entrydate: entries(:pension_even_later).entrydate, value: 1000)
    assert_equal -0.90375, @pension.overall_apr.round(5)

  end
end
