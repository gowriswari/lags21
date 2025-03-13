view: users {

  sql_table_name: `venkata_bq.users` ;;
  #required_access_grants: [test1]
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    label:
    "
    {% if _view._name == users %} User's Id {% else %} ORDER ITEMS's Id {% endif %}
    "

  #label:"yes"
    type: number
    sql: ${TABLE}.id ;;
  }
  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }
  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
   # required_access_grants: [test1]
  }
  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }
  dimension_group: created {
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.created_at ;;
  }
  dimension: order_items_id {
    type: number
    sql: ${TABLE}.order_items_id ;;
  }
  #dimension: email {
 #   type: string
 #   sql: ${TABLE}.email ;;
 # }
  dimension: email {
    #label: "{% if _model._name == 'gowri_bq' %} Looker Registered Email Address {% else %} External Email Address {% endif %}"
    type: string
    sql: ${TABLE}.email ;;
  }
  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }
  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }
  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }
  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }
  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }
  dimension: state {
    type: string
    description: "{% if _field._name == state %} true {% endif %}"
    sql: ${TABLE}.state ;;
   # sql: {{ users.state._in_query | sql_boolean }};;
  }
  dimension: state_test {
    type:string
    sql: {% if _model._name == "gowri_bq" %} true
    {% else %} false
    {% endif %};;
  }
  dimension: street_address {
    type: string
    sql: ${TABLE}.street_address ;;
  }
  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }
  measure: test121{
    type: sum
    drill_fields: [detail*]
    sql: COALESCE(${age}) ;;
  }

  filter: new_filter_test{
    type: date
  }

  dimension: filter_start{
    type: date
    sql: {% date_start new_filter_test %} ;;
  }

  dimension: filter_end{
    type: date
    sql: {% date_end new_filter_test %} ;;

  }



  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
  id,
  last_name,
  first_name,
  events.count,
  order_items.count,
  orders.count
  ]
  }

}
