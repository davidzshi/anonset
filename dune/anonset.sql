WITH token_movements AS (
  SELECT
    "to" AS holder_address,
    SUM(amount) AS token_amount
  FROM tokens.transfers
  WHERE
    contract_address = FROM_HEX('0Db510e79909666d6dEc7f5e49370838c16D950f')
    AND blockchain = 'base'
  GROUP BY
    "to"
  UNION ALL
  SELECT
    "from" AS holder_address,
    -SUM(amount) AS token_amount
  FROM tokens.transfers
  WHERE
    contract_address = FROM_HEX('0Db510e79909666d6dEc7f5e49370838c16D950f')
    AND blockchain = 'base'
  GROUP BY
    "from"
), net_balances AS (
  SELECT
    holder_address,
    SUM(token_amount) AS current_balance
  FROM token_movements
  WHERE
    NOT holder_address IS NULL
    AND holder_address <> FROM_HEX('0000000000000000000000000000000000000000')
  GROUP BY
    holder_address
  HAVING
    SUM(token_amount) > 0
)
SELECT
  holder_address
FROM net_balances
WHERE current_balance >= 5000;