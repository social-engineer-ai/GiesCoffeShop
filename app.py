import streamlit as st
import pymysql
import pandas as pd

# --- Database Connection ---
def get_connection():
    return pymysql.connect(
        host='localhost',
        user='admin',
        password='GiesCoffee2026!',
        database='gies_coffee_shop',
        cursorclass=pymysql.cursors.DictCursor
    )

def run_query(query, params=None):
    conn = get_connection()
    try:
        df = pd.read_sql(query, conn, params=params)
        return df
    finally:
        conn.close()

def run_insert(query, params=None):
    conn = get_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(query, params)
        conn.commit()
    finally:
        conn.close()

# --- Page Config ---
st.set_page_config(
    page_title="Gies Coffee Shop",
    page_icon="☕",
    layout="wide"
)

# --- Sidebar Navigation ---
st.sidebar.title("☕ Gies Coffee Shop")
st.sidebar.markdown("*Fueling Illini since 2026*")
page = st.sidebar.radio("Navigate", ["🏠 Dashboard", "📋 Menu", "📊 Sales Analytics", "🛒 Place Order", "📝 Recent Orders"])

# --- Dashboard ---
if page == "🏠 Dashboard":
    st.title("☕ Gies Coffee Shop Dashboard")
    st.markdown("### Welcome to the Gies Coffee Shop management system!")
    st.markdown("This application is running on an **EC2 instance** and connected to a **MySQL database** - both on the same server.")

    col1, col2, col3, col4 = st.columns(4)

    total_rev = run_query("SELECT SUM(total_amount) as rev FROM daily_sales")
    total_tx = run_query("SELECT COUNT(*) as cnt FROM daily_sales")
    avg_order = run_query("SELECT AVG(total_amount) as avg_amt FROM daily_sales")
    menu_count = run_query("SELECT COUNT(*) as cnt FROM menu_items WHERE available = TRUE")

    col1.metric("Total Revenue", f"${float(total_rev['rev'][0]):,.2f}")
    col2.metric("Total Transactions", f"{int(total_tx['cnt'][0])}")
    col3.metric("Avg Transaction", f"${float(avg_order['avg_amt'][0]):,.2f}")
    col4.metric("Menu Items", f"{int(menu_count['cnt'][0])}")

    st.markdown("---")
    st.markdown("### 💡 How This Works")
    st.markdown("""
    | Component | Technology | Running On |
    |-----------|-----------|------------|
    | Web Application | Python + Streamlit | This EC2 (port 8501) |
    | Database | MySQL (MariaDB) | This EC2 (port 3306) |
    | Data | 60 transactions, 20 menu items | Stored in MySQL |
    """)

    st.info("🎓 **Students:** You can connect to this database from your CloudShell!")

# --- Menu ---
elif page == "📋 Menu":
    st.title("📋 Our Menu")
    menu = run_query("SELECT product_name, category, price, available FROM menu_items ORDER BY category, product_name")

    for cat in menu['category'].unique():
        st.subheader(f"{'☕' if cat=='Coffee' else '🍵' if cat=='Tea' else '🥐' if cat=='Pastry' else '🍽️' if cat=='Food' else '🥤'} {cat}")
        cat_items = menu[menu['category'] == cat]
        cols = st.columns(3)
        for i, (_, item) in enumerate(cat_items.iterrows()):
            with cols[i % 3]:
                status = "✅" if item['available'] else "❌"
                st.markdown(f"**{item['product_name']}** - ${float(item['price']):.2f} {status}")

# --- Sales Analytics ---
elif page == "📊 Sales Analytics":
    st.title("📊 Sales Analytics")

    st.subheader("Daily Revenue")
    daily = run_query("SELECT sale_date, SUM(total_amount) as revenue, COUNT(*) as transactions FROM daily_sales GROUP BY sale_date ORDER BY sale_date")
    daily['revenue'] = daily['revenue'].astype(float)
    st.bar_chart(daily.set_index('sale_date')['revenue'])

    col1, col2 = st.columns(2)

    with col1:
        st.subheader("Top 5 Products by Revenue")
        top = run_query("SELECT product_name, SUM(total_amount) as revenue FROM daily_sales GROUP BY product_name ORDER BY revenue DESC LIMIT 5")
        st.dataframe(top, use_container_width=True)

    with col2:
        st.subheader("Revenue by Category")
        cats = run_query("SELECT category, SUM(total_amount) as revenue, COUNT(*) as orders FROM daily_sales GROUP BY category ORDER BY revenue DESC")
        st.dataframe(cats, use_container_width=True)

    st.subheader("Payment Method Breakdown")
    pay = run_query("SELECT payment_method, COUNT(*) as count, SUM(total_amount) as total FROM daily_sales GROUP BY payment_method")
    st.dataframe(pay, use_container_width=True)

    st.subheader("Customer Type Analysis")
    cust = run_query("SELECT customer_type, COUNT(*) as orders, SUM(total_amount) as revenue, AVG(total_amount) as avg_order FROM daily_sales GROUP BY customer_type")
    st.dataframe(cust, use_container_width=True)

# --- Place Order ---
elif page == "🛒 Place Order":
    st.title("🛒 Place an Order")
    st.markdown("*Try placing an order - it writes directly to the MySQL database!*")

    menu = run_query("SELECT product_name, category, price FROM menu_items WHERE available = TRUE ORDER BY category, product_name")

    with st.form("order_form"):
        name = st.text_input("Your Name", placeholder="e.g., Illini Student")
        product = st.selectbox("Choose a Product", menu['product_name'].tolist())
        quantity = st.number_input("Quantity", min_value=1, max_value=10, value=1)
        submitted = st.form_submit_button("☕ Place Order")

        if submitted and name:
            run_insert(
                "INSERT INTO customer_orders (customer_name, product_name, quantity) VALUES (%s, %s, %s)",
                (name, product, quantity)
            )
            price = float(menu[menu['product_name'] == product]['price'].values[0])
            st.success(f"Order placed! {quantity}x {product} for {name} - Total: ${price * quantity:.2f}")
            st.balloons()
        elif submitted:
            st.warning("Please enter your name!")

# --- Recent Orders ---
elif page == "📝 Recent Orders":
    st.title("📝 Recent Customer Orders")
    st.markdown("*Orders placed through this app (live from the database)*")

    orders = run_query("""
        SELECT co.order_id, co.customer_name, co.product_name, co.quantity,
               mi.price, (co.quantity * mi.price) as total, co.order_time
        FROM customer_orders co
        JOIN menu_items mi ON co.product_name = mi.product_name
        ORDER BY co.order_time DESC
        LIMIT 20
    """)

    if len(orders) > 0:
        st.dataframe(orders, use_container_width=True)
        total = float(orders['total'].sum())
        st.metric("Total from Recent Orders", f"${total:,.2f}")
    else:
        st.info("No orders yet! Go to 'Place Order' to add one.")

    if st.button("🔄 Refresh"):
        st.rerun()
