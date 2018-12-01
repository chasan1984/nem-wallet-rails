class TransactionsController < ApplicationController
  def index
  end

  def create
    # 送金
    account = Account.new
    account.transfer(transaction_params)
  end

  private

    def transaction_params
      params.require(:transaction).permit(:address, :amount, :message)
    end
end
