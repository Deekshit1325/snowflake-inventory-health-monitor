import streamlit as st

st.set_page_config(page_title="Inventory Health Dashboard", layout="wide")

st.title("📦 Inventory Health Monitoring Dashboard")

# Connect to Snowflake (auto-managed)
conn = st.connection("snowflake")

query = """
SELECT
    location,
    item,
    closing_stock,
    lead_time_days,
    stock_status,
    reorder_quantity
FROM STOCK_HEALTH_DT
ORDER BY stock_status DESC, reorder_quantity DESC
"""

df = conn.query(query)

# Main table
st.subheader("📊 Current Stock Health")
st.dataframe(df, use_container_width=True)

# Low stock section
low_stock = df[df["STOCK_STATUS"] == "LOW STOCK"]

st.subheader("⚠️ Items Needing Immediate Attention")
st.dataframe(low_stock, use_container_width=True)

# KPIs
col1, col2, col3 = st.columns(3)
col1.metric("Total Items", len(df))
col2.metric("Low Stock Items", len(low_stock))
col3.metric(
    "Total Reorder Quantity",
    int(low_stock["REORDER_QUANTITY"].sum()) if len(low_stock) > 0 else 0
)

# Simple chart
st.subheader("📉 Reorder Quantity by Location")
st.bar_chart(
    low_stock.groupby("LOCATION")["REORDER_QUANTITY"].sum()
)

low_count = len(low_stock)

if low_count > 0:
    st.warning(f"There are {low_count} items at risk of stock-out. Immediate reordering is recommended to avoid supply disruption.")
else:
    st.success("All inventory levels are healthy. No immediate action required.")

import altair as alt

heatmap = alt.Chart(df).mark_rect().encode(
    x='LOCATION',
    y='ITEM',
    color='CLOSING_STOCK:Q'
)

st.subheader("📊 Stock Heatmap")
st.altair_chart(heatmap, use_container_width=True)
