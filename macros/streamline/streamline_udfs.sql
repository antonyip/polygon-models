{% macro create_udf_get_chainhead() %}
    CREATE OR REPLACE EXTERNAL FUNCTION streamline.udf_get_chainhead(
    ) returns variant api_integration = aws_polygon_api AS {% if target.name == "prod" %}
        'https://088pv40k78.execute-api.us-east-1.amazonaws.com/prod/get_chainhead'
    {% else %}
        'https://ug2z7nx4bi.execute-api.us-east-1.amazonaws.com/dev/get_chainhead'
    {%- endif %};
{% endmacro %}

{% macro create_udf_bulk_json_rpc() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_bulk_json_rpc(
        json variant
    ) returns text api_integration = aws_polygon_api AS {% if target.name == "prod" %}
        'https://088pv40k78.execute-api.us-east-1.amazonaws.com/prod/udf_bulk_json_rpc'
    {% else %}
        'https://ug2z7nx4bi.execute-api.us-east-1.amazonaws.com/dev/udf_bulk_json_rpc'
    {%- endif %};
{% endmacro %}

{% macro create_udf_bulk_get_traces() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_bulk_get_traces(
        json variant
    ) returns text api_integration = aws_polygon_api AS {% if target.name == "prod" %}
        'https://088pv40k78.execute-api.us-east-1.amazonaws.com/prod/udf_bulk_get_traces'
    {% else %}
        'https://ug2z7nx4bi.execute-api.us-east-1.amazonaws.com/dev/udf_bulk_get_traces'
    {%- endif %};
{% endmacro %}

{% macro create_udf_decode_array_string() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_decode(
        abi ARRAY,
        DATA STRING
    ) returns ARRAY api_integration = aws_polygon_api AS {% if target.name == "prod" %}
        'https://088pv40k78.execute-api.us-east-1.amazonaws.com/prod/decode_function'
    {% else %}
        'https://ug2z7nx4bi.execute-api.us-east-1.amazonaws.com/dev/decode_function'
    {%- endif %};
{% endmacro %}

{% macro create_udf_decode_array_object() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_decode(
        abi ARRAY,
        DATA OBJECT
    ) returns ARRAY api_integration = aws_polygon_api AS {% if target.name == "prod" %}
        'https://088pv40k78.execute-api.us-east-1.amazonaws.com/prod/decode_log'
    {% else %}
        'https://ug2z7nx4bi.execute-api.us-east-1.amazonaws.com/dev/decode_log'
    {%- endif %};
{% endmacro %}

{% macro create_udf_bulk_decode_logs() %}
    CREATE
    OR REPLACE EXTERNAL FUNCTION streamline.udf_bulk_decode_logs(
        json OBJECT
    ) returns ARRAY api_integration = aws_polygon_api AS {% if target.name == "prod" %}
        'https://088pv40k78.execute-api.us-east-1.amazonaws.com/prod/bulk_decode_logs'
    {% else %}
        'https://ug2z7nx4bi.execute-api.us-east-1.amazonaws.com/dev/bulk_decode_logs'
    {%- endif %};
{% endmacro %}
