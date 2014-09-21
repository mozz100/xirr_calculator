class EntriesController < ApplicationController
  def create
    @account = Account.find(params[:entry][:account_id])
    # (Safely) create a new Entry from POSTed params
    @new_entry = Entry.new(entry_params)

    # Based on params[:description], set the entrytype and value
    @new_entry.entrytype = Entry.entrytypes[:valuation] if params[:description] == "Valuation"
    @new_entry.entrytype = Entry.entrytypes[:deposit]   if params[:description] == "Deposit"
    if params[:description] == "Withdrawal"
      # A withdrawal is a deposit with a negative value
      @new_entry.entrytype = Entry.entrytypes[:deposit]
      @new_entry.value = -1.0 * @new_entry.value.abs # ensure negative or zero
    end

    # Tell user if .save fails
    if not @new_entry.save
        redirect_to @account, notice: "Unable to save. Invalid entry?"
        return
    end
    redirect_to @account, notice: "Saved new entry."
    
  end

  def destroy
    @entry = Entry.find(params[:id])
    @account = @entry.account
    @entry.delete
    redirect_to @account, notice: "Deleted entry."
  end

  private

  def entry_params
    params.require(:entry).permit(:account_id, :value, :entrydate)
  end
end
