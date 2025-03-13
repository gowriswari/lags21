view: sdt {
    derived_table: {
      sql: -- Did not use order_items::rollup__inventory_items_created_month__inventory_items_id__inventory_items_product_category__inventory_items_product_department; contained filters not in the query: inventory_items.created_month
              SELECT
                  order_items.order_id  AS order_items_order_id,
                  COUNT(*) AS order_items_count
              FROM `venkata_bq.order_items`  AS order_items
              LEFT JOIN `venkata_bq.users`  AS users ON order_items.user_id = users.id
              WHERE
              {% condition users_city %} users.city {% endcondition %}
              GROUP BY
                  1
              ORDER BY
                  2 DESC
              LIMIT 500 ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: order_items_order_id {
      type: number
      sql: ${TABLE}.order_items_order_id ;;
    }

    dimension: order_items_count {
      type: number
      sql: ${TABLE}.order_items_count ;;
    }

    set: detail {
      fields: [
        order_items_order_id,
        order_items_count
      ]
    }
     filter: users_city {
       type: string
      full_suggestions: yes
     }

  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: sdt {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
