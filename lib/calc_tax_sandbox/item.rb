require 'date'

module CalcTaxSandbox
  class Item
    NEW_RULE_START_DATE = Date.new(2019, 10, 1)

    attr_reader :name, :price

    def initialize(name, price)
      @name = name
      @price = price
    end

    def price_with_tax(on: Date.today, **params)
      rate = on < NEW_RULE_START_DATE || keigen?(params) ? 1.08 : 1.1
      (price * rate).floor
    end

    def keigen?(*)
      false
    end
  end
end
