class HomeController < ApplicationController
  def index
    account = Account.new

    # 残高確認
    @account = account.find

    # 入出金履歴
    @transfers_all = account.transfers_all
  end
end
