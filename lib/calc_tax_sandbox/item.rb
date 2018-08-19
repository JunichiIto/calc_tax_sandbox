require 'date'

module CalcTaxSandbox
  class Item
    attr_reader :name, :price

    def initialize(name, price)
      @name = name
      @price = price
    end

    def price_with_tax(on: Date.today, **params)
      post_tax_price(on: on, **params).with_tax
    end

    def post_tax_price(on: Date.today, **params)
      use_old_rule = on < NEW_RULE_START_DATE
      keigen = !use_old_rule && keigen?(params)
      rate = use_old_rule || keigen ? OLD_TAX_RATE : NEW_TAX_RATE
      tax = (price * rate / 100.0).floor
      PostTaxPrice.new(price, tax, keigen: keigen)
    end

    def keigen?(*)
      false
    end
  end
end
