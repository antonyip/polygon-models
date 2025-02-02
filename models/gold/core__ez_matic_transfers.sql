{{ config(
    materialized = 'incremental',
    incremental_strategy = 'delete+insert',
    unique_key = 'tx_hash',
    cluster_by = ['block_timestamp::DATE'],
    post_hook = "ALTER TABLE {{ this }} ADD SEARCH OPTIMIZATION"
) }}

WITH matic_base AS (

    SELECT
        tx_hash,
        block_number,
        block_timestamp,
        identifier,
        from_address,
        to_address,
        matic_value,
        _call_id,
        _inserted_timestamp
    FROM
        {{ ref('silver__traces') }}
    WHERE
        matic_value > 0
        AND tx_status = 'SUCCESS'
        AND gas_used IS NOT NULL

{% if is_incremental() %}
AND _inserted_timestamp >= (
    SELECT
        MAX(
            _inserted_timestamp
        ) :: DATE - 2
    FROM
        {{ this }}
)
{% endif %}
),
matic_price AS (
    SELECT
        HOUR,
        AVG(price) AS matic_price
    FROM
        {{ source(
            'ethereum',
            'fact_hourly_token_prices'
        ) }}
    WHERE
        token_address = LOWER('0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0')
    GROUP BY
        HOUR
),
tx_table AS (
    SELECT
        tx_hash,
        from_address AS origin_from_address,
        to_address AS origin_to_address,
        origin_function_signature
    FROM
        {{ ref('silver__transactions') }}
    WHERE
        tx_hash IN (
            SELECT
                DISTINCT tx_hash
            FROM
                matic_base
        )

{% if is_incremental() %}
AND _inserted_timestamp >= (
    SELECT
        MAX(
            _inserted_timestamp
        ) :: DATE - 2
    FROM
        {{ this }}
)
{% endif %}
)
SELECT
    A.tx_hash AS tx_hash,
    A.block_number AS block_number,
    A.block_timestamp AS block_timestamp,
    A.identifier AS identifier,
    origin_from_address,
    origin_to_address,
    origin_function_signature,
    A.from_address AS matic_from_address,
    A.to_address AS matic_to_address,
    A.matic_value AS amount,
    ROUND(
        A.matic_value * matic_price,
        2
    ) AS amount_usd,
    _call_id,
    _inserted_timestamp
FROM
    matic_base A
    LEFT JOIN matic_price
    ON DATE_TRUNC(
        'hour',
        block_timestamp
    ) = HOUR
    LEFT JOIN tx_table
    ON A.tx_hash = tx_table.tx_hash
