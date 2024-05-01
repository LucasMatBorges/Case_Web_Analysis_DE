from flask import Flask, render_template
import psycopg2
from psycopg2.extras import DictCursor

app = Flask(__name__, template_folder='template')

# Database connection parameters
DATABASE_NAME = 'webshop'
USER_NAME = 'postgres'
PASSWORD = input("DataBase Password")
HOST_ADDRESS = 'localhost'

@app.route('/metrics/orders', methods=['GET'])
def get_metrics():
    # Connect to the database
    conn = psycopg2.connect(dbname=DATABASE_NAME, user=USER_NAME, password=PASSWORD, host=HOST_ADDRESS)
    cursor = conn.cursor(cursor_factory=DictCursor)

    # Define the SQL query
    query = """
        SELECT 
            (SELECT AVG(total_duration) FROM durationfirstpurchase) AS avg_total_duration,
            (SELECT AVG(sessions_before_purchase) FROM amountsessions) AS avg_sessions_before_purchase;
    """

    # Execute the query
    cursor.execute(query)
    result = cursor.fetchone()

    # Close database connection
    cursor.close()
    conn.close()

    # Render an HTML template with data
    return render_template('metrics.html', 
                           median_visits_before_order=round(result['avg_sessions_before_purchase'],3),
                           median_session_duration_minutes_before_order=round(result['avg_total_duration'],3))

if __name__ == '__main__':
    app.run(debug=True)
# Link with the Web API: http://127.0.0.1:5000/metrics/orders
