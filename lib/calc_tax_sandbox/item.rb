require 'date'

module CalcTaxSandbox
  class Item
    NEW_RULE_START_DATE = Date.new(2019, 10, 1)
    OLD_TAX_RATE = 1.08
    NEW_TAX_RATE = 1.1

    attr_reader :name, :price

    def initialize(name, price)
      @name = name
      @price = price
    end

    def price_with_tax(on: Date.today, **params)
      rate = on < NEW_RULE_START_DATE || keigen?(params) ? OLD_TAX_RATE : NEW_TAX_RATE
      (price * rate).floor
    end

    def keigen?(*)
      false
    end
  end
end
