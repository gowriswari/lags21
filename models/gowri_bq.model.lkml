connection: "gowri-bigquery"
#label: "Gowri testing"
# include all the views
include: "/views/**/*.view.lkml"
#include: "/test.view.lkml"
#include: "/test1.dashboard.lookml"
#include: "/test1/test_model.model.lkml"

fiscal_month_offset: 3

named_value_format: gowri_testing {
  value_format: "\"€\"0.000,\" K\""
  strict_value_format: yes
}

datagroup: gowri_bq_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  sql_trigger: SELECT EXTRACT(HOUR FROM CURRENT_TIMESTAMP()) ;;
  max_cache_age: "1 hour"
}

persist_with: gowri_bq_default_datagroup

#access_grant: test1 {
#  user_attribute: test_attribute
#  allowed_values: [ "Ada" ]
#}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: events {
  sql_always_where: ${created_date} > '2025-01-01' ;;
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
 #view_label: "Job owner"
  view_label: "Events"
  join: users {
   view_label: "Events"
    #view_label: "Order Items"
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    view_label: "Events inventory"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    view_label: "Events"
    type: left_outer
    sql_on: ${order_items.product_id} = ${products.id} ;;
    relationship: many_to_one
    #fields: [products.id]
  }

  join: orders {
   view_label: "Events inventory"
    #required_access_grants: [test1]
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
    relationship: many_to_one
    #fields: []
  }

  join: distribution_centers {
    #view_label: "Job owner1"
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

}

explore: sdt {}

explore: users {
  #required_access_grants: [test1]
  access_filter: {
    field: city
    user_attribute: test_attribute
  }
}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: distribution_centers {
  #extension: required
}

explore: inventory_items {
# extends: [distribution_centers]
  #join: products {
  #  type: left_outer
   # sql_on: ${inventory_items.product_id} = ${products.id} ;;
    #relationship: many_to_one
  #}

  #join: distribution_centers {
   # type: left_outer
    #sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    #relationship: many_to_one
  #}
}
# Place in `gowri_bq` model
# Place in `gowri_bq` model


# Place in `gowri_bq` model
