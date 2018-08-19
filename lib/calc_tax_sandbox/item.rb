require 'date'

module CalcTaxSandbox
  class Item
    attr_reader :name, :price

    def initialize(name, price)
      @name = name
      @price = price
    end

    def price_with_tax(on: Date.today, **options)
      build_post_tax_price(on: on, **options).with_tax
    end

    def build_post_tax_price(on: Date.today, **options)
      use_old_rule = on < NEW_RULE_START_DATE
      keigen = !use_old_rule && keigen?(options)
      rate = use_old_rule || keigen ? OLD_TAX_RATE : NEW_TAX_RATE
      tax = (price * rate / 100.0).floor
      PostTaxPrice.new(price, tax, keigen: keigen)
    end

    def keigen?(*)
      false
    end
  end
end
