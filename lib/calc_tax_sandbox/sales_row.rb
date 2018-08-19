module CalcTaxSandbox
  class SalesRow
    attr_reader :item, :price_detail, :quantity

    def initialize(item, price_detail, quantity)
      @item = item
      @price_detail = price_detail
      @quantity = quantity
    end

    def keigen?
      price_detail.keigen?
    end
  end
end