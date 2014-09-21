include Finance

class Account < ActiveRecord::Base
  has_many :entries, dependent: :destroy
  validates :name, presence: true

  def value_at(desired_date)
    # Return the value of the account, using linear interpolation between the two
    # nearest known valuation points.

    # Get the entry immediately before the desired_date...
    entry_before = self.entries.where("entrydate <= ?", desired_date)[0]
    return entry_before.value if entry_before.entrydate == desired_date

    # ...and the one after.
    entry_after = self.entries.where("entrydate > ?", desired_date).last

    # Linear interpolation in between
    portion = (desired_date - entry_before.entrydate).to_f / (entry_after.entrydate - entry_before.entrydate)
    return entry_before.value + portion * (entry_after.value - entry_before.value)
  end

  def apr_between(date1, date2)
    # Create an array of transactions, starting with a negative one representing the value at date1...
    transactions = []
    transactions << Transaction.new( - self.value_at(date1), date: date1.to_time )

    # ...now list any intervening transactions, deposits as negative/withdrawals as positive...
    transactions += self.entries.deposit.where("entrydate > ? and entrydate <= ?", date1, date2).map {|e|
        Transaction.new( - e.value, date: e.entrydate.to_time)
    }

    # ...finally a positive transaction representing the value at date2.
    transactions << Transaction.new( + self.value_at(date2), date: date2.to_time )

    # Calculate and return the effective APR as a float
    return transactions.xirr.apr.to_f
  end

  def overall_apr()
    # Return the apr calculated between the earliest and the latest valuations.
    earliest_valuation = self.entries.valuation.last
    latest_valuation   = self.entries.valuation.first
    return self.apr_between(earliest_valuation.entrydate, latest_valuation.entrydate)
  end
end
