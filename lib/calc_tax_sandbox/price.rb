module CalcTaxSandbox
  class Price
    attr_reader :without_tax, :tax

    def initialize(without_tax, tax, keigen: false)
      @without_tax = without_tax
      @tax = tax
      @keigen = keigen
    end

    def keigen?
      @keigen
    end

    def with_tax
      without_tax + tax
    end

    def ==(other)
      if other.is_a?(Price)
        without_tax == other.without_tax && tax == other.tax && keigen? == other.keigen?
      else
        false
      end
    end
  end
end
