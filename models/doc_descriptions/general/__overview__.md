{% docs __overview__ %}

# Welcome to the Flipside Crypto Polygon Models Documentation!

## **What does this documentation cover?**
The documentation included here details the design of the Polygon tables and views available via [Flipside Crypto.](https://flipsidecrypto.xyz/) For more information on how these models are built, please see [the github repository.](https://github.com/FlipsideCrypto/polygon-models)

## **How do I use these docs?**
The easiest way to navigate this documentation is to use the Quick Links below. These links will take you to the documentation for each table, which contains a description, a list of the columns, and other helpful information.

If you are experienced with dbt docs, feel free to use the sidebar to navigate the documentation, as well as explore the relationships between tables and the logic building them.

There is more information on how to use dbt docs in the last section of this document.

## **Quick Links to Table Documentation**

**Click on the links below to jump to the documentation for each schema.**

### Core Tables (polygon.core)

**Dimension Tables:**
- [dim_contracts](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__dim_contracts)
- [dim_labels](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__dim_labels)

**Fact Tables:**
- [fact_blocks](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__fact_blocks)
- [fact_decoded_event_logs](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__fact_decoded_event_logs)
- [fact_event_logs](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__fact_event_logs)
- [fact_token_transfers](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__fact_token_transfers)
- [fact_traces](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__fact_traces)
- [fact_transactions](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__fact_transactions)

**Convenience Tables:**
- [ez_decoded_event_logs](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__ez_decoded_event_logs)
- [ez_matic_transfers](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__ez_matic_transfers)
- [ez_nft_mints](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__ez_nft_mints)
- [ez_nft_sales](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__ez_nft_sales)
- [ez_nft_transfers](https://flipsidecrypto.github.io/polygon-models/#!/model/model.polygon_models.core__ez_nft_transfers)

## **Helpful User-Defined Functions (UDFs)**

UDFs are custom functions built by the Flipside team that can be used in your queries to make your life easier.

Helpful UDFs for working with EVM data:
```sql
-- Convert a hex encoded value to an integer with ethereum.public.udf_hex_to_int(FIELD::string)
select '0xFC3C88'::string as hex_value, ethereum.public.udf_hex_to_int('0xFC3C88') as int_value
```

## **Data Model Overview**

The Polygon models are built a few different ways, but the core fact tables are built using three layers of sql models: **bronze, silver, and gold (or core).**

- Bronze: Data is loaded in from the source as a view
- Silver: All necessary parsing, filtering, de-duping, and other transformations are done here
- Gold (or core): Final views and tables that are available publicly

The dimension tables are sourced from a variety of on-chain and off-chain sources.

Convenience views (denoted ez_) are a combination of different fact and dimension tables. These views are built to make it easier to query the data.

## **Contract Decoding**
### Adding a contract for decoding
To add a contract for decoding, please visit [here](https://science.flipsidecrypto.xyz/abi-requestor/). 

Assuming the submitted ABI is valid, records will be decoded within 24 hours. If records are not decoded within 24 hours, or for any ABI updates, please submit a ticket within our Discord. 

### General Process Overview

The majority of our ABIs have been sourced from Etherscan, and we are constantly asking Etherscan for new ABIs. However, this is not comprehensive, and therefore we must also rely on our users to submit ABIs for decoding.
If we are unable to locate an ABI for the contract from either Etherscan or our users, we will attempt to match the contract to a similar ABI. This is done by comparing the contract bytecode to a list of known contract bytecodes. If we are able to match the contract to a similar ABI, we will decode the contract using the similar ABI. You can see the source of each ABI in the `dim_contract_abis` table within the `abi_source` column. 

Once ABIs have been verified, events within the last day of blocks will be decoded within approximately 90 minutes. Events older than 1 day will be decoded within 24 hours in the majority of cases. The exception here is if the contract has a massive number of events, in which case it may take longer.

## **Using dbt docs**
### Navigation

You can use the ```Project``` and ```Database``` navigation tabs on the left side of the window to explore the models in the project.

### Database Tab

This view shows relations (tables and views) grouped into database schemas. Note that ephemeral models are *not* shown in this interface, as they do not exist in the database.

### Graph Exploration

You can click the blue icon on the bottom-right corner of the page to view the lineage graph of your models.

On model pages, you'll see the immediate parents and children of the model you're exploring. By clicking the Expand button at the top-right of this lineage pane, you'll be able to see all of the models that are used to build, or are built from, the model you're exploring.

Once expanded, you'll be able to use the ```--models``` and ```--exclude``` model selection syntax to filter the models in the graph. For more information on model selection, check out the [dbt docs](https://docs.getdbt.com/docs/model-selection-syntax).

Note that you can also right-click on models to interactively filter and explore the graph.


### **More information**
- [Flipside](https://flipsidecrypto.xyz)
- [Tutorials](https://docs.flipsidecrypto.com/our-data/tutorials)
- [Github](https://github.com/FlipsideCrypto/polygon-models)
- [Query Editor Shortcuts](https://docs.flipsidecrypto.com/velocity/query-editor-shortcuts)
- [What is dbt?](https://docs.getdbt.com/docs/introduction)

{% enddocs %}
