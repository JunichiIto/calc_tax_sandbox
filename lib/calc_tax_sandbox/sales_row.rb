module CalcTaxSandbox
  class SalesRow
    attr_reader :item, :post_tax_price, :quantity

    def initialize(item, post_tax_price, quantity)
      @item = item
      @post_tax_price = post_tax_price
      @quantity = quantity
    end

    def keigen?
      post_tax_price.keigen?
    end

    def total
      post_tax_price.with_tax * quantity
    end
  end
end