class Entry < ActiveRecord::Base
  belongs_to :account
  enum entrytype: { valuation: 0, deposit: 1 }
  
  # Default to reverse chronological order, deposits at 12:00, valuations at 23:59
  # IMPORTANT - other methods rely on this default sort order.
  default_scope { order("entrydate DESC, entrytype, id DESC") }  

  validates :entrydate, :entrytype, :account, :value, :presence => true
  validates :value, numericality: true

  # TODO value of deposit can't be zero, value of valuation must be non-zero to avoid nonconvergence

  def description
    return "Valuation" if self.entrytype == "valuation"
    return "Deposit" if self.entrytype == "deposit" and self.value >= 0
    return "Withdrawal"
  end
end
