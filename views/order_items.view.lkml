view: order_items {
  sql_table_name: `venkata_bq.order_items` ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension_group: delivered {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.delivered_at ;;
  }
  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }
  dimension: order_id {
    #label: "TESTING2"
    label:
    "
    {% if _view._name == users %}
    ORDER ITEMS ID
    {% elsif _view._name == orders %}
    Order's Id
    {% else %}
    Gowri
    {% endif %}
    "
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }
  dimension: product_id {
    label:
    "
    {% if _view._name == users %}
    User's Id
    {% elsif _view._name == orders %}
    Order's Id
    {% else %}
    ORDER ITEMS's Id
    {% endif %}
    "
    type: number
    # hidden: yes
    sql: ${products.id} ;;
  }
  dimension_group: returned {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.returned_at ;;
  }
  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: gowri_testing
  }
  dimension_group: shipped {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.shipped_at ;;
  }
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }
  dimension: user_id {
    label:
    "{% if _view._name == users %} ORDER ITEMS ID {% elsif _view._name == orders %} Order's Id {% else %} User's Id {% endif %}"
    type: number
    # hidden: yes
    #view_label: "{% if _view._name == order_items %} TESTING1 {% else %} TESTING2 {% endif %}"
    sql: ${users.id} ;;
  }
  measure: count {
    type: sum
    drill_fields: [detail*]
    #filters: [status: "Processing"]
    sql:
    CASE
    WHEN ${status} = {% parameter category_to_count %}
    THEN 1
    ELSE 0
    END
    ;;
  }

  parameter: category_to_count {
    type: string
  }

measure: count_actual1 {
  type: count
}


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  users.last_name,
  users.id,
  users.first_name,
  inventory_items.id,
  inventory_items.product_name,
  products.name,
  products.id,
  orders.order_id
  ]
  }

}
