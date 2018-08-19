require './lib/calc_tax_sandbox/price'
require './lib/calc_tax_sandbox/item'
require './lib/calc_tax_sandbox/food'
require './lib/calc_tax_sandbox/newspaper_subscription'
require './lib/calc_tax_sandbox/register'
require './lib/calc_tax_sandbox/sales_row'

module CalcTaxSandbox
  NEW_RULE_START_DATE = Date.new(2019, 10, 1)
  OLD_TAX_RATE = 8
  NEW_TAX_RATE = 10
end